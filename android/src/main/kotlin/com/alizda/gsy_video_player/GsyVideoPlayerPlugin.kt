package com.alizda.gsy_video_player

import android.app.Activity
import android.app.PictureInPictureParams
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.util.LongSparseArray
import androidx.annotation.RequiresApi
import com.shuyu.gsyvideoplayer.GSYVideoManager
import io.flutter.embedding.engine.loader.FlutterLoader
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry

/** GsyVideoPlayerPlugin */
class GsyVideoPlayerPlugin : FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler {
    private val videoPlayers = LongSparseArray<GsyVideoPlayer>()
    private var flutterState: FlutterState? = null
    private var activity: Activity? = null
    private var pipHandler: Handler? = null
    private var pipRunnable: Runnable? = null
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val loader = FlutterLoader()
        flutterState = FlutterState(
            binding.applicationContext,
            binding.binaryMessenger, object : KeyForAssetFn {
                override fun get(asset: String?): String {
                    return loader.getLookupKeyForAsset(
                        asset!!
                    )
                }

            }, object : KeyForAssetAndPackageName {
                override fun get(asset: String?, packageName: String?): String {
                    return loader.getLookupKeyForAsset(
                        asset!!, packageName!!
                    )
                }
            },
            binding.textureRegistry
        )
        GsyVideoShared.flutterState = flutterState
        flutterState?.startListening(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        if (flutterState == null) {
            Log.wtf(TAG, "Detached from the engine before registering to it.")
        }
        disposeAllPlayers()
        flutterState?.stopListening()
        flutterState = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        GsyVideoShared.activity = binding.activity
        GsyVideoShared.binding = binding
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        GsyVideoShared.activity = null
        GsyVideoShared.binding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        GsyVideoShared.activity = binding.activity
        GsyVideoShared.binding = binding
    }

    override fun onDetachedFromActivity() {
        GsyVideoShared.activity = null
        GsyVideoShared.binding = null
    }
    private fun disposeAllPlayers() {
        for (i in 0 until videoPlayers.size()) {
            videoPlayers.valueAt(i).dispose()
        }
        videoPlayers.clear()
        GSYVideoManager.releaseAllVideos();
    }

    private fun enablePictureInPicture(player: GsyVideoPlayer) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            activity!!.enterPictureInPictureMode(PictureInPictureParams.Builder().build())
            startPictureInPictureListenerTimer(player)
            player.onPictureInPictureStatusChanged(true)
        }
    }

    private fun disablePictureInPicture(player: GsyVideoPlayer) {
        stopPipHandler()
        activity!!.moveTaskToBack(false)
        player.onPictureInPictureStatusChanged(false)
    }

    private fun startPictureInPictureListenerTimer(player: GsyVideoPlayer) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            pipHandler = Handler(Looper.getMainLooper())
            pipRunnable = Runnable {
                if (activity!!.isInPictureInPictureMode) {
                    pipHandler!!.postDelayed(pipRunnable!!, 100)
                } else {
                    player.onPictureInPictureStatusChanged(false)
                    stopPipHandler()
                }
            }
            pipHandler!!.postDelayed(pipRunnable!!, 1)
        }
    }

    private fun stopPipHandler() {
        if (pipHandler != null) {
            pipHandler!!.removeCallbacksAndMessages(null)
            pipHandler = null
        }
        pipRunnable = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (flutterState == null || flutterState?.textureRegistry == null) {
            result.error(
                "no_activity",
                "GsyVideoPlayer plugin requires a foreground activity",
                null
            )
            return
        }
        when (call.method) {
            "init" -> {
                disposeAllPlayers()
            }

            "create" -> {
                val textureEntry: TextureRegistry.SurfaceProducer =
                    flutterState!!.textureRegistry!!.createSurfaceProducer()
                val eventChannel = EventChannel(
                    flutterState?.binaryMessenger, EVENTS_CHANNEL + textureEntry.id()
                )
                val player = GsyVideoPlayer(
                    flutterState?.applicationContext!!, eventChannel, textureEntry, call, result
                )
                videoPlayers.put(textureEntry.id(), player)
            }

            else -> {
                val textureId = (call.argument<Any>("textureId") as Number?)!!.toLong()
                val player = videoPlayers[textureId]
                if (player == null) {
                    result.error(
                        "Unknown textureId",
                        "No video player associated with texture id $textureId",
                        null
                    )
                    return
                }
                if (call.method.equals("enablePictureInPicture")) {
                    enablePictureInPicture(player)
                    result.success(null)
                } else if (call.method.equals("disablePictureInPicture")) {
                    disablePictureInPicture(player)
                    result.success(null)
                } else if (call.method.equals("isPictureInPictureSupported")) {
                    result.success(isPictureInPictureSupported())
                } else {
                    if(call.method.equals("dispose")){
                        videoPlayers.remove(textureId)
                        stopPipHandler()
                        player.dispose()
                    }
                    player.onMethodCall(call, result, textureId)
                }
            }
        }
    }

    interface KeyForAssetFn {
        operator fun get(asset: String?): String
    }

    interface KeyForAssetAndPackageName {
        operator fun get(asset: String?, packageName: String?): String
    }
    private fun isPictureInPictureSupported(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && activity != null && activity!!.packageManager
            .hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
    }
    public class FlutterState(
        val applicationContext: Context,
        val binaryMessenger: BinaryMessenger,
        val keyForAsset: KeyForAssetFn,
        val keyForAssetAndPackageName: KeyForAssetAndPackageName,
        val textureRegistry: TextureRegistry?
    ) {
        private val methodChannel: MethodChannel = MethodChannel(binaryMessenger, METHODS_CHANNEL)

        fun startListening(methodCallHandler: GsyVideoPlayerPlugin?) {
            methodChannel.setMethodCallHandler(methodCallHandler)
        }

        fun stopListening() {
            methodChannel.setMethodCallHandler(null)
        }

    }

    companion object {

        const val TAG = "GSY_VIDEO_PLAYER"
        private const val METHODS_CHANNEL = "gsy_video_player_channel/platform_view_methods"
        private const val EVENTS_CHANNEL = "gsy_video_player_channel/platform_view_events"

        @Suppress("UNCHECKED_CAST")
        fun <T> getParameter(parameters: Map<String, Any?>?, key: String, defaultValue: T): T {
            if (parameters?.containsKey(key) == true) {
                val value = parameters[key]
                if (value != null) {
                    return value as T
                }
            }
            return defaultValue
        }
    }
}


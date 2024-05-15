package com.alizda.gsy_video_player

import android.content.Context
import android.os.Build
import android.view.Surface
import androidx.annotation.RequiresApi
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry

@RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
class GsyVideoPlayer(
        private val context: Context,
        private val eventChannel: EventChannel,
        private val textureEntry: TextureRegistry.SurfaceTextureEntry,
        private val call: MethodCall,
        private val result: MethodChannel.Result
) {
    private var player: CustomVideoPlayer? = null
    private val eventSink = QueuingEventSink()
    private var isInitialized = false
    private var surface: Surface? = null
    var gsyVideoOptionBuilder: GSYVideoOptionBuilder? = null
    private var customBasicApi: CustomBasicApi ? = null
    private var customGSYVideoManagerApi :CustomGSYVideoManagerApi ? = null
    private var customGSYVideoTypeApi: CustomGSYVideoTypeApi = CustomGSYVideoTypeApi()
    private var customOrientationUtilsApi: CustomOrientationUtilsApi ? = null
    private var customGSYMediaPlayerListenerApi: CustomGSYMediaPlayerListenerApi ? = null
    private var customGSYVideoPlayerApi: CustomGSYVideoPlayerApi ? = null
    private var  customMethodCallApi:CustomMethodCallApi ? = null
    init {
        surface = Surface(textureEntry.surfaceTexture())
        player = CustomVideoPlayer(context)
        setupVideoPlayer(eventChannel, result)
    }

    fun getCurrentPlayer() = player
    private fun setupVideoPlayer(
        eventChannel: EventChannel, result: MethodChannel.Result
    ) {
        eventChannel.setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(o: Any?, sink: EventChannel.EventSink) {
                    eventSink.setDelegate(sink)
                }

                override fun onCancel(o: Any?) {
                    eventSink.setDelegate(null)
                }
            })
        GSYVideoManager.instance().setDisplay(surface);
        player?.let {
            customBasicApi = CustomBasicApi(it,context)
            customGSYVideoManagerApi = CustomGSYVideoManagerApi(context)
            customOrientationUtilsApi = CustomOrientationUtilsApi(it,context)
            customGSYMediaPlayerListenerApi = CustomGSYMediaPlayerListenerApi(it)
            customGSYVideoPlayerApi = CustomGSYVideoPlayerApi(this,context,textureEntry.id())
            customMethodCallApi = CustomMethodCallApi(this,context, customGSYVideoManagerApi!!, customBasicApi!!,customGSYVideoPlayerApi!!,customGSYVideoTypeApi,customOrientationUtilsApi!!)
            it.seteventSink(eventSink)
            it.setCustomOrientationUtilsApi(customOrientationUtilsApi!!)
        }
        val reply: MutableMap<String, Any> = HashMap()
        reply["textureId"] = textureEntry.id()
        result.success(reply)
    }

    fun dispose() {
        customGSYVideoPlayerApi!!.dispose()
    }
    fun onMethodCall(call: MethodCall, result: MethodChannel.Result, textureId: Long){
        customMethodCallApi!!.handleMethod(call,result)
    }
}
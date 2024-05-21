package com.alizda.gsy_video_player

import android.content.Context
import android.view.Surface
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry

class GsyVideoPlayer(
        private val context: Context,
        private val eventChannel: EventChannel,
        private val textureEntry: TextureRegistry.SurfaceProducer,
        private val call: MethodCall,
        private val result: MethodChannel.Result
) {
    private var player: CustomVideoPlayer? = null
    private val eventSink = QueuingEventSink()
    private var isInitialized = false
    private var surface: Surface? = null
    var gsyVideoOptionBuilder: GSYVideoOptionBuilder? = null
    private var customBasicApi: CustomBasicApi? = null
    private var customGSYVideoManagerApi: CustomGSYVideoManagerApi? = null
    private var customGSYVideoTypeApi: CustomGSYVideoTypeApi = CustomGSYVideoTypeApi()
    private var customOrientationUtilsApi: CustomOrientationUtilsApi? = null
    private var customGSYMediaPlayerListenerApi: CustomGSYMediaPlayerListenerApi? = null
    private var customGSYVideoPlayerApi: CustomGSYVideoPlayerApi? = null
    private var customMethodCallApi: CustomMethodCallApi? = null

    init {
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
                        if(!isInitialized && customGSYMediaPlayerListenerApi != null){
                            isInitialized = true
                            customGSYMediaPlayerListenerApi!!.sendInitialized(eventSink)
                        }
                        eventSink.setDelegate(sink)
                    }
                    override fun onCancel(o: Any?) {
                        eventSink.setDelegate(null)
                    }
                })
        if(player != null){
            customBasicApi = CustomBasicApi(player!!, context)
            customGSYVideoManagerApi = CustomGSYVideoManagerApi(context)
            customOrientationUtilsApi = CustomOrientationUtilsApi(player!!, context)
            customGSYMediaPlayerListenerApi = CustomGSYMediaPlayerListenerApi(player!!)
            customGSYVideoPlayerApi = CustomGSYVideoPlayerApi(this, context, textureEntry.id())
            customMethodCallApi = CustomMethodCallApi(this, context, customGSYVideoManagerApi!!, customBasicApi!!, customGSYVideoPlayerApi!!, customGSYVideoTypeApi, customOrientationUtilsApi!!,eventSink)
            player!!.setEventSink(eventSink)
            player!!.setCustomOrientationUtilsApi(customOrientationUtilsApi!!)
            player!!.setVideoDisplay(textureEntry)
        }
        val reply: MutableMap<String, Any> = HashMap()
        reply["textureId"] = textureEntry.id()
        result.success(reply)
    }

    fun dispose() {
        if(customOrientationUtilsApi!=null){
            customOrientationUtilsApi!!.releaseListener();
            player!!.videoIsInitialized = false
        }
        customGSYVideoPlayerApi!!.dispose()
    }

    fun onMethodCall(call: MethodCall, result: MethodChannel.Result, textureId: Long) {
        customMethodCallApi!!.handleMethod(call, result)
    }

    fun onPictureInPictureStatusChanged(inPip: Boolean) {
        val event: MutableMap<String, Any> = HashMap()
        event["event"] = if (inPip) "pipStart" else "pipStop"
        eventSink.success(event)
    }
}
package com.alizda.gsy_video_player

import android.content.Context
import android.view.View
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import com.shuyu.gsyvideoplayer.listener.GSYVideoProgressListener
import com.shuyu.gsyvideoplayer.listener.VideoAllCallBack
import com.shuyu.gsyvideoplayer.utils.GSYVideoType
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView



class GsyVideoPlayerView(private val context: Context, messenger: BinaryMessenger, private val id: Int, private val params: Map<String?, Any?>?) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler, PluginRegistry.RequestPermissionsResultListener, VideoAllCallBack, GSYVideoProgressListener {

    private val channel: MethodChannel = MethodChannel(messenger, METHODS_CHANNEL)
    private var sink: EventChannel.EventSink? = null
    private var event: EventChannel = EventChannel(messenger, EVENTS_CHANNEL + id)
    private var videoPlayer: CustomVideoPlayer = CustomVideoPlayer(context)
    private var gsyVideoOptionBuilder: GSYVideoOptionBuilder = CustomGSYVideoOptionBuilder(videoPlayer)
    private var customVideoAllCallBack: CustomVideoAllCallBack = CustomVideoAllCallBack()
    private var orientationUtils: CustomOrientationUtils = CustomOrientationUtils(videoPlayer, context)
    private  var customGSYVideoManagerApi :CustomGSYVideoManagerApi = CustomGSYVideoManagerApi(context)
    init {
        channel.setMethodCallHandler(this)
        event.setStreamHandler(this)
        gsyVideoOptionBuilder.setGSYVideoProgressListener(this)
    }
    override fun getView(): View = videoPlayer
    override fun dispose() {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {

        }
    }


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.sink = events
    }

    override fun onCancel(arguments: Any?) {
        sink = null
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        TODO("Not yet implemented")
    }

    companion object {
        private const val TAG = "GSY_VIDEO_PLAYER"
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

    override fun onStartPrepared(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onStartPrepared(it, url, objects) }
    }

    //加载成功，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onPrepared(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onPrepared(it, url, objects) }
    }

    //点击了开始按键播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStartIcon(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickStartIcon(it, url, objects) }
    }

    //点击了错误状态下的开始按键，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStartError(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickStartError(it, url, objects) }
    }

    //点击了播放状态下的开始按键--->停止，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStop(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickStop(it, url, objects) }
    }

    override fun onClickStopFullscreen(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickStopFullscreen(it, url, objects) }
    }

    //点击了暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickResume(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickResume(it, url, objects) }
    }

    //点击了全屏暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickResumeFullscreen(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickResumeFullscreen(it, url, objects) }
    }

    //点击了空白弹出seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickSeekbar(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickSeekbar(it, url, objects) }
    }

    //点击了全屏的seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickSeekbarFullscreen(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickSeekbarFullscreen(it, url, objects) }
    }

    //播放完了，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onAutoComplete(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onAutoComplete(it, url, objects) }
    }

    override fun onEnterFullscreen(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onEnterFullscreen(it, url, objects) }
    }

    override fun onQuitFullscreen(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onQuitFullscreen(it, url, objects) }
    }

    override fun onQuitSmallWidget(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onQuitSmallWidget(it, url, objects) }
    }

    override fun onEnterSmallWidget(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onEnterSmallWidget(it, url, objects) }
    }

    override fun onTouchScreenSeekVolume(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onTouchScreenSeekVolume(it, url, objects) }
    }

    override fun onTouchScreenSeekPosition(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onTouchScreenSeekPosition(it, url, objects) }
    }

    override fun onTouchScreenSeekLight(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onTouchScreenSeekLight(it, url, objects) }
    }

    override fun onPlayError(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onPlayError(it, url, objects) }
    }

    override fun onClickStartThumb(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickStartThumb(it, url, objects) }
    }

    override fun onClickBlank(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickBlank(it, url, objects) }
    }

    override fun onClickBlankFullscreen(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onClickBlankFullscreen(it, url, objects) }
    }

    override fun onComplete(url: String, vararg objects: Any) {
        sink?.let { customVideoAllCallBack.onComplete(it, url, objects) }
    }

    override fun onProgress(progress: Long, secProgress: Long, currentPosition: Long, duration: Long) {
        sink?.let { customVideoAllCallBack.onProgress(it, progress, secProgress, currentPosition, duration) }
    }
}
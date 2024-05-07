package com.alizda.gsy_video_player

import android.content.Context
import android.view.View
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.listener.GSYMediaPlayerListener
import com.shuyu.gsyvideoplayer.listener.GSYVideoProgressListener
import com.shuyu.gsyvideoplayer.listener.VideoAllCallBack
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView


class GsyVideoPlayerView(private val context: Context, messenger: BinaryMessenger, private val id: Int, private val params: Map<*, *>?) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler, PluginRegistry.RequestPermissionsResultListener, VideoAllCallBack, GSYVideoProgressListener, GSYMediaPlayerListener {

    private val channel: MethodChannel = MethodChannel(messenger, METHODS_CHANNEL)
    private val eventSink = QueuingEventSink()
    private var event: EventChannel = EventChannel(messenger, EVENTS_CHANNEL + id)
    private var videoPlayer: CustomVideoPlayer = CustomVideoPlayer(context)
    private var gsyVideoOptionBuilder: CustomGSYVideoOptionBuilder = CustomGSYVideoOptionBuilder(videoPlayer)
    private var customVideoAllCallBack: CustomVideoAllCallBack = CustomVideoAllCallBack(videoPlayer)
    private var customGSYMediaPlayerListener: CustomGSYMediaPlayerListener = CustomGSYMediaPlayerListener(videoPlayer)
    private var customBasicApi: CustomBasicApi = CustomBasicApi(videoPlayer,context)
    private var orientationUtils: CustomOrientationUtils = CustomOrientationUtils(videoPlayer, context)
    private  var customGSYVideoManagerApi :CustomGSYVideoManagerApi = CustomGSYVideoManagerApi(context)
    private var gSYVideoPlayer: GSYVideoPlayer = GSYVideoPlayer(videoPlayer, context, id)
    private var customGSYVideoType: CustomGSYVideoType = CustomGSYVideoType()

    private var  customMethodCall:CustomMethodCall = CustomMethodCall(videoPlayer,context,id,gsyVideoOptionBuilder,customGSYVideoManagerApi,customBasicApi,gSYVideoPlayer,customGSYVideoType)
    init {
        channel.setMethodCallHandler(this)
        event.setStreamHandler(this)
        videoPlayer.setGSYVideoProgressListener(this)
        videoPlayer.setVideoAllCallBack(this)
        if (GSYVideoManager.instance().listener() != null) {
            GSYVideoManager.instance().listener().onCompletion();
        }
        GSYVideoManager.instance().setListener(this);
    }
    override fun getView(): View = videoPlayer
    override fun dispose() {
        if(isInitialized){
            isInitialized = false
            GSYVideoManager.instance().releaseMediaPlayer();
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        customMethodCall.handleMethod(call,result)
    }


    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        eventSink.setDelegate(sink)
    }

    override fun onCancel(arguments: Any?) {
        eventSink.setDelegate(null)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        TODO("Not yet implemented")
    }

    companion object {

        const val TAG = "GSY_VIDEO_PLAYER"
        private const val METHODS_CHANNEL = "gsy_video_player_channel/platform_view_methods"
        private const val EVENTS_CHANNEL = "gsy_video_player_channel/platform_view_events"
        var isInitialized = false
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
        customVideoAllCallBack.onStartPrepared(eventSink, url, objects)
    }

    //加载成功，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onPrepared(url: String, vararg objects: Any) {
        customVideoAllCallBack.onPrepared(eventSink, url, objects)
    }

    //点击了开始按键播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStartIcon(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickStartIcon(eventSink, url, objects)
    }

    //点击了错误状态下的开始按键，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStartError(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickStartError(eventSink, url, objects)
    }

    //点击了播放状态下的开始按键--->停止，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStop(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickStop(eventSink, url, objects)
    }

    override fun onClickStopFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickStopFullscreen(eventSink, url, objects)
    }
    //点击了暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickResume(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickResume(eventSink, url, objects)
    }

    //点击了全屏暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickResumeFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickResumeFullscreen(eventSink, url, objects)
    }

    //点击了空白弹出seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickSeekbar(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickSeekbar(eventSink, url, objects)
    }

    //点击了全屏的seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickSeekbarFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickSeekbarFullscreen(eventSink, url, objects)
    }

    //播放完了，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onAutoComplete(url: String, vararg objects: Any) {
        customVideoAllCallBack.onAutoComplete(eventSink, url, objects)
    }

    override fun onEnterFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBack.onEnterFullscreen(eventSink, url, objects)
    }

    override fun onQuitFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBack.onQuitFullscreen(eventSink, url, objects)
    }

    override fun onQuitSmallWidget(url: String, vararg objects: Any) {
        customVideoAllCallBack.onQuitSmallWidget(eventSink, url, objects)
    }

    override fun onEnterSmallWidget(url: String, vararg objects: Any) {
        customVideoAllCallBack.onEnterSmallWidget(eventSink, url, objects)
    }

    override fun onTouchScreenSeekVolume(url: String, vararg objects: Any) {
        customVideoAllCallBack.onTouchScreenSeekVolume(eventSink, url, objects)
    }

    override fun onTouchScreenSeekPosition(url: String, vararg objects: Any) {
        customVideoAllCallBack.onTouchScreenSeekPosition(eventSink, url, objects)
    }

    override fun onTouchScreenSeekLight(url: String, vararg objects: Any) {
        customVideoAllCallBack.onTouchScreenSeekLight(eventSink, url, objects)
    }

    override fun onPlayError(url: String, vararg objects: Any) {
        customVideoAllCallBack.onPlayError(eventSink, url, objects)
    }

    override fun onClickStartThumb(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickStartThumb(eventSink, url, objects)
    }

    override fun onClickBlank(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickBlank(eventSink, url, objects)
    }

    override fun onClickBlankFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBack.onClickBlankFullscreen(eventSink, url, objects)
    }

    override fun onComplete(url: String, vararg objects: Any) {
        customVideoAllCallBack.onComplete(eventSink, url, objects)
    }

    override fun onProgress(progress: Long, secProgress: Long, currentPosition: Long, duration: Long) {
        customVideoAllCallBack.onProgress(eventSink, progress, secProgress, currentPosition, duration)
    }

    override fun onPrepared() {
        if (!isInitialized) {
            isInitialized = true
            customGSYMediaPlayerListener.sendInitialized(eventSink)
        }
        customGSYMediaPlayerListener.onPrepared(eventSink)
    }

    override fun onAutoCompletion() {
        customGSYMediaPlayerListener.onAutoCompletion(eventSink)
    }

    override fun onCompletion() {
        customGSYMediaPlayerListener.onCompletion(eventSink)
    }

    override fun onBufferingUpdate(percent: Int) {
        customGSYMediaPlayerListener.onBufferingUpdate(eventSink,percent)
    }

    override fun onSeekComplete() {
        customGSYMediaPlayerListener.onSeekComplete(eventSink)
    }

    override fun onError(what: Int, extra: Int) {
        customGSYMediaPlayerListener.onError(eventSink,what,extra)
    }

    override fun onInfo(what: Int, extra: Int) {
        customGSYMediaPlayerListener.onInfo(eventSink,what,extra)
    }

    override fun onVideoSizeChanged() {
        customGSYMediaPlayerListener.onVideoSizeChanged(eventSink)
    }

    override fun onBackFullscreen() {
        customGSYMediaPlayerListener.onBackFullscreen(eventSink)
    }

    override fun onVideoPause() {
        customGSYMediaPlayerListener.onVideoPause(eventSink)
    }

    override fun onVideoResume() {
        customGSYMediaPlayerListener.onVideoResume(eventSink)
    }

    override fun onVideoResume(seek: Boolean) {
        customGSYMediaPlayerListener.onVideoResume(eventSink,seek)
    }
}
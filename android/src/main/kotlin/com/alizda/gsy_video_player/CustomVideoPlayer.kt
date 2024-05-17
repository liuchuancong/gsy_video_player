package com.alizda.gsy_video_player


import android.app.Activity
import android.content.Context
import android.content.res.Configuration
import android.graphics.Color
import android.util.AttributeSet
import android.util.Log
import android.view.MotionEvent
import android.view.Surface
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import com.shuyu.gsyvideoplayer.listener.GSYVideoProgressListener
import com.shuyu.gsyvideoplayer.listener.VideoAllCallBack
import com.shuyu.gsyvideoplayer.utils.GSYVideoType
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer
import com.shuyu.gsyvideoplayer.video.base.GSYBaseVideoPlayer
import com.shuyu.gsyvideoplayer.video.base.GSYVideoPlayer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel


class CustomVideoPlayer : StandardGSYVideoPlayer, GSYVideoProgressListener, VideoAllCallBack {
    private var customGSYMediaPlayerListenerApi: CustomGSYMediaPlayerListenerApi = CustomGSYMediaPlayerListenerApi(this)
    private var customVideoAllCallBackApi: CustomVideoAllCallBackApi = CustomVideoAllCallBackApi(this)
    private var isLinkScroll = false
    private var orientationUtils: CustomOrientationUtilsApi? = null
    private var videoIsInitialized: Boolean = false
    private var eventSink: QueuingEventSink ? = null
    private var surface: Surface? = null
    constructor(context: Context?, fullFlag: Boolean?) : super(context, fullFlag)
    constructor(context: Context?) : super(context)
    constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs)
    override fun init(context: Context) {
        super.init(context)
    }
    fun setEventSink(sink: QueuingEventSink){
        eventSink = sink
    }
    fun setCustomOrientationUtilsApi(utils: CustomOrientationUtilsApi){
        orientationUtils = utils
    }

    fun setVideoDisplay(surface: Surface){
        this.surface = surface
    }

    override fun clickStartIcon() {
        super.clickStartIcon()
    }

    override fun cloneParams(from: GSYBaseVideoPlayer, to: GSYBaseVideoPlayer) {
        super.cloneParams(from, to)
    }

    fun setLinkScroll(linkScroll: Boolean) {
        isLinkScroll = linkScroll
    }

    override fun onConfigurationChanged(activity: Activity?, newConfig: Configuration?, orientationUtils: OrientationUtils?) {
        super.onConfigurationChanged(activity, newConfig, orientationUtils!!)
        customGSYMediaPlayerListenerApi.onConfigurationChanged(eventSink!!)
    }


    override fun onPrepared() {
        gsyVideoManager.player.mediaPlayer.setSurface(surface)
        if (!videoIsInitialized) {
            videoIsInitialized = true
            customGSYMediaPlayerListenerApi.sendVideoPlayerInitialized(eventSink!!)
        }
        super.onPrepared()
        customGSYMediaPlayerListenerApi.onPrepared(eventSink!!)
    }


    override fun onAutoCompletion() {
        super.onAutoCompletion()
        customGSYMediaPlayerListenerApi.onAutoCompletion(eventSink!!)
    }

    override fun onCompletion() {
        super.onCompletion()
        customGSYMediaPlayerListenerApi.onCompletion(eventSink!!)
    }

    override fun onBufferingUpdate(percent: Int) {
        super.onBufferingUpdate(percent)
        customGSYMediaPlayerListenerApi.onBufferingUpdate(eventSink!!, percent)
    }

    override fun onSeekComplete() {
        super.onSeekComplete()
        customGSYMediaPlayerListenerApi.onSeekComplete(eventSink!!)
    }

    override fun onError(what: Int, extra: Int) {
        super.onError(what, extra)
        customGSYMediaPlayerListenerApi.onError(eventSink!!, what, extra)
    }

    override fun onInfo(what: Int, extra: Int) {
        super.onInfo(what, extra)
        customGSYMediaPlayerListenerApi.onInfo(eventSink!!, what, extra)
    }

    override fun onVideoSizeChanged() {
        super.onVideoSizeChanged()
        customGSYMediaPlayerListenerApi.onVideoSizeChanged(eventSink!!)
    }

    override fun onBackFullscreen() {
        super.onBackFullscreen()
        customGSYMediaPlayerListenerApi.onBackFullscreen(eventSink!!)
    }

    override fun onVideoPause() {
        super.onVideoPause()
        customGSYMediaPlayerListenerApi.onVideoPause(eventSink!!)
    }

    override fun onVideoResume() {
        super.onVideoResume()
        customGSYMediaPlayerListenerApi.onVideoResume(eventSink!!)
    }

    override fun onVideoResume(seek: Boolean) {
        super.onVideoResume(seek)
        customGSYMediaPlayerListenerApi.onVideoResume(eventSink!!, seek)
    }

    companion object {
        var autoPlay: Boolean = false
    }

    override fun onStartPrepared(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onStartPrepared(eventSink!!, url, objects)
    }

    //加载成功，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onPrepared(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onPrepared(eventSink!!, url, objects)
    }

    //点击了开始按键播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStartIcon(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickStartIcon(eventSink!!, url, objects)
    }

    //点击了错误状态下的开始按键，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStartError(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickStartError(eventSink!!, url, objects)
    }

    //点击了播放状态下的开始按键--->停止，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStop(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickStop(eventSink!!, url, objects)
    }

    override fun onClickStopFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickStopFullscreen(eventSink!!, url, objects)
    }
    //点击了暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickResume(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickResume(eventSink!!, url, objects)
    }

    //点击了全屏暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickResumeFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickResumeFullscreen(eventSink!!, url, objects)
    }

    //点击了空白弹出seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickSeekbar(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickSeekbar(eventSink!!, url, objects)
    }

    //点击了全屏的seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickSeekbarFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickSeekbarFullscreen(eventSink!!, url, objects)
    }

    //播放完了，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onAutoComplete(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onAutoComplete(eventSink!!, url, objects)
    }

    override fun onEnterFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onEnterFullscreen(eventSink!!, url, objects)
    }

    override fun onQuitFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onQuitFullscreen(eventSink!!, url, objects)
    }

    override fun onQuitSmallWidget(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onQuitSmallWidget(eventSink!!, url, objects)
    }

    override fun onEnterSmallWidget(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onEnterSmallWidget(eventSink!!, url, objects)
    }

    override fun onTouchScreenSeekVolume(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onTouchScreenSeekVolume(eventSink!!, url, objects)
    }

    override fun onTouchScreenSeekPosition(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onTouchScreenSeekPosition(eventSink!!, url, objects)
    }

    override fun onTouchScreenSeekLight(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onTouchScreenSeekLight(eventSink!!, url, objects)
    }

    override fun onPlayError(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onPlayError(eventSink!!, url, objects)
    }

    override fun onClickStartThumb(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickStartThumb(eventSink!!, url, objects)
    }

    override fun onClickBlank(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickBlank(eventSink!!, url, objects)
    }

    override fun onClickBlankFullscreen(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onClickBlankFullscreen(eventSink!!, url, objects)
    }

    override fun onComplete(url: String, vararg objects: Any) {
        customVideoAllCallBackApi.onComplete(eventSink!!, url, objects)
    }

    override fun onProgress(progress: Long, secProgress: Long, currentPosition: Long, duration: Long) {
        customVideoAllCallBackApi.onProgress(eventSink!!, progress, secProgress, currentPosition, duration)
    }
}
package com.alizda.gsy_video_player


import android.app.Activity
import android.content.Context
import android.content.res.Configuration
import android.media.MediaPlayer
import android.util.AttributeSet
import android.util.Log
import android.view.Surface
import android.widget.SeekBar
import com.aliyun.player.AliPlayer
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.listener.GSYVideoProgressListener
import com.shuyu.gsyvideoplayer.listener.VideoAllCallBack
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer
import com.shuyu.gsyvideoplayer.video.base.GSYBaseVideoPlayer
import io.flutter.view.TextureRegistry


class CustomVideoPlayer : StandardGSYVideoPlayer, GSYVideoProgressListener, VideoAllCallBack {
    private var customGSYMediaPlayerListenerApi: CustomGSYMediaPlayerListenerApi = CustomGSYMediaPlayerListenerApi(this)
    private var customVideoAllCallBackApi: CustomVideoAllCallBackApi = CustomVideoAllCallBackApi(this)
    private var isLinkScroll = false
    private var orientationUtils: CustomOrientationUtilsApi? = null
    private var videoIsInitialized: Boolean = false
    private var eventSink: QueuingEventSink? = null
    private var surface: Surface? = null
    private var textureEntry: TextureRegistry.SurfaceProducer? = null
    private var bufferEnd = false

    constructor(context: Context?, fullFlag: Boolean?) : super(context, fullFlag)
    constructor(context: Context?) : super(context)
    constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs)

    override fun init(context: Context) {
        super.init(context)
        setGSYVideoProgressListener(this)
    }

    fun setEventSink(sink: QueuingEventSink) {
        eventSink = sink
    }

    fun setCustomOrientationUtilsApi(utils: CustomOrientationUtilsApi) {
        orientationUtils = utils
    }

    fun setVideoDisplay(textureEntry: TextureRegistry.SurfaceProducer) {
        this.textureEntry = textureEntry
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
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {

            customGSYMediaPlayerListenerApi.onConfigurationChanged(eventSink!!)
        }
    }

    override fun onPrepared() {
        if (!videoIsInitialized) {
            videoIsInitialized = true
            textureEntry!!.setSize(gsyVideoManager.player.mediaPlayer.videoWidth, gsyVideoManager.player.mediaPlayer.videoHeight)
            surface = textureEntry!!.surface
            gsyVideoManager.player.mediaPlayer.setSurface(surface)
            customGSYMediaPlayerListenerApi.sendVideoPlayerInitialized(eventSink!!)
        }
        super.onPrepared()
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onPrepared(eventSink!!)
        }
    }


    override fun onAutoCompletion() {
        super.onAutoCompletion()
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onAutoCompletion(eventSink!!)
        }
    }

    override fun onCompletion() {
        super.onCompletion()
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onCompletion(eventSink!!)
        }
    }

    override fun onBufferingUpdate(percent: Int) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onBufferingUpdate(eventSink!!, percent)
        }
        super.onBufferingUpdate(percent)
    }

    override fun onSeekComplete() {
        super.onSeekComplete()
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onSeekComplete(eventSink!!)
        }
    }

    override fun onError(what: Int, extra: Int) {
        super.onError(what, extra)
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onError(eventSink!!, what, extra)
        }
    }

    override fun onInfo(what: Int, extra: Int) {
        super.onInfo(what, extra)
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            if (!bufferEnd && what == MediaPlayer.MEDIA_INFO_BUFFERING_END) {
                bufferEnd = true
                customGSYMediaPlayerListenerApi.onBufferingEnd(eventSink!!, what, extra)
            }
            customGSYMediaPlayerListenerApi.onInfo(eventSink!!, what, extra)
        }

    }

    override fun onVideoSizeChanged() {
        super.onVideoSizeChanged()
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onVideoSizeChanged(eventSink!!)
        }
    }

    override fun onBackFullscreen() {
        super.onBackFullscreen()
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onBackFullscreen(eventSink!!)
        }
    }

    override fun onVideoPause() {
        super.onVideoPause()
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onVideoPause(eventSink!!)
        }
    }

    override fun onVideoResume() {
        super.onVideoResume()
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onVideoResume(eventSink!!)
        }
    }

    override fun onVideoResume(seek: Boolean) {
        super.onVideoResume(seek)
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onVideoResume(eventSink!!, seek)
        }
    }

    companion object {
        var autoPlay: Boolean = false
    }

    override fun onStartPrepared(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onStartPrepared(eventSink!!, url, objects)
        }
    }

    //加载成功，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onPrepared(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onPrepared(eventSink!!, url, objects)
        }
    }

    //点击了开始按键播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStartIcon(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickStartIcon(eventSink!!, url, objects)
        }
    }

    //点击了错误状态下的开始按键，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStartError(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickStartError(eventSink!!, url, objects)
        }
    }

    //点击了播放状态下的开始按键--->停止，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStop(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickStop(eventSink!!, url, objects)
        }
    }

    override fun onClickStopFullscreen(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickStopFullscreen(eventSink!!, url, objects)
        }
    }

    //点击了暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickResume(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickResume(eventSink!!, url, objects)
        }
    }

    //点击了全屏暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickResumeFullscreen(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickResumeFullscreen(eventSink!!, url, objects)
        }
    }

    //点击了空白弹出seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickSeekbar(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickSeekbar(eventSink!!, url, objects)
        }
    }

    //点击了全屏的seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickSeekbarFullscreen(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickSeekbarFullscreen(eventSink!!, url, objects)
        }
    }

    //播放完了，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onAutoComplete(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onAutoComplete(eventSink!!, url, objects)
        }
    }

    override fun onEnterFullscreen(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onEnterFullscreen(eventSink!!, url, objects)
        }
    }

    override fun onQuitFullscreen(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onQuitFullscreen(eventSink!!, url, objects)
        }
    }

    override fun onQuitSmallWidget(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onQuitSmallWidget(eventSink!!, url, objects)
        }
    }

    override fun onEnterSmallWidget(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onEnterSmallWidget(eventSink!!, url, objects)
        }
    }

    override fun onTouchScreenSeekVolume(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onTouchScreenSeekVolume(eventSink!!, url, objects)
        }
    }

    override fun onTouchScreenSeekPosition(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onTouchScreenSeekPosition(eventSink!!, url, objects)
        }
    }

    override fun onTouchScreenSeekLight(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onTouchScreenSeekLight(eventSink!!, url, objects)
        }
    }

    override fun onPlayError(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onPlayError(eventSink!!, url, objects)
        }
    }

    override fun onClickStartThumb(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickStartThumb(eventSink!!, url, objects)
        }
    }

    override fun onClickBlank(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickBlank(eventSink!!, url, objects)
        }
    }

    override fun onClickBlankFullscreen(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onClickBlankFullscreen(eventSink!!, url, objects)
        }
    }

    override fun onComplete(url: String, vararg objects: Any) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onComplete(eventSink!!, url, objects)
        }
    }

    override fun onProgress(progress: Long, secProgress: Long, currentPosition: Long, duration: Long) {
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customVideoAllCallBackApi.onProgress(eventSink!!)
        }
    }

}
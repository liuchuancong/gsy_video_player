package com.alizda.gsy_video_player


import android.app.Activity
import android.content.Context
import android.content.res.Configuration
import android.media.MediaPlayer
import android.util.AttributeSet
import android.view.Surface
import com.alizda.gsy_video_player.GsyVideoPlayer.Companion.useDefaultIjkOptions
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer
import com.shuyu.gsyvideoplayer.video.base.GSYBaseVideoPlayer
import io.flutter.view.TextureRegistry
import tv.danmaku.ijk.media.player.IjkMediaPlayer


class CustomVideoPlayer : StandardGSYVideoPlayer {
    private var customGSYMediaPlayerListenerApi: CustomGSYMediaPlayerListenerApi =
        CustomGSYMediaPlayerListenerApi(this)
    private var orientationUtils: CustomOrientationUtilsApi? = null
    var videoIsInitialized: Boolean = false
    private var eventSink: QueuingEventSink? = null
    private var surface: Surface? = null
    private var textureEntry: TextureRegistry.SurfaceProducer? = null
    private var bufferEnd = false

    constructor(context: Context?) : super(context)
    constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs)

    override fun init(context: Context) {
        super.init(context)
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

    override fun onConfigurationChanged(
        activity: Activity?,
        newConfig: Configuration?,
        orientationUtils: OrientationUtils?
    ) {
        super.onConfigurationChanged(activity, newConfig, orientationUtils!!)
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            customGSYMediaPlayerListenerApi.onConfigurationChanged(eventSink!!)
        }
    }

    override fun onPrepared() {
        super.onPrepared()
        if (!videoIsInitialized) {
            videoIsInitialized = true
            textureEntry!!.setSize(
                gsyVideoManager.player.mediaPlayer.videoWidth,
                gsyVideoManager.player.mediaPlayer.videoHeight
            )
            surface = textureEntry!!.surface
            gsyVideoManager.player.mediaPlayer.setSurface(surface)
            customGSYMediaPlayerListenerApi.sendVideoPlayerInitialized(eventSink!!)
        }
        if (videoIsInitialized && GSYVideoManager.instance().player != null && GSYVideoManager.instance().player.mediaPlayer != null) {
            if (GSYVideoManager.instance().player.mediaPlayer is IjkMediaPlayer) {
                if (useDefaultIjkOptions) {
                    GsyVideoPlayer.customGSYVideoManagerApi!!.setDefaultOptions()
                }
            }
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
}
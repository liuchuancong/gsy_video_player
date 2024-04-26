package com.alizda.gsy_video_player

import android.content.Context
import android.util.Log
import android.view.View
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import com.shuyu.gsyvideoplayer.listener.VideoAllCallBack
import com.shuyu.gsyvideoplayer.player.IjkPlayerManager
import com.shuyu.gsyvideoplayer.player.PlayerFactory
import com.shuyu.gsyvideoplayer.utils.GSYVideoType
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView
import tv.danmaku.ijk.media.exo2.Exo2PlayerManager
import tv.danmaku.ijk.media.player.IjkMediaPlayer


class GsyVideoPlayerView(private val context: Context, messenger: BinaryMessenger, private val id: Int, private val params: Map<String?, Any?>?) : PlatformView, MethodChannel.MethodCallHandler,EventChannel.StreamHandler, PluginRegistry.RequestPermissionsResultListener, VideoAllCallBack {

    private val channel: MethodChannel = MethodChannel(messenger, METHODS_CHANNEL)
    private var sink: EventChannel.EventSink? = null
    private var event: EventChannel = EventChannel(messenger, EVENTS_CHANNEL + id)
    private var videoPlayer: CustomVideoPlayer = CustomVideoPlayer(context)
    private var binaryMessenger: BinaryMessenger = messenger
    private var orientationUtils: OrientationUtils? = null
    private var gsyVideoOptionBuilder: GSYVideoOptionBuilder? = null
    private var rotateEnable: Boolean = false
    private var isPlay: Boolean = false
    private var gsyVideoType: Int = GSYVideoType.SCREEN_TYPE_16_9
    private var playerType: Int = 0;

    init {
        channel.setMethodCallHandler(this)
        event.setStreamHandler(this)
        gsyVideoOptionBuilder = GSYVideoOptionBuilder()
        setGlobalConfig()
    }

    override fun getView(): View = initGSYVideoPlayerView()

    private fun initGSYVideoPlayerView(): View {
        return videoPlayer
    }

    private fun setVideoConfig(call: MethodCall, result: MethodChannel.Result) {
        initVideoPlayer()
        val videoOptions = call.argument<Map<String, Any?>>(BUILDER_PARAMS)!!
        var url = getParameter(videoOptions,"url","");
        var autoPlay = getParameter(videoOptions,"autoPlay",true);
        gsyVideoOptionBuilder!!.setUrl(url).setCacheWithPlay(true)
            .setVideoTitle("1")
            .setIsTouchWiget(true)
            .setRotateViewAuto(false)
        gsyVideoOptionBuilder!!.build(videoPlayer);
        if (autoPlay){
            videoPlayer.startPlayLogic()
        }
        Log.d(TAG, "setVideoConfig: $videoOptions")
    }

    private fun setGlobalConfig() {
        //EXOPlayer内核，支持格式更多
        PlayerFactory.setPlayManager(Exo2PlayerManager::class.java)
        GSYVideoType.setRenderType(GSYVideoType.TEXTURE)
    }

    private fun initVideoPlayer() {
        IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_SILENT);
        //设置旋转
        orientationUtils = OrientationUtils(GsyVideoShared.activity, videoPlayer)
    }

    //    暂停
    private fun onPause() {
        videoPlayer.onVideoPause();
    }

    //    恢复
    private fun onResume() {
        videoPlayer.onVideoResume();
    }

    //    播放
    private fun onStart() {
        videoPlayer.startPlayLogic()
    }

    //快进
    private fun onSeekTo(location: Int) {
        videoPlayer.seekTo(location.toLong())
    }

    private fun onDestroy() {
        GSYVideoManager.releaseAllVideos()
        orientationUtils?.releaseListener();
        videoPlayer.setVideoAllCallBack(null);
    }

    override fun dispose() {
        onDestroy()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            CREATE_METHOD -> {
                val reply: MutableMap<String, Any> = HashMap()
                reply["textureId"] = id
                result.success(reply)
            }
            SET_VIDEO_OPTION_BUILDER -> {
                Log.d(TAG, "onMethodCall: 方法被调用")
                setVideoConfig(call, result)
            }
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

    @Suppress("UNCHECKED_CAST")
    private fun <T> getParameter(parameters: Map<String, Any?>?, key: String, defaultValue: T): T {
        if (parameters?.containsKey(key) == true) {
            val value = parameters[key]
            if (value != null) {
                return value as T
            }
        }
        return defaultValue
    }

    companion object {
        private const val TAG = "GSY_VIDEO_PLAYER"
        private const val SET_VIDEO_OPTION_BUILDER = "setVideoOptionBuilder"
        private const val METHODS_CHANNEL = "gsy_video_player_channel/platform_view_methods"
        private const val EVENTS_CHANNEL = "gsy_video_player_channel/platform_view_events"
        private const val BUILDER_PARAMS = "builderParams"
        private const val HEADERS_PARAMETER = "headers"
        private const val USE_CACHE_PARAMETER = "useCache"
        private const val ASSET_PARAMETER = "asset"
        private const val PACKAGE_PARAMETER = "package"
        private const val URI_PARAMETER = "uri"
        private const val FORMAT_HINT_PARAMETER = "formatHint"
        private const val TEXTURE_ID_PARAMETER = "textureId"
        private const val LOOPING_PARAMETER = "looping"
        private const val VOLUME_PARAMETER = "volume"
        private const val LOCATION_PARAMETER = "location"
        private const val SPEED_PARAMETER = "speed"
        private const val WIDTH_PARAMETER = "width"
        private const val HEIGHT_PARAMETER = "height"
        private const val BITRATE_PARAMETER = "bitrate"
        private const val SHOW_NOTIFICATION_PARAMETER = "showNotification"
        private const val TITLE_PARAMETER = "title"
        private const val AUTHOR_PARAMETER = "author"
        private const val IMAGE_URL_PARAMETER = "imageUrl"
        private const val NOTIFICATION_CHANNEL_NAME_PARAMETER = "notificationChannelName"
        private const val OVERRIDDEN_DURATION_PARAMETER = "overriddenDuration"
        private const val NAME_PARAMETER = "name"
        private const val INDEX_PARAMETER = "index"
        private const val LICENSE_URL_PARAMETER = "licenseUrl"
        private const val DRM_HEADERS_PARAMETER = "drmHeaders"
        private const val DRM_CLEARKEY_PARAMETER = "clearKey"
        private const val MIX_WITH_OTHERS_PARAMETER = "mixWithOthers"
        const val URL_PARAMETER = "url"
        const val PRE_CACHE_SIZE_PARAMETER = "preCacheSize"
        const val MAX_CACHE_SIZE_PARAMETER = "maxCacheSize"
        const val MAX_CACHE_FILE_SIZE_PARAMETER = "maxCacheFileSize"
        const val HEADER_PARAMETER = "header_"
        const val ACTIVITY_NAME_PARAMETER = "activityName"
        const val PACKAGE_NAME_PARAMETER = "packageName"
        const val MIN_BUFFER_MS = "minBufferMs"
        const val MAX_BUFFER_MS = "maxBufferMs"
        const val BUFFER_FOR_PLAYBACK_MS = "bufferForPlaybackMs"
        const val BUFFER_FOR_PLAYBACK_AFTER_REBUFFER_MS = "bufferForPlaybackAfterRebufferMs"
        const val CACHE_KEY_PARAMETER = "cacheKey"
        private const val INIT_METHOD = "init"
        private const val CREATE_METHOD = "create"
        private const val SET_DATA_SOURCE_METHOD = "setDataSource"
        private const val SET_LOOPING_METHOD = "setLooping"
        private const val SET_VOLUME_METHOD = "setVolume"
        private const val PLAY_METHOD = "play"
        private const val PAUSE_METHOD = "pause"
        private const val SEEK_TO_METHOD = "seekTo"
        private const val POSITION_METHOD = "position"
        private const val ABSOLUTE_POSITION_METHOD = "absolutePosition"
        private const val SET_SPEED_METHOD = "setSpeed"
        private const val SET_TRACK_PARAMETERS_METHOD = "setTrackParameters"
        private const val SET_AUDIO_TRACK_METHOD = "setAudioTrack"
        private const val ENABLE_PICTURE_IN_PICTURE_METHOD = "enablePictureInPicture"
        private const val DISABLE_PICTURE_IN_PICTURE_METHOD = "disablePictureInPicture"
        private const val IS_PICTURE_IN_PICTURE_SUPPORTED_METHOD = "isPictureInPictureSupported"
        private const val SET_MIX_WITH_OTHERS_METHOD = "setMixWithOthers"
        private const val CLEAR_CACHE_METHOD = "clearCache"
        private const val DISPOSE_METHOD = "dispose"
        private const val PRE_CACHE_METHOD = "preCache"
        private const val STOP_PRE_CACHE_METHOD = "stopPreCache"
    }

    override fun onStartPrepared(url: String?, vararg objects: Any?) {}

    override fun onPrepared(url: String?, vararg objects: Any?) {
        if (orientationUtils == null) {
            throw NullPointerException("initVideo() or initVideoBuilderMode() first")
        }
        //开始播放了才能旋转和全屏
        orientationUtils!!.isEnable = rotateEnable && !videoPlayer.isAutoFullWithSize
        isPlay = true
    }

    override fun onClickStartIcon(url: String?, vararg objects: Any?) {}

    override fun onClickStartError(url: String?, vararg objects: Any?) {}

    override fun onClickStop(url: String?, vararg objects: Any?) {}

    override fun onClickStopFullscreen(url: String?, vararg objects: Any?) {}

    override fun onClickResume(url: String?, vararg objects: Any?) {}

    override fun onClickResumeFullscreen(url: String?, vararg objects: Any?) {}

    override fun onClickSeekbar(url: String?, vararg objects: Any?) {}

    override fun onClickSeekbarFullscreen(url: String?, vararg objects: Any?) {}

    override fun onAutoComplete(url: String?, vararg objects: Any?) {}

    override fun onEnterFullscreen(url: String?, vararg objects: Any?) {}

    override fun onQuitFullscreen(url: String?, vararg objects: Any?) {

        // ------- ！！！如果不需要旋转屏幕，可以不调用！！！-------
        // 不需要屏幕旋转，还需要设置 setNeedOrientationUtils(false)
        if (orientationUtils != null) {
            orientationUtils!!.backToProtVideo()
        }
    }

    override fun onQuitSmallWidget(url: String?, vararg objects: Any?) {}

    override fun onEnterSmallWidget(url: String?, vararg objects: Any?) {}

    override fun onTouchScreenSeekVolume(url: String?, vararg objects: Any?) {}

    override fun onTouchScreenSeekPosition(url: String?, vararg objects: Any?) {}

    override fun onTouchScreenSeekLight(url: String?, vararg objects: Any?) {}

    override fun onPlayError(url: String?, vararg objects: Any?) {}

    override fun onClickStartThumb(url: String?, vararg objects: Any?) {}

    override fun onClickBlank(url: String?, vararg objects: Any?) {}

    override fun onClickBlankFullscreen(url: String?, vararg objects: Any?) {}

    override fun onComplete(url: String?, vararg objects: Any?) {}

}
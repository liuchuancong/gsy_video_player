package com.alizda.gsy_video_player

import android.content.Context
import android.content.res.AssetManager
import android.view.View
import com.shuyu.aliplay.AliPlayerManager
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import com.shuyu.gsyvideoplayer.listener.GSYVideoProgressListener
import com.shuyu.gsyvideoplayer.listener.VideoAllCallBack
import com.shuyu.gsyvideoplayer.player.IjkPlayerManager
import com.shuyu.gsyvideoplayer.player.PlayerFactory
import com.shuyu.gsyvideoplayer.player.SystemPlayerManager
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
import java.io.File


class GsyVideoPlayerView(private val context: Context, messenger: BinaryMessenger, private val id: Int, private val params: Map<String?, Any?>?) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler, PluginRegistry.RequestPermissionsResultListener, VideoAllCallBack, GSYVideoProgressListener {

    private val channel: MethodChannel = MethodChannel(messenger, METHODS_CHANNEL)
    private var sink: EventChannel.EventSink? = null
    private var event: EventChannel = EventChannel(messenger, EVENTS_CHANNEL + id)
    private var videoPlayer: CustomVideoPlayer = CustomVideoPlayer(context)
    private var orientationUtils: OrientationUtils? = null
    private var gsyVideoOptionBuilder: GSYVideoOptionBuilder = GSYVideoOptionBuilder()
    private var playerType: Int = 0;
    private var renderType: Int = 0;


    init {
        channel.setMethodCallHandler(this)
        event.setStreamHandler(this)
    }

    override fun getView(): View = initGSYVideoPlayerView()

    private fun initGSYVideoPlayerView(): View {
        return videoPlayer
    }

    private fun setVideoConfig(call: MethodCall, result: MethodChannel.Result) {

        initVideoPlayer()

        val videoOptions = call.argument<Map<String, Any?>>(BUILDER_PARAMS)!!
        val url = getParameter(videoOptions, "url", "");
        val playVideoDataSourceType = getParameter(videoOptions, "playVideoDataSourceType", 0);
        if (playVideoDataSourceType == 0) {
            val context = GsyVideoShared.activity?.applicationContext
            // 现在你可以使用 context 来获取 AssetManager
            val assetManager: AssetManager? = context?.assets
            val fd = assetManager!!.openFd(url)
            gsyVideoOptionBuilder.setUrl("asset:///$fd")
        } else {
            gsyVideoOptionBuilder.setUrl(url)
        }
        val releaseWhenLossAudio = getParameter(videoOptions, "releaseWhenLossAudio", true);
        gsyVideoOptionBuilder.setReleaseWhenLossAudio(releaseWhenLossAudio)
        val seekRatio = getParameter(videoOptions, "seekRatio", 1.0);
        gsyVideoOptionBuilder.setSeekRatio(seekRatio.toFloat())
        val startAfterPrepared = getParameter(videoOptions, "startAfterPrepared", true);
        gsyVideoOptionBuilder.setStartAfterPrepared(startAfterPrepared)
        val dismissControlTime = getParameter(videoOptions, "dismissControlTime", 2500);
        gsyVideoOptionBuilder.setDismissControlTime(dismissControlTime)
        val isTouchWiget = getParameter(videoOptions, "isTouchWiget", true);
        gsyVideoOptionBuilder.setIsTouchWiget(isTouchWiget)
        val isShowDragProgressTextOnSeekBar = getParameter(videoOptions, "isShowDragProgressTextOnSeekBar", false);
        gsyVideoOptionBuilder.setShowDragProgressTextOnSeekBar(isShowDragProgressTextOnSeekBar)
        val speed = getParameter(videoOptions, "speed", 1.0);
        gsyVideoOptionBuilder.setSpeed(speed.toFloat())
        val header: MutableMap<String, String> = HashMap()
        val mapHeadData = getParameter(videoOptions, "mapHeadData", header);
        gsyVideoOptionBuilder.setMapHeadData(mapHeadData)
        val playTag = getParameter(videoOptions, "playTag", "");
        if (playTag.isNotEmpty()) {
            gsyVideoOptionBuilder.setPlayTag(playTag)
        }
        val needOrientationUtils = getParameter(videoOptions, "needOrientationUtils", true);
        gsyVideoOptionBuilder.setNeedOrientationUtils(needOrientationUtils)
        val hideKey = getParameter(videoOptions, "hideKey", true);
        gsyVideoOptionBuilder.setHideKey(hideKey)
        val showPauseCover = getParameter(videoOptions, "showPauseCover", true);
        gsyVideoOptionBuilder.setShowPauseCover(showPauseCover)
        val statusBar = getParameter(videoOptions, "statusBar", false);
        gsyVideoOptionBuilder.setFullHideStatusBar(statusBar)
        val showFullAnimation = getParameter(videoOptions, "showFullAnimation", true);
        gsyVideoOptionBuilder.setShowFullAnimation(showFullAnimation)
        val rotateWithSystem = getParameter(videoOptions, "rotateWithSystem", true);
        gsyVideoOptionBuilder.setRotateWithSystem(rotateWithSystem)
        val enlargeImageRes = getParameter(videoOptions, "enlargeImageRes", -1);
        gsyVideoOptionBuilder.setEnlargeImageRes(enlargeImageRes)
        val shrinkImageRes = getParameter(videoOptions, "shrinkImageRes", -1);
        gsyVideoOptionBuilder.setShrinkImageRes(shrinkImageRes)
        val isUseCustomCachePath = getParameter(videoOptions, "isUseCustomCachePath", false)
        val cachePath = getParameter(videoOptions, "cachePath", "");
        if (isUseCustomCachePath && cachePath.isNotEmpty()) {
            gsyVideoOptionBuilder.setCachePath(File(cachePath))
        }
        val looping = getParameter(videoOptions, "looping", false);
        gsyVideoOptionBuilder.setLooping(looping)
        val dialogProgressHighLightColor = getParameter(videoOptions, "dialogProgressHighLightColor", -11)
        val dialogProgressNormalColor = getParameter(videoOptions, "dialogProgressNormalColor", -11);
        gsyVideoOptionBuilder.setDialogProgressColor(dialogProgressHighLightColor, dialogProgressNormalColor)
        val thumbPlay = getParameter(videoOptions, "thumbPlay", true);
        gsyVideoOptionBuilder.setThumbPlay(thumbPlay)
        val actionBar = getParameter(videoOptions, "actionBar", false);
        gsyVideoOptionBuilder.setFullHideActionBar(actionBar)
        val videoTitle = getParameter(videoOptions, "videoTitle", "");
        if (videoTitle.isNotEmpty()) {
            videoPlayer.titleTextView.visibility = View.VISIBLE;
            gsyVideoOptionBuilder.setVideoTitle(videoTitle)
        } else {
            videoPlayer.titleTextView.visibility = View.GONE;
        }
        val playPosition = getParameter(videoOptions, "playPosition", -22);
        gsyVideoOptionBuilder.setPlayPosition(playPosition)
        val isTouchWigetFull = getParameter(videoOptions, "isTouchWigetFull", true);
        gsyVideoOptionBuilder.setIsTouchWigetFull(isTouchWigetFull)
        val autoFullWithSize = getParameter(videoOptions, "autoFullWithSize", false);
        gsyVideoOptionBuilder.setAutoFullWithSize(autoFullWithSize)
        val cacheWithPlay = getParameter(videoOptions, "cacheWithPlay", true);
        gsyVideoOptionBuilder.setCacheWithPlay(cacheWithPlay)
        val sounchTouch = getParameter(videoOptions, "sounchTouch", true);
        gsyVideoOptionBuilder.setSoundTouch(sounchTouch)
        val rotateViewAuto = getParameter(videoOptions, "rotateViewAuto", true);
        gsyVideoOptionBuilder.setRotateViewAuto(rotateViewAuto)
        val isOnlyRotateLand = getParameter(videoOptions, "isOnlyRotateLand", false);
        gsyVideoOptionBuilder.setOnlyRotateLand(isOnlyRotateLand)
        val needLockFull = getParameter(videoOptions, "needLockFull", true);
        gsyVideoOptionBuilder.setNeedLockFull(needLockFull)
        val seekOnStart = getParameter(videoOptions, "seekOnStart", -1);
        gsyVideoOptionBuilder.setSeekOnStart(seekOnStart.toLong())
        val needShowWifiTip = getParameter(videoOptions, "needShowWifiTip", true);
        gsyVideoOptionBuilder.setNeedShowWifiTip(needShowWifiTip)
        val surfaceErrorPlay = getParameter(videoOptions, "surfaceErrorPlay", true);
        gsyVideoOptionBuilder.setSurfaceErrorPlay(surfaceErrorPlay)
        val lockLand = getParameter(videoOptions, "lockLand", false);
        gsyVideoOptionBuilder.setLockLand(lockLand)
        val overrideExtension = getParameter(videoOptions, "overrideExtension", "");
        if (overrideExtension.isNotEmpty()) {
            gsyVideoOptionBuilder.setOverrideExtension(overrideExtension)
        }
        videoPlayer.backButton.visibility = View.GONE
        gsyVideoOptionBuilder.build(videoPlayer);
        gsyVideoOptionBuilder.setGSYVideoProgressListener(this)
        val autoPlay = getParameter(videoOptions, "autoPlay", true);
        if (autoPlay) {
            videoPlayer.startPlayLogic()
        }
        val reply: MutableMap<String, Any> = HashMap()
        reply["setVideoConfig"] = true
        result.success(reply)
    }

    private fun setGlobalConfig(call: MethodCall, result: MethodChannel.Result) {
        val playerOptions = call.argument<Map<String, Any?>>(PLAYER_OPTIONS)!!
        playerType = getParameter(playerOptions, "playerType", 0);
        renderType = getParameter(playerOptions, "renderType", 0);
        when (playerType) {
            0 -> PlayerFactory.setPlayManager(Exo2PlayerManager::class.java)
            1 -> PlayerFactory.setPlayManager(SystemPlayerManager::class.java)
            2 -> PlayerFactory.setPlayManager(IjkPlayerManager::class.java)
            3 -> PlayerFactory.setPlayManager(AliPlayerManager::class.java)
        }
        when (renderType) {
            0 -> GSYVideoType.setRenderType(GSYVideoType.TEXTURE)
            1 -> GSYVideoType.setRenderType(GSYVideoType.SUFRACE)
            2 -> GSYVideoType.setRenderType(GSYVideoType.GLSURFACE)
        }
        val reply: MutableMap<String, Any> = HashMap()
        reply["initPlayerConfig"] = true
        result.success(reply)
    }

    private fun initVideoPlayer() {
//        关闭ijk 日志
        IjkPlayerManager.setLogLevel(IjkMediaPlayer.IJK_LOG_SILENT);
        //设置旋转
        orientationUtils = OrientationUtils(GsyVideoShared.activity, videoPlayer)
    }


    private fun setShowType(call: MethodCall, result: MethodChannel.Result) {
        val showTypeOptions = call.argument<Map<String, Any?>>(SHOW_TYPE_OPTIONS)!!
        val showType = getParameter(showTypeOptions, SHOW_TYPE, 0);
        val screenScaleRatio = getParameter(showTypeOptions, SCREEN_SCALE_RATIO, 0.0F);
        when (showType) {
            0 -> GSYVideoType.setShowType(GSYVideoType.SCREEN_MATCH_FULL);
            1 -> GSYVideoType.setShowType(GSYVideoType.SCREEN_TYPE_16_9);
            2 -> GSYVideoType.setShowType(GSYVideoType.SCREEN_TYPE_4_3);
            3 -> GSYVideoType.setShowType(GSYVideoType.SCREEN_TYPE_FULL);
            4 -> GSYVideoType.setShowType(GSYVideoType.SCREEN_MATCH_FULL);
            5 -> GSYVideoType.setShowType(GSYVideoType.SCREEN_TYPE_18_9);
            6 -> {
                GSYVideoType.setShowType(GSYVideoType.SCREEN_TYPE_CUSTOM);
                GSYVideoType.setScreenScaleRatio(screenScaleRatio)
            }
        }
        val reply: MutableMap<String, Any> = HashMap()
        reply["setShowType"] = true
        result.success(reply)
    }

    private fun setMediaCodec(call: MethodCall, result: MethodChannel.Result) {
        val enableCodec: Boolean = call.argument(ENABLE_CODEC)!!
        if (enableCodec) {
            GSYVideoType.enableMediaCodec()
        } else {
            GSYVideoType.disableMediaCodec()
        }
    }

    private fun setMediaCodecTexture(call: MethodCall, result: MethodChannel.Result) {
        val enableCodecTexture: Boolean = call.argument(ENABLE_CODEC_TEXTURE)!!
        if (enableCodecTexture) {
            GSYVideoType.enableMediaCodecTexture()
        } else {
            GSYVideoType.disableMediaCodecTexture()
        }
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
            INIT_PLAYER_CONFIG -> {
                setGlobalConfig(call, result)
            }

            CREATE_METHOD -> {
                val reply: MutableMap<String, Any> = HashMap()
                reply["textureId"] = id
                result.success(reply)
            }

            SET_VIDEO_OPTION_BUILDER -> {
                setVideoConfig(call, result)
            }

            SET_SHOW_TYPE -> {
                setShowType(call, result)
            }

            ENABLE_CODEC -> {
                setMediaCodec(call, result)
            }

            ENABLE_CODEC_TEXTURE -> {
                setMediaCodecTexture(call, result)
            }

            PLAY_METHOD -> {
                onStart()
            }

            PAUSE_METHOD -> {
                onPause()
            }

            RESUME_METHOD -> {
                onResume()
            }

            SET_VOLUME_METHOD -> {

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
        private const val METHODS_CHANNEL = "gsy_video_player_channel/platform_view_methods"
        private const val EVENTS_CHANNEL = "gsy_video_player_channel/platform_view_events"

        //设置GSYVideoOptionBuilder
        private const val BUILDER_PARAMS = "builderParams"
        private const val SET_VIDEO_OPTION_BUILDER = "setVideoOptionBuilder"

        //设置播放器以及渲染方式
        private const val INIT_PLAYER_CONFIG = "init"
        private const val PLAYER_OPTIONS = "playerOptions"

        //创建应答检测
        private const val CREATE_METHOD = "create"

        //切换渲染模式
        private const val SET_SHOW_TYPE = "setShowType"
        private const val SHOW_TYPE_OPTIONS = "showTypeOptions"
        private const val SHOW_TYPE = "showType"
        private const val SCREEN_SCALE_RATIO = "screenScaleRatio"

        //是否开启硬解码

        private const val ENABLE_CODEC = "enableCodec"
        private const val ENABLE_CODEC_TEXTURE = "enableCodecTexture"


        private const val LOOPING_PARAMETER = "looping"
        private const val VOLUME_PARAMETER = "volume"
        private const val LOCATION_PARAMETER = "location"
        private const val SPEED_PARAMETER = "speed"
        private const val SET_LOOPING_METHOD = "setLooping"
        private const val SET_VOLUME_METHOD = "setVolume"
        //设置播放器方法

        private const val GET_PAYOUT_ID = "getLayoutId"
        private const val PLAY_METHOD = "play"
        private const val SET_UP = "setUp"
        private const val PAUSE_METHOD = "pause"
        private const val RESUME_METHOD = "resume"
        private const val CLEAR_CURRENT_CACHE = "clearCurrentCache"
        private const val GET_CURRENT_POSITION_WHEN_PLAYING = "getCurrentPositionWhenPlaying"
        private const val GET_DURATION = "getDuration"
        private const val GET_CURRENT_STATE = "getCurrentState"
        private const val SET_PLAYING_TAG = "setPlayTag"
        private const val SET_PLAYING_POSITION = "setPlayPosition"
        private const val GET_NET_SPEED = "getNetSpeed"
        private const val GET_NET_SPEED_TEXT = "getNetSpeedText"
        private const val SET_SEEK_ON_START = "setSeekOnStart"
        private const val GET_BUFFER_POINT = "getBufferPoint"

        //OrientationUtils

        private const val RESOLVE_BY_CLICK = "resolveByClick"
        private const val BACK_BY_PROT_VIDEO = "backToProtVideo"
        private const val ORIENTATION_IS_ENABLE = "orientationutilsIsEnable"
        private const val ORIENTATION_SET_ENABLE = "orientationutilsSetEnable"
        private const val ORIENTATION_RELEASE = "orientationutilsRelease"
        private const val ORIENTATION_IS_LAND = "orientationutilsGetIsLand"
        private const val ORIENTATION_GET_SCREEN_TYPE = "orientationutilsGetScreenType"
        private const val ORIENTATION_SET_ROTATE_WITH_SYSTEM = "orientationutilsSetRotateWithSystem"

        // 销毁
        private const val DISPOSE_METHOD = "dispose"
    }

    override fun onStartPrepared(url: String, vararg objects: Any) {}

    //加载成功，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onPrepared(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onPrepared"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    //点击了开始按键播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStartIcon(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickStartIcon"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    //点击了错误状态下的开始按键，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStartError(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickStartIcon"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    //点击了播放状态下的开始按键--->停止，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickStop(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickStop"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onClickStopFullscreen(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickStopFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    //点击了暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickResume(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickResume"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    //点击了全屏暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickResumeFullscreen(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickResumeFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    //点击了空白弹出seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickSeekbar(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickSeekbar"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    //点击了全屏的seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onClickSeekbarFullscreen(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickSeekbarFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    //播放完了，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    override fun onAutoComplete(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onAutoComplete"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onEnterFullscreen(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEnterFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onQuitFullscreen(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onQuitFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onQuitSmallWidget(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onQuitSmallWidget"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onEnterSmallWidget(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEnterSmallWidget"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onTouchScreenSeekVolume(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onTouchScreenSeekVolume"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onTouchScreenSeekPosition(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onTouchScreenSeekPosition"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onTouchScreenSeekLight(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onTouchScreenSeekLight"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onPlayError(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onPlayError"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onClickStartThumb(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickStartThumb"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onClickBlank(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickBlank"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onClickBlankFullscreen(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickBlankFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    override fun onComplete(url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onComplete"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink?.success(event)
    }

    /**
     * 进度回调
     */
    override fun onProgress(progress: Long, secProgress: Long, currentPosition: Long, duration: Long) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onProgress"
        event["reply"] = reply
        reply["duration"] = duration
        reply["currentPosition"] = currentPosition
        sink?.success(event)
    }
}
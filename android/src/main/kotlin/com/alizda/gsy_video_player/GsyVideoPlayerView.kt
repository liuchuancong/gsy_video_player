package com.alizda.gsy_video_player

import android.R.attr.key
import android.content.Context
import android.content.res.AssetManager
import android.util.Log
import android.view.View
import com.shuyu.aliplay.AliPlayerManager
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
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


class GsyVideoPlayerView(private val context: Context, messenger: BinaryMessenger, private val id: Int, private val params: Map<String?, Any?>?) : PlatformView, MethodChannel.MethodCallHandler,EventChannel.StreamHandler, PluginRegistry.RequestPermissionsResultListener, VideoAllCallBack {

    private val channel: MethodChannel = MethodChannel(messenger, METHODS_CHANNEL)
    private var sink: EventChannel.EventSink? = null
    private var event: EventChannel = EventChannel(messenger, EVENTS_CHANNEL + id)
    private var videoPlayer: CustomVideoPlayer = CustomVideoPlayer(context)
    private var binaryMessenger: BinaryMessenger = messenger
    private var orientationUtils: OrientationUtils? = null
    private var gsyVideoOptionBuilder: GSYVideoOptionBuilder = GSYVideoOptionBuilder()
    private var rotateEnable: Boolean = false
    private var isPlay: Boolean = false
    private var gsyVideoType: Int = GSYVideoType.SCREEN_TYPE_DEFAULT
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
        val url = getParameter(videoOptions,"url","");
        val playVideoDataSourceType = getParameter(videoOptions,"playVideoDataSourceType",0);
        if(playVideoDataSourceType == 0){
            val context = GsyVideoShared.activity?.applicationContext
            // 现在你可以使用 context 来获取 AssetManager
            val assetManager: AssetManager? = context?.assets
            val fd = assetManager!!.openFd(url)
            gsyVideoOptionBuilder.setUrl("asset:///$fd")
        }else{
            gsyVideoOptionBuilder.setUrl(url)
        }
        val releaseWhenLossAudio =  getParameter(videoOptions,"releaseWhenLossAudio",true);
        gsyVideoOptionBuilder.setReleaseWhenLossAudio(releaseWhenLossAudio)
        val seekRatio = getParameter(videoOptions,"seekRatio",1.0);
        gsyVideoOptionBuilder.setSeekRatio(seekRatio.toFloat())
        val startAfterPrepared = getParameter(videoOptions,"startAfterPrepared",true);
        gsyVideoOptionBuilder.setStartAfterPrepared(startAfterPrepared)
        val dismissControlTime = getParameter(videoOptions,"dismissControlTime",2500);
        gsyVideoOptionBuilder.setDismissControlTime(dismissControlTime)
        val isTouchWiget = getParameter(videoOptions,"isTouchWiget",true);
        gsyVideoOptionBuilder.setIsTouchWiget(isTouchWiget)
        val isShowDragProgressTextOnSeekBar = getParameter(videoOptions,"isShowDragProgressTextOnSeekBar",false);
        gsyVideoOptionBuilder.setShowDragProgressTextOnSeekBar(isShowDragProgressTextOnSeekBar)
        val speed = getParameter(videoOptions,"speed",1.0);
        gsyVideoOptionBuilder.setSpeed(speed.toFloat())
        val header : MutableMap<String, String> = HashMap()
        val mapHeadData = getParameter(videoOptions,"mapHeadData", header);
        gsyVideoOptionBuilder.setMapHeadData(mapHeadData)
        val playTag = getParameter(videoOptions,"playTag","");
        if(playTag.isNotEmpty()){
            gsyVideoOptionBuilder.setPlayTag(playTag)
        }
        val needOrientationUtils = getParameter(videoOptions,"needOrientationUtils",true);
        gsyVideoOptionBuilder.setNeedOrientationUtils(needOrientationUtils)
        val hideKey = getParameter(videoOptions,"hideKey",true);
        gsyVideoOptionBuilder.setHideKey(hideKey)
        val showPauseCover = getParameter(videoOptions,"showPauseCover",true);
        gsyVideoOptionBuilder.setShowPauseCover(showPauseCover)
        val statusBar = getParameter(videoOptions,"statusBar",false);
        gsyVideoOptionBuilder.setFullHideStatusBar(statusBar)
        val showFullAnimation = getParameter(videoOptions,"showFullAnimation",true);
        gsyVideoOptionBuilder.setShowFullAnimation(showFullAnimation)
        val rotateWithSystem = getParameter(videoOptions,"rotateWithSystem",true);
        gsyVideoOptionBuilder.setRotateWithSystem(rotateWithSystem)
        val enlargeImageRes = getParameter(videoOptions,"enlargeImageRes",-1);
        gsyVideoOptionBuilder.setEnlargeImageRes(enlargeImageRes)
        val shrinkImageRes = getParameter(videoOptions,"shrinkImageRes",-1);
        gsyVideoOptionBuilder.setShrinkImageRes(shrinkImageRes)
        val isUseCustomCachePath = getParameter(videoOptions,"isUseCustomCachePath",false);
        val cachePath = getParameter(videoOptions,"cachePath","");
        if(isUseCustomCachePath && cachePath.isNotEmpty()){
            gsyVideoOptionBuilder.setCachePath(File(cachePath))
        }
        val looping = getParameter(videoOptions,"looping",false);
        gsyVideoOptionBuilder.setLooping(looping)
        val dialogProgressHighLightColor = getParameter(videoOptions,"dialogProgressHighLightColor",-11);
        val dialogProgressNormalColor = getParameter(videoOptions,"dialogProgressNormalColor",-11);
        gsyVideoOptionBuilder.setDialogProgressColor(dialogProgressHighLightColor,dialogProgressNormalColor)
        val thumbPlay = getParameter(videoOptions,"thumbPlay",true);
        gsyVideoOptionBuilder.setThumbPlay(thumbPlay)
        val actionBar = getParameter(videoOptions,"actionBar",false);
       gsyVideoOptionBuilder.setFullHideActionBar(actionBar)
        val videoTitle = getParameter(videoOptions,"videoTitle","");
        if(videoTitle.isNotEmpty()){
            videoPlayer.titleTextView.visibility = View.VISIBLE;
            gsyVideoOptionBuilder.setVideoTitle(videoTitle)
        }else{
            videoPlayer.titleTextView.visibility = View.GONE;
        }
        val playPosition = getParameter(videoOptions,"playPosition",-22);
        gsyVideoOptionBuilder.setPlayPosition(playPosition)
        val isTouchWigetFull = getParameter(videoOptions,"isTouchWigetFull",true);
        gsyVideoOptionBuilder.setIsTouchWigetFull(isTouchWigetFull)
        val autoFullWithSize = getParameter(videoOptions,"autoFullWithSize",false);
        gsyVideoOptionBuilder.setAutoFullWithSize(autoFullWithSize)
        val cacheWithPlay = getParameter(videoOptions,"cacheWithPlay",true);
        gsyVideoOptionBuilder.setCacheWithPlay(cacheWithPlay)
        val sounchTouch = getParameter(videoOptions,"sounchTouch",true);
        gsyVideoOptionBuilder.setSoundTouch(sounchTouch)
        val rotateViewAuto = getParameter(videoOptions,"rotateViewAuto",true);
        gsyVideoOptionBuilder.setRotateViewAuto(rotateViewAuto)
        val isOnlyRotateLand = getParameter(videoOptions,"isOnlyRotateLand",false);
        gsyVideoOptionBuilder.setOnlyRotateLand(isOnlyRotateLand)
        val needLockFull = getParameter(videoOptions,"needLockFull",true);
        gsyVideoOptionBuilder.setNeedLockFull(needLockFull)
        val seekOnStart = getParameter(videoOptions,"seekOnStart",-1);
        gsyVideoOptionBuilder.setSeekOnStart(seekOnStart.toLong())
        val needShowWifiTip = getParameter(videoOptions,"needShowWifiTip",true);
        gsyVideoOptionBuilder.setNeedShowWifiTip(needShowWifiTip)
        val surfaceErrorPlay = getParameter(videoOptions,"surfaceErrorPlay",true);
        gsyVideoOptionBuilder.setSurfaceErrorPlay(surfaceErrorPlay)
        val lockLand = getParameter(videoOptions,"lockLand",false);
        gsyVideoOptionBuilder.setLockLand(lockLand)
        val overrideExtension = getParameter(videoOptions,"overrideExtension","");
        if(overrideExtension.isNotEmpty()){
            gsyVideoOptionBuilder.setOverrideExtension(overrideExtension)
        }
        videoPlayer.backButton.visibility = View.GONE
        gsyVideoOptionBuilder.build(videoPlayer);
        val autoPlay = getParameter(videoOptions,"autoPlay",true);
        if (autoPlay){
            videoPlayer.startPlayLogic()
        }
        val reply: MutableMap<String, Any> = HashMap()
        reply["setVideoConfig"] = true
        result.success(reply)
    }

    private fun setGlobalConfig(call: MethodCall, result: MethodChannel.Result) {
        val playerOptions = call.argument<Map<String, Any?>>(PLAYER_OPTIONS)!!
         playerType = getParameter(playerOptions,"playerType",0);
         renderType = getParameter(playerOptions,"renderType",0);
        when(playerType){
            0 -> PlayerFactory.setPlayManager(Exo2PlayerManager::class.java)
            1 -> PlayerFactory.setPlayManager(SystemPlayerManager::class.java)
            2 -> PlayerFactory.setPlayManager(IjkPlayerManager::class.java)
            3 -> PlayerFactory.setPlayManager(AliPlayerManager::class.java)
        }
        when(renderType){
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
        val showType = getParameter(showTypeOptions,SHOW_TYPE,0);
        val screenScaleRatio = getParameter(showTypeOptions,SCREEN_SCALE_RATIO,0.0F);
        when(showType){
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
        if(enableCodec){
            GSYVideoType.enableMediaCodec()
        }else{
            GSYVideoType.disableMediaCodec()
        }
    }
    private fun setMediaCodecTexture(call: MethodCall, result: MethodChannel.Result) {
        val enableCodecTexture: Boolean = call.argument(ENABLE_CODEC_TEXTURE)!!
        if(enableCodecTexture){
            GSYVideoType.enableMediaCodecTexture()
        }else{
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
            ENABLE_CODEC ->{
                setMediaCodec(call, result)
            }
            ENABLE_CODEC_TEXTURE ->{
                setMediaCodecTexture(call, result)
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
        private const val PLAY_METHOD = "play"
        private const val PAUSE_METHOD = "pause"
        private const val SEEK_TO_METHOD = "seekTo"
        private const val POSITION_METHOD = "position"
        private const val ABSOLUTE_POSITION_METHOD = "absolutePosition"
        private const val SET_SPEED_METHOD = "setSpeed"

        private const val CLEAR_CACHE_METHOD = "clearCache"
        private const val DISPOSE_METHOD = "dispose"
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
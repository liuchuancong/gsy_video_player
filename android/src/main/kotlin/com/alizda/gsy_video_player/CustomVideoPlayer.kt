package com.alizda.gsy_video_player


import android.app.Activity
import android.content.Context
import android.content.res.Configuration
import android.graphics.Color
import android.os.Build
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.annotation.RequiresApi
import com.alizda.gsy_video_player.GsyVideoPlayerView.Companion.eventSink
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer
import com.shuyu.gsyvideoplayer.video.base.GSYBaseVideoPlayer
import com.shuyu.gsyvideoplayer.video.base.GSYVideoPlayer
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import master.flame.danmaku.controller.DrawHandler
import master.flame.danmaku.controller.IDanmakuView
import master.flame.danmaku.danmaku.loader.IllegalDataException
import master.flame.danmaku.danmaku.loader.android.DanmakuLoaderFactory
import master.flame.danmaku.danmaku.model.BaseDanmaku
import master.flame.danmaku.danmaku.model.DanmakuTimer
import master.flame.danmaku.danmaku.model.Duration
import master.flame.danmaku.danmaku.model.IDisplayer.DANMAKU_STYLE_DEFAULT
import master.flame.danmaku.danmaku.model.IDisplayer.DANMAKU_STYLE_NONE
import master.flame.danmaku.danmaku.model.IDisplayer.DANMAKU_STYLE_PROJECTION
import master.flame.danmaku.danmaku.model.IDisplayer.DANMAKU_STYLE_SHADOW
import master.flame.danmaku.danmaku.model.IDisplayer.DANMAKU_STYLE_STROKEN
import master.flame.danmaku.danmaku.model.android.DanmakuContext
import master.flame.danmaku.danmaku.model.android.Danmakus
import master.flame.danmaku.danmaku.parser.BaseDanmakuParser
import master.flame.danmaku.ui.widget.DanmakuView


class CustomVideoPlayer : StandardGSYVideoPlayer {
    private var customGSYMediaPlayerListener: CustomGSYMediaPlayerListener = CustomGSYMediaPlayerListener(this)
    private var mParser: BaseDanmakuParser? = null //解析器对象
    private var danmakuView: IDanmakuView? = null //弹幕view
    private var danmakuContext: DanmakuContext? = null
    private var danmakuStartSeekPosition: Long = -1
    private var isLinkScroll = false
    private var orientationUtils: CustomOrientationUtils = CustomOrientationUtils(this, context)
    constructor(context: Context?, fullFlag: Boolean?) : super(context, fullFlag)
    constructor(context: Context?) : super(context)
    constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs)

    override fun getLayoutId(): Int {
        if (mIfCurrentIsFullscreen) {
            return R.layout.danmaku_layout_land
        }
        return R.layout.danmaku_layout
    }

    override fun init(context: Context) {
        super.init(context)
        initDanmaView()
    }
    private fun  addFullScreenListen(){
        if(fullscreenButton.isShown){
            fullscreenButton.setOnClickListener {
                orientationUtils.resolveByClick();
            };
        }
    }

    override fun updateStartImage() {
        if (mIfCurrentIsFullscreen) {
            if (mStartButton is ImageView) {
                val imageView = mStartButton as ImageView
                when (mCurrentState) {
                    CURRENT_STATE_PLAYING -> {
                        imageView.setImageResource(com.shuyu.gsyvideoplayer.R.drawable.video_click_pause_selector)
                    }
                    CURRENT_STATE_ERROR -> {
                        imageView.setImageResource(com.shuyu.gsyvideoplayer.R.drawable.video_click_play_selector)
                    }
                    else -> {
                        imageView.setImageResource(com.shuyu.gsyvideoplayer.R.drawable.video_click_play_selector)
                    }
                }
            }
        } else {
            super.updateStartImage()
        }
    }
    override fun clickStartIcon() {
        super.clickStartIcon()
    }

    fun handleEnterFullScreen() {
        if (mIfCurrentIsFullscreen) {
            if (mStartButton is ImageView) {
                val imageView = mStartButton as ImageView
                when (mCurrentState) {
                    CURRENT_STATE_PLAYING -> {
                        imageView.setImageResource(com.shuyu.gsyvideoplayer.R.drawable.video_click_pause_selector)
                    }

                    CURRENT_STATE_ERROR -> {
                        imageView.setImageResource(com.shuyu.gsyvideoplayer.R.drawable.video_click_play_selector)
                    }

                    else -> {
                        imageView.setImageResource(com.shuyu.gsyvideoplayer.R.drawable.video_click_play_selector)
                    }
                }
            }
            orientationUtils.resolveByClick()
        }else{
            orientationUtils.backToProtVideo()
        }
    }
    override fun getEnlargeImageRes(): Int {
        return R.drawable.custom_enlarge
    }

    override fun getShrinkImageRes(): Int {
        return R.drawable.custom_shrink
    }

    override fun onInterceptTouchEvent(ev: MotionEvent?): Boolean {
        if (isLinkScroll && !isIfCurrentIsFullscreen) {
            parent.requestDisallowInterceptTouchEvent(true)
        }
        return super.onInterceptTouchEvent(ev)
    }

    private fun initDanmaView() {
        if (danmakuView == null) {
            danmakuView = findViewById<View>(R.id.danmaku_view) as DanmakuView
        }
        if (danmakuContext == null) {
            danmakuContext = DanmakuContext.create()
        }
    }

    override fun cloneParams(from: GSYBaseVideoPlayer, to: GSYBaseVideoPlayer) {
        super.cloneParams(from, to)
    }

    /**
     * 处理播放器在全屏切换时，弹幕显示的逻辑
     * 需要格外注意的是，因为全屏和小屏，是切换了播放器，所以需要同步之间的弹幕状态
     */
    override fun startWindowFullscreen(context: Context, actionBar: Boolean, statusBar: Boolean): GSYBaseVideoPlayer {
        val gsyBaseVideoPlayer = super.startWindowFullscreen(context, actionBar, statusBar)
        if (gsyBaseVideoPlayer != null) {
            val gsyVideoPlayer = gsyBaseVideoPlayer as CustomVideoPlayer
            //对弹幕设置偏移记录
            gsyVideoPlayer.danmakuStartSeekPosition = currentPositionWhenPlaying
            onPrepareDanmaku(gsyVideoPlayer)
        }
        return gsyBaseVideoPlayer
    }

    /**
     * 处理播放器在退出全屏时，弹幕显示的逻辑
     * 需要格外注意的是，因为全屏和小屏，是切换了播放器，所以需要同步之间的弹幕状态
     */
    override fun resolveNormalVideoShow(oldF: View, vp: ViewGroup, gsyVideoPlayer: GSYVideoPlayer) {
        val landLayoutVideo: CustomVideoPlayer = gsyVideoPlayer as CustomVideoPlayer
        landLayoutVideo.dismissProgressDialog()
        landLayoutVideo.dismissVolumeDialog()
        landLayoutVideo.dismissBrightnessDialog()
        if (danmakuView != null && danmakuView!!.isPrepared) {
            resolveDanmakuSeek(this, currentPositionWhenPlaying)
            resolveDanmakuShow()
            releaseDanmaku(this)
        }
        super.resolveNormalVideoShow(oldF, vp, gsyVideoPlayer)
    }

    fun setLinkScroll(linkScroll: Boolean) {
        isLinkScroll = linkScroll
    }

    /**
     * 定义结束后的显示
     */
    override fun changeUiToCompleteClear() {
        super.changeUiToCompleteClear()
        setTextAndProgress(0, true)
        //changeUiToNormal();
    }

    override fun changeUiToCompleteShow() {
        super.changeUiToCompleteShow()
        setTextAndProgress(0, true)
        //changeUiToNormal();
    }
    protected fun danmakuOnPause() {
        if (danmakuView != null && danmakuView!!.isPrepared && DanmukuSettings.pauseWhenVideoPaused) {
            danmakuView!!.pause()
        }
    }

    protected fun danmakuOnResume() {
        if (danmakuView != null && danmakuView!!.isPrepared && danmakuView!!.isPaused && DanmukuSettings.pauseWhenVideoPaused) {
            danmakuView!!.resume()
        }
    }

    fun initDanmaku(call: MethodCall, result: MethodChannel.Result) {
        val danmakuSettings = call.argument<Map<String, Any?>>("danmakuSettings")!!
        val danmakuStyle = GsyVideoPlayerView.getParameter(danmakuSettings, "danmakuStyle", DANMAKU_STYLE_DEFAULT)
        val url = GsyVideoPlayerView.getParameter(danmakuSettings, "url", "")
        val isLinkFile = GsyVideoPlayerView.getParameter(danmakuSettings, "isLinkFile", false)
        val danmuStyleShadow = (GsyVideoPlayerView.getParameter(danmakuSettings, "shadowRadius", 0.0) as Number).toFloat()
        val danmuStyleStroked = (GsyVideoPlayerView.getParameter(danmakuSettings, "strokenWidth", 0.0) as Number).toFloat()
        val danmuStyleProjectionOffsetX = (GsyVideoPlayerView.getParameter(danmakuSettings, "projectionOffsetX", 0.0) as Number).toFloat()
        val danmuStyleProjectionOffsetY = (GsyVideoPlayerView.getParameter(danmakuSettings, "projectionOffsetY", 0.0) as Number).toFloat()
        val danmuStyleProjectionAlpha = (GsyVideoPlayerView.getParameter(danmakuSettings, "projectionAlpha", 0) as Number).toFloat()
        val isBold = GsyVideoPlayerView.getParameter(danmakuSettings, "isBold", false)
        val showDanmaku = GsyVideoPlayerView.getParameter(danmakuSettings, "showDanmaku", false)
        val duplicateMergingEnabled = GsyVideoPlayerView.getParameter(danmakuSettings, "duplicateMergingEnabled", false)
        val lap: HashMap<Int, Boolean>? = null
        val overlappingEnablePair = GsyVideoPlayerView.getParameter(danmakuSettings, "overlappingEnablePair", lap)
        val pair: HashMap<Int, Int>? = null
        val maxLinesPair = GsyVideoPlayerView.getParameter(danmakuSettings, "maxLinesPair", pair)
        val opacity = (GsyVideoPlayerView.getParameter(danmakuSettings, "opacity", 0.0f) as Number).toFloat()
        val scaleTextSize = (GsyVideoPlayerView.getParameter(danmakuSettings, "scaleTextSize", 0.0f) as Number).toFloat()
        val margin = (GsyVideoPlayerView.getParameter(danmakuSettings, "margin", 0) as Number).toInt()
        val marginTop = (GsyVideoPlayerView.getParameter(danmakuSettings, "marginTop", 0) as Number).toInt()
        val maximumVisibleSizeInScreen = (GsyVideoPlayerView.getParameter(danmakuSettings, "maximumVisibleSizeInScreen", 0) as Number).toInt()
        val pauseWhenVideoPaused = GsyVideoPlayerView.getParameter(danmakuSettings, "pauseWhenVideoPaused", true)
        val enableDanmakuDrawingCache = GsyVideoPlayerView.getParameter(danmakuSettings, "enableDanmakuDrawingCache", true)
        DanmukuSettings.danmakuStyle = danmakuStyle
        DanmukuSettings.shadowRadius = danmuStyleShadow
        DanmukuSettings.strokenWidth = danmuStyleStroked
        DanmukuSettings.projectionOffsetX = danmuStyleProjectionOffsetX
        DanmukuSettings.projectionOffsetY = danmuStyleProjectionOffsetY
        DanmukuSettings.projectionAlpha = danmuStyleProjectionAlpha
        DanmukuSettings.isBold = isBold
        DanmukuSettings.duplicateMergingEnabled = duplicateMergingEnabled
        DanmukuSettings.overlappingEnablePair = overlappingEnablePair
        DanmukuSettings.maxLinesPair = maxLinesPair
        DanmukuSettings.opacity = opacity
        DanmukuSettings.scaleTextSize = scaleTextSize
        DanmukuSettings.margin = margin
        DanmukuSettings.marginTop = marginTop
        DanmukuSettings.maximumVisibleSizeInScreen = maximumVisibleSizeInScreen
        DanmukuSettings.pauseWhenVideoPaused = pauseWhenVideoPaused
        DanmukuSettings.enableDanmakuDrawingCache = enableDanmakuDrawingCache
        DanmukuSettings.isLinkFile = isLinkFile
        DanmukuSettings.url = url
        DanmukuSettings.showDanmaku = showDanmaku
        when (DanmukuSettings.danmakuStyle) {
            DANMAKU_STYLE_NONE -> danmakuContext!!.setDanmakuStyle(DanmukuSettings.danmakuStyle)
            DANMAKU_STYLE_SHADOW -> danmakuContext!!.setDanmakuStyle(DanmukuSettings.danmakuStyle, DanmukuSettings.shadowRadius)

            DANMAKU_STYLE_STROKEN -> danmakuContext!!.setDanmakuStyle(DanmukuSettings.danmakuStyle, DanmukuSettings.strokenWidth)

            DANMAKU_STYLE_PROJECTION -> danmakuContext!!.setDanmakuStyle(DanmukuSettings.danmakuStyle, DanmukuSettings.projectionOffsetX, DanmukuSettings.projectionOffsetY, DanmukuSettings.projectionAlpha)
        }
        danmakuContext!!.setDanmakuBold(DanmukuSettings.isBold)
        danmakuContext!!.setScrollSpeedFactor(DanmukuSettings.scrollSpeedFactor)
        danmakuContext!!.setScaleTextSize(DanmukuSettings.scaleTextSize)
        danmakuContext!!.setDuplicateMergingEnabled(DanmukuSettings.duplicateMergingEnabled)
        danmakuContext!!.preventOverlapping(DanmukuSettings.overlappingEnablePair)
        danmakuContext!!.setMaximumLines(DanmukuSettings.maxLinesPair)
        danmakuContext!!.setDanmakuTransparency(DanmukuSettings.opacity)
        danmakuContext!!.setDanmakuMargin(DanmukuSettings.margin)
        danmakuContext!!.setMarginTop(DanmukuSettings.marginTop)
        danmakuContext!!.setMaximumVisibleSizeInScreen(DanmukuSettings.maximumVisibleSizeInScreen)
        if (danmakuView != null) {
            mParser = createParser()
            danmakuView!!.setCallback(object : DrawHandler.Callback {
                override fun danmakuShown(danmaku: BaseDanmaku?) {
                }

                override fun updateTimer(timer: DanmakuTimer) {

                }

                override fun drawingFinished() {
                }

                override fun prepared() {
                    if (DanmukuSettings.isLinkFile) {
                        danmakuView!!.start(currentPositionWhenPlaying)
                    } else {
                        danmakuView!!.start()
                    }
                    if (currentState != GSYVideoPlayer.CURRENT_STATE_PLAYING && DanmukuSettings.pauseWhenVideoPaused) {
                        danmakuView!!.pause()
                    }
                    resolveDanmakuShow()
                }
            })
            danmakuView!!.prepare(mParser, danmakuContext)
            danmakuView!!.enableDanmakuDrawingCache(DanmukuSettings.enableDanmakuDrawingCache)
            danmakuView!!.start()
            resolveDanmakuShow()
            onPrepareDanmaku(this)
            val event: MutableMap<String, Any?> = HashMap()
            event["event"] = "onListenerInitDanmakuSuccess"
            eventSink.success(event)
        }
    }

    /**
     * 弹幕的显示与关闭
     */
    private fun resolveDanmakuShow() {
        post {
            if (DanmukuSettings.showDanmaku) {
                if (!danmakuView?.isShown!!) danmakuView!!.show()
            } else {
                if (danmakuView?.isShown == true) {
                    danmakuView!!.hide()
                }
            }
        }
    }

    /**
     * 开始播放弹幕
     */
    private fun onPrepareDanmaku(gsyVideoPlayer: CustomVideoPlayer) {
        if (gsyVideoPlayer.danmakuView != null && !gsyVideoPlayer.danmakuView!!.isPrepared && mParser != null) {
            gsyVideoPlayer.danmakuView!!.prepare(gsyVideoPlayer.mParser, gsyVideoPlayer.danmakuContext)
        }
    }

    /**
     * 弹幕偏移
     */
    private fun resolveDanmakuSeek(gsyVideoPlayer: CustomVideoPlayer, time: Long) {
        if (mHadPlay && gsyVideoPlayer.danmakuView != null && gsyVideoPlayer.danmakuView!!.isPrepared) {
            gsyVideoPlayer.danmakuView!!.seekTo(time)
        }
    }

    /**
     * 创建解析器对象，解析输入流
     *
     * @return
     */
    private fun createParser(): BaseDanmakuParser {
        if (!DanmukuSettings.isLinkFile) {
            return object : BaseDanmakuParser() {
                override fun parse(): Danmakus {
                    return Danmakus()
                }
            }
        }
        val loader = DanmakuLoaderFactory.create(DanmakuLoaderFactory.TAG_BILI)
        try {
            loader.load(DanmukuSettings.url)
        } catch (e: IllegalDataException) {
            e.printStackTrace()
        }
        val parser = CustomDanmukuParser()
        val dataSource = loader.dataSource
        parser.load(dataSource)
        return parser
    }

    /**
     * 释放弹幕控件
     */
    private fun releaseDanmaku(danmakuVideoPlayer: CustomVideoPlayer?) {
        if (danmakuVideoPlayer?.danmakuView != null) {
            danmakuVideoPlayer.danmakuView!!.release()
        }
    }

    /**
     * 模拟添加弹幕数据
     */
    fun addDanmaku(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val danmakuOptions = call.argument<Map<String, Any?>>("danmaku")!!
        val type = GsyVideoPlayerView.getParameter(danmakuOptions, "type", BaseDanmaku.TYPE_SCROLL_RL)
        val danmaku = danmakuContext!!.mDanmakuFactory.createDanmaku(type)
        if (danmaku == null || danmakuView == null) {
            return
        }
        val time = (GsyVideoPlayerView.getParameter(danmakuOptions, "time", 0) as Number).toInt().toLong()
        val timeOffset = (GsyVideoPlayerView.getParameter(danmakuOptions, "timeOffset", 0) as Number).toInt().toLong()
        val text = GsyVideoPlayerView.getParameter(danmakuOptions, "text", "")
        val emptyLinesArray = arrayOf<String>()
        val lines = GsyVideoPlayerView.getParameter(danmakuOptions, "lines", emptyLinesArray)
        val textColor = GsyVideoPlayerView.getParameter(danmakuOptions, "textColor", "")
        val textShadowColor = GsyVideoPlayerView.getParameter(danmakuOptions, "textShadowColor", "")
        val underlineColor = GsyVideoPlayerView.getParameter(danmakuOptions, "underlineColor", "")
        val borderColor = GsyVideoPlayerView.getParameter(danmakuOptions, "borderColor", "")
        val textSize = GsyVideoPlayerView.getParameter(danmakuOptions, "textSize", -1)
        val rotationZ = (GsyVideoPlayerView.getParameter(danmakuOptions, "rotationZ", 0.0F) as Number).toFloat()
        val rotationY = (GsyVideoPlayerView.getParameter(danmakuOptions, "rotationY", 0.0F) as Number).toFloat()
        val padding = GsyVideoPlayerView.getParameter(danmakuOptions, "padding", 0)
        val priority = GsyVideoPlayerView.getParameter(danmakuOptions, "priority", 10)
        val paintWidth = GsyVideoPlayerView.getParameter(danmakuOptions, "paintWidth", -1)
        val paintHeight = GsyVideoPlayerView.getParameter(danmakuOptions, "paintHeight", -1)
        val duration = (GsyVideoPlayerView.getParameter(danmakuOptions, "duration", 0) as Number).toInt()
        val index = GsyVideoPlayerView.getParameter(danmakuOptions, "index", -1)
        val visibility = GsyVideoPlayerView.getParameter(danmakuOptions, "visibility", true)
        val isLive = GsyVideoPlayerView.getParameter(danmakuOptions, "isLive", true)
        val userId = GsyVideoPlayerView.getParameter(danmakuOptions, "userId", 0)
        val userHash = GsyVideoPlayerView.getParameter(danmakuOptions, "userHash", "")
        val isGuest = GsyVideoPlayerView.getParameter(danmakuOptions, "isGuest", true)
        val forceBuildCacheInSameThread = GsyVideoPlayerView.getParameter(danmakuOptions, "forceBuildCacheInSameThread", true)
        if (time.toInt() != 0) {
            danmaku.time = danmakuView!!.currentTime + time
        } else {
            danmaku.time = danmakuView!!.currentTime
        }
        if (timeOffset.toInt() != 0) {
            danmaku.timeOffset = timeOffset
        }
        danmaku.text = text
        if (lines.isNotEmpty()) {
            danmaku.lines = lines
        }
        if (rotationZ != 0.0f) {
            danmaku.rotationZ = rotationZ
        }
        if (rotationY != 0.0f) {
            danmaku.rotationY = rotationY
        }
        if (textColor.isNotEmpty()) {
            danmaku.textColor = transferColor(textColor)
        }
        if (textShadowColor.isNotEmpty()) {
            danmaku.textShadowColor = transferColor(textShadowColor)
        }
        if (underlineColor.isNotEmpty()) {
            danmaku.underlineColor = transferColor(underlineColor)
        }
        if (borderColor.isNotEmpty()) {
            danmaku.borderColor = transferColor(borderColor)
        }
        if (textSize != -1) {
            danmaku.textSize = (textSize as Number?)!!.toFloat()
        }
        if (padding != 0) {
            danmaku.padding = padding
        }
        danmaku.priority = (priority as Number?)!!.toInt().toByte()
        if (paintWidth != -1) {
            danmaku.paintWidth = (paintWidth as Number?)!!.toFloat()
        }
        if (paintHeight != -1) {
            danmaku.paintHeight = (paintHeight as Number?)!!.toFloat()
        }
        if (duration != 0) {
            danmaku.duration = Duration(duration.toLong())
        }
        if (index != -1) {
            danmaku.index = index
        }
        danmaku.visibility = isBoolean(visibility)
        danmaku.isLive = isLive
        danmaku.userId = userId
        danmaku.isGuest = isGuest
        danmaku.userHash = userHash
        danmaku.forceBuildCacheInSameThread = forceBuildCacheInSameThread
        danmakuView!!.addDanmaku(danmaku)
    }

    private fun transferColor(transColor: String): Int {
        return  Color.parseColor(transColor)
    }

    private fun isBoolean(boo: Boolean): Int {
        return if (boo) {
            1
        } else {
            0
        }
    }

    /**
     * 旋转处理
     *
     * @param activity         页面
     * @param newConfig        配置
     * @param orientationUtils 旋转工具类
     */
    override fun onConfigurationChanged(activity: Activity?, newConfig: Configuration?, orientationUtils: OrientationUtils?) {
        super.onConfigurationChanged(activity, newConfig, orientationUtils)
        customGSYMediaPlayerListener.onConfigurationChanged(eventSink)
    }


    override fun onPrepared() {
        if (!GsyVideoPlayerView.isInitialized) {
            GsyVideoPlayerView.isInitialized = true
            customGSYMediaPlayerListener.sendInitialized(eventSink)
        }
        super.onPrepared()
        customGSYMediaPlayerListener.onPrepared(eventSink)
        addFullScreenListen()
    }


    override fun onAutoCompletion() {
        super.onAutoCompletion()
        customGSYMediaPlayerListener.onAutoCompletion(eventSink)
    }

    override fun onCompletion() {
        super.onCompletion()
        customGSYMediaPlayerListener.onCompletion(eventSink)
    }

    override fun onBufferingUpdate(percent: Int) {
        super.onBufferingUpdate(percent)
        customGSYMediaPlayerListener.onBufferingUpdate(eventSink, percent)
    }

    override fun onSeekComplete() {
        super.onSeekComplete()
        customGSYMediaPlayerListener.onSeekComplete(eventSink)
        val time = mProgressBar.progress * duration / 100
        //如果已经初始化过的，直接seek到对于位置
        if (mHadPlay && danmakuView != null && danmakuView!!.isPrepared && DanmukuSettings.pauseWhenVideoPaused) {
            resolveDanmakuSeek(this, time)
        } else if (mHadPlay && danmakuView != null && !danmakuView!!.isPrepared && DanmukuSettings.pauseWhenVideoPaused) {
            //如果没有初始化过的，记录位置等待
            danmakuStartSeekPosition = time
        }
    }

    override fun onError(what: Int, extra: Int) {
        super.onError(what, extra)
        customGSYMediaPlayerListener.onError(eventSink, what, extra)
    }

    override fun onInfo(what: Int, extra: Int) {
        super.onInfo(what, extra)
        customGSYMediaPlayerListener.onInfo(eventSink, what, extra)
    }

    override fun onVideoSizeChanged() {
        super.onVideoSizeChanged()
        customGSYMediaPlayerListener.onVideoSizeChanged(eventSink)
    }

    override fun onBackFullscreen() {
        super.onBackFullscreen()
        customGSYMediaPlayerListener.onBackFullscreen(eventSink)
    }

    override fun onVideoPause() {
        super.onVideoPause()
        customGSYMediaPlayerListener.onVideoPause(eventSink)
    }

    override fun onVideoResume() {
        super.onVideoResume()
        customGSYMediaPlayerListener.onVideoResume(eventSink)
        danmakuOnResume()
    }

    override fun onVideoResume(seek: Boolean) {
        super.onVideoResume(seek)
        customGSYMediaPlayerListener.onVideoResume(eventSink, seek)
        danmakuOnPause()
    }

    fun showDanmaku(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        DanmukuSettings.showDanmaku = true
        if (!danmakuView!!.isShown) {
            danmakuView!!.show()
        }
    }

    fun startDanmaku(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        if (danmakuView!!.isShown) {
            danmakuView!!.start()
        }
    }

    fun getDannakuStatus(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val reply: MutableMap<String, Any> = HashMap()
        reply["isPrepared"] = danmakuView!!.isPrepared
        reply["isPaused"] = danmakuView!!.isPaused
        reply["isShown"] = danmakuView!!.isShown
        result.success(reply)
    }

    fun resumeDanmaku(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        if (danmakuView!!.isPaused) {
            danmakuView!!.resume()
        }
    }
    fun pauseDanmaku(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        if (!danmakuView!!.isPaused) {
            danmakuView!!.pause()
        }
    }
    fun stopDanmaku(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        if (danmakuView!!.isShown) {
            danmakuView!!.stop()
        }
    }

    fun seekToDanmaku(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val ms = (call.argument<Any>("ms")!! as Number).toInt().toLong()
        if (danmakuView!!.isShown) {
            danmakuView!!.seekTo(ms)
        }
    }


    fun getDanmakuShow(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val reply: MutableMap<String, Any> = HashMap()
        reply["showDanmaku"] = DanmukuSettings.showDanmaku
        result.success(reply)
    }

    fun hideDanmaku(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        DanmukuSettings.showDanmaku = false
        if (danmakuView!!.isShown) {
            danmakuView!!.hide()
        }
    }

    fun setDanmakuStyle(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val danmakuStyle = call.argument<Int>("danmakuStyle")!!
        val danmuStyleShadow = (call.argument<Any>("danmuStyleShadow") as Number).toFloat()
        val danmuStyleStroked = (call.argument<Any>("danmuStyleStroked") as Number).toFloat()
        val danmuStyleProjectionOffsetX = (call.argument<Any>("danmuStyleProjectionOffsetX") as Number).toFloat()
        val danmuStyleProjectionOffsetY = (call.argument<Any>("danmuStyleProjectionOffsetY") as Number).toFloat()
        val danmuStyleProjectionAlpha = (call.argument<Any>("danmuStyleProjectionAlpha") as Number).toFloat()
        DanmukuSettings.danmakuStyle = danmakuStyle
        DanmukuSettings.shadowRadius = danmuStyleShadow
        DanmukuSettings.strokenWidth = danmuStyleStroked
        DanmukuSettings.projectionOffsetX = danmuStyleProjectionOffsetX
        DanmukuSettings.projectionOffsetY = danmuStyleProjectionOffsetY
        DanmukuSettings.projectionAlpha = danmuStyleProjectionAlpha

        when (danmakuStyle) {
            DANMAKU_STYLE_NONE -> danmakuContext!!.setDanmakuStyle(DANMAKU_STYLE_NONE)
            DANMAKU_STYLE_SHADOW -> danmakuContext!!.setDanmakuStyle(DanmukuSettings.danmakuStyle, DanmukuSettings.shadowRadius)

            DANMAKU_STYLE_STROKEN -> danmakuContext!!.setDanmakuStyle(DanmukuSettings.danmakuStyle, DanmukuSettings.strokenWidth)

            DANMAKU_STYLE_PROJECTION -> danmakuContext!!.setDanmakuStyle(DanmukuSettings.danmakuStyle, DanmukuSettings.projectionOffsetX, DanmukuSettings.projectionOffsetY, DanmukuSettings.projectionAlpha)
        }
    }

    fun setDanmakuTransparency(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val transparency = (call.argument<Any>("transparency") as Number).toFloat()
        DanmukuSettings.opacity = transparency
        danmakuContext!!.setDanmakuTransparency(DanmukuSettings.opacity)
    }

    fun setDanmakuMargin(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val margin = (call.argument<Any>("margin") as Number).toInt()
        DanmukuSettings.margin = margin
        danmakuContext!!.setDanmakuMargin(DanmukuSettings.margin)
    }

    fun setScaleTextSize(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val scale = (call.argument<Any>("scale") as Number).toFloat()
        DanmukuSettings.scaleTextSize = scale
        danmakuContext!!.setScaleTextSize(DanmukuSettings.scaleTextSize)
    }

    fun setMaximumVisibleSizeInScreen(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val maximumVisibleSizeInScreen = (call.argument<Any>("maximumVisibleSizeInScreen") as Number).toInt()
        DanmukuSettings.maximumVisibleSizeInScreen = maximumVisibleSizeInScreen
        danmakuContext!!.setMaximumVisibleSizeInScreen(DanmukuSettings.maximumVisibleSizeInScreen)
    }

    fun setDanmakuBold(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val isBold = call.argument<Boolean>("isBold")!!
        DanmukuSettings.isBold = isBold
        danmakuContext!!.setDanmakuBold(DanmukuSettings.isBold)
    }

    fun setScrollSpeedFactor(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val scale = (call.argument<Any>("speedFactor") as Number).toFloat()
        DanmukuSettings.scrollSpeedFactor = scale
        danmakuContext!!.setScrollSpeedFactor(DanmukuSettings.scrollSpeedFactor)
    }

    fun setDuplicateMergingEnabled(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val enabled = call.argument<Boolean>("enabled")!!
        DanmukuSettings.duplicateMergingEnabled = enabled
        danmakuContext!!.setDuplicateMergingEnabled(DanmukuSettings.duplicateMergingEnabled)
    }

    fun setMaximumLines(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val maxLinesPair = call.argument<HashMap<Int, Int>?>("maxLinesPair")!!
        DanmukuSettings.maxLinesPair = maxLinesPair
        danmakuContext!!.setMaximumLines(DanmukuSettings.maxLinesPair)
    }

    fun preventOverlapping(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val overlappingEnablePair = call.argument<HashMap<Int, Boolean>?>("preventPair")!!
        DanmukuSettings.overlappingEnablePair = overlappingEnablePair
        danmakuContext!!.preventOverlapping(DanmukuSettings.overlappingEnablePair)
    }

    fun setMarginTop(call: MethodCall, result: MethodChannel.Result) {
        initDanmaView()
        val marginTop = (call.argument<Any>("marginTop") as Number).toInt()
        DanmukuSettings.marginTop = marginTop
        danmakuContext!!.setMarginTop(DanmukuSettings.marginTop)
    }

}
package com.alizda.gsy_video_player

import android.app.Activity
import android.content.Context
import android.content.res.Configuration
import android.graphics.Color
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import com.shuyu.gsyvideoplayer.utils.Debuger
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer
import com.shuyu.gsyvideoplayer.video.base.GSYBaseVideoPlayer
import com.shuyu.gsyvideoplayer.video.base.GSYVideoPlayer
import master.flame.danmaku.controller.DrawHandler
import master.flame.danmaku.controller.IDanmakuView
import master.flame.danmaku.danmaku.loader.IllegalDataException
import master.flame.danmaku.danmaku.loader.android.DanmakuLoaderFactory
import master.flame.danmaku.danmaku.model.BaseDanmaku
import master.flame.danmaku.danmaku.model.DanmakuTimer
import master.flame.danmaku.danmaku.model.IDisplayer
import master.flame.danmaku.danmaku.model.android.DanmakuContext
import master.flame.danmaku.danmaku.model.android.SpannedCacheStuffer
import master.flame.danmaku.danmaku.parser.BaseDanmakuParser
import master.flame.danmaku.ui.widget.DanmakuView
import java.io.File

class CustomVideoPlayer : StandardGSYVideoPlayer {
    private var mParser: BaseDanmakuParser? = null //解析器对象
    private var danmakuView: IDanmakuView? = null //弹幕view
    private var danmakuContext: DanmakuContext? = null
    private var danmakuStartSeekPosition: Long = -1
    private var danmaKuShow = true
    private var mDumakuFile: File? = null
    constructor(context: Context?, fullFlag: Boolean?) : super(context, fullFlag)
    constructor(context: Context?) : super(context)
    constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs)

    override fun getLayoutId(): Int {
        return R.layout.danmaku_layout
    }

    override fun init(context: Context) {
        super.init(context)
        danmakuView = findViewById<View>(R.id.danmaku_view) as DanmakuView
        //初始化弹幕显示
//        initDanmaku()
    }

    override fun onPrepared() {
        super.onPrepared()
        onPrepareDanmaku(this)
    }

    override fun onVideoPause() {
        super.onVideoPause()
        danmakuOnPause()
    }

    override fun onVideoResume(isResume: Boolean) {
        super.onVideoResume(isResume)
        danmakuOnResume()
    }

    override fun clickStartIcon() {
        super.clickStartIcon()
        if (mCurrentState == CURRENT_STATE_PLAYING) {
            danmakuOnResume()
        } else if (mCurrentState == CURRENT_STATE_PAUSE) {
            danmakuOnPause()
        }
    }

    override fun onCompletion() {
        super.onCompletion()
        releaseDanmaku(this)
    }

    override fun onSeekComplete() {
        super.onSeekComplete()
        val time = mProgressBar.progress * duration / 100
        //如果已经初始化过的，直接seek到对于位置
        if (mHadPlay && danmakuView != null && danmakuView!!.isPrepared) {
            resolveDanmakuSeek(this, time)
        } else if (mHadPlay && danmakuView != null && !danmakuView!!.isPrepared) {
            //如果没有初始化过的，记录位置等待
            danmakuStartSeekPosition = time
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
            gsyVideoPlayer.danmaKuShow = danmaKuShow
            onPrepareDanmaku(gsyVideoPlayer)
        }
        return gsyBaseVideoPlayer
    }

    /**
     * 处理播放器在退出全屏时，弹幕显示的逻辑
     * 需要格外注意的是，因为全屏和小屏，是切换了播放器，所以需要同步之间的弹幕状态
     */
    override fun resolveNormalVideoShow(oldF: View, vp: ViewGroup, gsyVideoPlayer: GSYVideoPlayer) {
        super.resolveNormalVideoShow(oldF, vp, gsyVideoPlayer)
        val gsyDanmaVideoPlayer = gsyVideoPlayer as CustomVideoPlayer
        danmaKuShow = gsyDanmaVideoPlayer.danmaKuShow
        if (gsyDanmaVideoPlayer.danmakuView != null &&
                gsyDanmaVideoPlayer.danmakuView!!.isPrepared) {
            resolveDanmakuSeek(this, gsyDanmaVideoPlayer.currentPositionWhenPlaying)
            resolveDanmakuShow()
            releaseDanmaku(gsyDanmaVideoPlayer)
        }
    }

    protected fun danmakuOnPause() {
        if (danmakuView != null && danmakuView!!.isPrepared) {
            danmakuView!!.pause()
        }
    }

    protected fun danmakuOnResume() {
        if (danmakuView != null && danmakuView!!.isPrepared && danmakuView!!.isPaused) {
            danmakuView!!.resume()
        }
    }

    private fun initDanmaku(uri: String) {
        // 设置最大显示行数
        val maxLinesPair = HashMap<Int, Int>()
        maxLinesPair[BaseDanmaku.TYPE_SCROLL_RL] = 5 // 滚动弹幕最大显示5行
        // 设置是否禁止重叠
        val overlappingEnablePair = HashMap<Int, Boolean>()
        overlappingEnablePair[BaseDanmaku.TYPE_SCROLL_RL] = true
        overlappingEnablePair[BaseDanmaku.TYPE_FIX_TOP] = true
        val danmakuAdapter = DanamakuAdapter(danmakuView)
        danmakuContext = DanmakuContext.create()
        danmakuContext!!.setDanmakuStyle(IDisplayer.DANMAKU_STYLE_STROKEN, 3f).setDuplicateMergingEnabled(false).setScrollSpeedFactor(1.2f).setScaleTextSize(1.2f)
                .setCacheStuffer(SpannedCacheStuffer(), danmakuAdapter) // 图文混排使用SpannedCacheStuffer
                .setMaximumLines(maxLinesPair)
                .preventOverlapping(overlappingEnablePair)
        if (danmakuView != null) {
            mParser = createParser(uri)
            danmakuView!!.setCallback(object : DrawHandler.Callback {
                override fun danmakuShown(danmaku: BaseDanmaku?) {

                }

                override fun updateTimer(timer: DanmakuTimer) {

                }

                override fun drawingFinished() {

                }

                override fun prepared() {
                    danmakuView!!.start(currentPositionWhenPlaying.toLong())
                    if (currentState != GSYVideoPlayer.CURRENT_STATE_PLAYING) {
                        danmakuView!!.pause()
                    }
                }
            })
            danmakuView!!.prepare(mParser, danmakuContext)
            danmakuView!!.enableDanmakuDrawingCache(true)
        }
    }

    /**
     * 弹幕的显示与关闭
     */
    private fun resolveDanmakuShow() {
        post {
            if (danmaKuShow) {
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
            gsyVideoPlayer.danmakuView!!.prepare(gsyVideoPlayer.mParser,
                    gsyVideoPlayer.danmakuContext)
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
    private fun createParser(uri: String): BaseDanmakuParser {
        val loader = DanmakuLoaderFactory.create(DanmakuLoaderFactory.TAG_BILI)

        try {
            loader.load(uri)
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
            Debuger.printfError("release Danmaku!")
            danmakuVideoPlayer.danmakuView!!.release()
        }
    }

    /**
     * 模拟添加弹幕数据
     */
    private fun addDanmaku(islive: Boolean) {
        val danmaku = danmakuContext!!.mDanmakuFactory.createDanmaku(BaseDanmaku.TYPE_SCROLL_RL)
        if (danmaku == null || danmakuView == null) {
            return
        }
        danmaku.text = "这是一条弹幕 $currentPositionWhenPlaying"
        danmaku.padding = 5
        danmaku.priority = 8 // 可能会被各种过滤器过滤并隐藏显示，所以提高等级
        danmaku.isLive = islive
        danmaku.setTime(danmakuView!!.currentTime + 1200)
        danmaku.textSize = 25f * (mParser!!.displayer.density - 0.6f)
        danmaku.textColor = Color.RED
        danmaku.textShadowColor = Color.WHITE
        danmaku.borderColor = Color.GREEN
        danmakuView!!.addDanmaku(danmaku)
    }
    /**
     * 旋转处理
     *
     * @param activity         页面
     * @param newConfig        配置
     * @param orientationUtils 旋转工具类
     */
    override fun onConfigurationChanged(
        activity: Activity?,
        newConfig: Configuration?,
        orientationUtils: OrientationUtils?
    ) {
        super.onConfigurationChanged(activity, newConfig, orientationUtils)

    }

}
package com.alizda.gsy_video_player

import android.content.Context
import android.graphics.Color
import android.util.AttributeSet
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.shuyu.gsyvideoplayer.utils.Debuger
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer
import com.shuyu.gsyvideoplayer.video.base.GSYBaseVideoPlayer
import com.shuyu.gsyvideoplayer.video.base.GSYVideoPlayer
import master.flame.danmaku.controller.IDanmakuView
import master.flame.danmaku.danmaku.loader.IllegalDataException
import master.flame.danmaku.danmaku.loader.android.DanmakuLoaderFactory
import master.flame.danmaku.danmaku.model.BaseDanmaku
import master.flame.danmaku.danmaku.model.IDisplayer
import master.flame.danmaku.danmaku.model.android.DanmakuContext
import master.flame.danmaku.danmaku.model.android.Danmakus
import master.flame.danmaku.danmaku.model.android.SpannedCacheStuffer
import master.flame.danmaku.danmaku.parser.BaseDanmakuParser
import master.flame.danmaku.ui.widget.DanmakuView
import java.io.BufferedReader
import java.io.ByteArrayInputStream
import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.IOException
import java.io.InputStream
import java.io.InputStreamReader


/**
 * Created by guoshuyu on 2017/2/16.
 *
 *
 * 配置弹幕使用的播放器，目前使用的是本地模拟数据。
 *
 *
 * 模拟数据的弹幕时常比较短，后面的时长点是没有数据的。
 *
 *
 * 注意：这只是一个例子，演示如何集合弹幕，需要完善如弹出输入弹幕等的，可以自行完善。
 * 注意：b站的弹幕so只有v5 v7 x86、没有64，所以记得配置上ndk过滤。
 */
class CustomVideoPlayer : StandardGSYVideoPlayer {
    private var mParser: BaseDanmakuParser? = null //解析器对象
    private var danmakuView: IDanmakuView? = null //弹幕view
    private var danmakuContext: DanmakuContext? = null
    private var danmakuStartSeekPosition: Long = -1
    private var danmaKuShow = true
    private var mDumakuFile: File? = null
    private lateinit var videoView: View
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

    fun setDanmaKuStream(`is`: File?) {
        mDumakuFile = `is`
        if (!danmakuView!!.isPrepared) {
            onPrepareDanmaku(currentPlayer as CustomVideoPlayer)
        }
    }

    private fun initDanmaku() {
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
            if (mDumakuFile != null) {
                mParser = createParser(getIsStream(mDumakuFile!!))
            }

            //todo 这是为了demo效果，实际上需要去掉这个，外部传输文件进来
//            mParser = createParser()
//            danmakuView!!.setCallback(object : DrawHandler.Callback {
//                override fun updateTimer(timer: DanmakuTimer) {}
//                override fun drawingFinished() {}
//                override fun danmakuShown(danmaku: BaseDanmaku) {}
//                override fun prepared() {
//                    if (danmakuView != null) {
//                        danmakuView!!.start()
//                        if (danmakuStartSeekPosition != -1L) {
//                            resolveDanmakuSeek(this@CustomVideoPlayer, danmakuStartSeekPosition)
//                            danmakuStartSeekPosition = -1
//                        }
//                        resolveDanmakuShow()
//                    }
//                }
//            })
//            danmakuView!!.enableDanmakuDrawingCache(true)
        }
    }

    private fun getIsStream(file: File): InputStream? {
        try {
            val instream: InputStream = FileInputStream(file)
            val inputreader = InputStreamReader(instream)
            val buffreader = BufferedReader(inputreader)
            var line: String?
            val sb1 = StringBuilder()
            sb1.append("<i>")
            //分行读取
            while (buffreader.readLine().also { line = it } != null) {
                sb1.append(line)
            }
            sb1.append("</i>")
            Log.e("3333333", sb1.toString())
            instream.close()
            return ByteArrayInputStream(sb1.toString().toByteArray())
        } catch (e: FileNotFoundException) {
            Log.d("TestFile", "The File doesn't not exist.")
        } catch (e: IOException) {
            Log.d("TestFile", e.message!!)
        }
        return null
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
        if (gsyVideoPlayer.danmakuView != null && !gsyVideoPlayer.danmakuView!!.isPrepared && gsyVideoPlayer.parser != null) {
            gsyVideoPlayer.danmakuView!!.prepare(gsyVideoPlayer.parser,
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
     * @param stream
     * @return
     */
    private fun createParser(stream: InputStream?): BaseDanmakuParser {
        if (stream == null) {
            return object : BaseDanmakuParser() {
                override fun parse(): Danmakus {
                    return Danmakus()
                }
            }
        }
        val loader = DanmakuLoaderFactory.create(DanmakuLoaderFactory.TAG_BILI)
        try {
            loader.load(stream)
        } catch (e: IllegalDataException) {
            e.printStackTrace()
        }
        val parser: BaseDanmakuParser = BiliDanmukuParser()
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

    private val parser: BaseDanmakuParser?
        get() {
            if (mParser == null) {
                if (mDumakuFile != null) {
                    mParser = createParser(getIsStream(mDumakuFile!!))
                }
            }
            return mParser
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
        danmaku.setTime(danmakuView!!.currentTime + 500)
        danmaku.textSize = 25f * (mParser!!.displayer.density - 0.6f)
        danmaku.textColor = Color.RED
        danmaku.textShadowColor = Color.WHITE
        danmaku.borderColor = Color.GREEN
        danmakuView!!.addDanmaku(danmaku)
    }
}
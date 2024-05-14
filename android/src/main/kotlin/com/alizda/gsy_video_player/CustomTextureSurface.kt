package com.alizda.gsy_video_player

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Matrix
import android.util.AttributeSet
import android.view.Surface
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import android.view.ViewGroup
import com.shuyu.gsyvideoplayer.listener.GSYVideoShotListener
import com.shuyu.gsyvideoplayer.listener.GSYVideoShotSaveListener
import com.shuyu.gsyvideoplayer.render.GSYRenderView
import com.shuyu.gsyvideoplayer.render.glrender.GSYVideoGLViewBaseRender
import com.shuyu.gsyvideoplayer.render.view.GSYVideoGLView.ShaderInterface
import com.shuyu.gsyvideoplayer.render.view.IGSYRenderView
import com.shuyu.gsyvideoplayer.render.view.listener.IGSYSurfaceListener
import com.shuyu.gsyvideoplayer.utils.MeasureHelper
import com.shuyu.gsyvideoplayer.utils.MeasureHelper.MeasureFormVideoParamsListener
import java.io.File


class CustomTextureSurface : SurfaceView, IGSYRenderView, SurfaceHolder.Callback2,
    MeasureFormVideoParamsListener {
    private var mIGSYSurfaceListener: IGSYSurfaceListener? = null
    private var measureHelper: MeasureHelper? = null
    private var mVideoParamsListener: MeasureFormVideoParamsListener? = null

    constructor(context: Context?) : super(context) {
        init()
    }

    constructor(context: Context?, attrs: AttributeSet?) : super(context, attrs) {
        init()
    }

    constructor(context: Context?, attrs: AttributeSet?, defStyleAttr: Int) : super(
        context,
        attrs,
        defStyleAttr
    ) {
        init()
    }

    private fun init() {
        measureHelper = MeasureHelper(this, this)
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        measureHelper!!.prepareMeasure(widthMeasureSpec, heightMeasureSpec, rotation.toInt())
        setMeasuredDimension(measureHelper!!.measuredWidth, measureHelper!!.measuredHeight)
    }

    override fun surfaceCreated(holder: SurfaceHolder) {
        if (mIGSYSurfaceListener != null) {
            mIGSYSurfaceListener!!.onSurfaceAvailable(holder.surface)
        }
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
        if (mIGSYSurfaceListener != null) {
            mIGSYSurfaceListener!!.onSurfaceSizeChanged(holder.surface, width, height)
        }
    }

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        //清空释放
        if (mIGSYSurfaceListener != null) {
            mIGSYSurfaceListener!!.onSurfaceDestroyed(holder.surface)
        }
    }

    override fun surfaceRedrawNeeded(holder: SurfaceHolder) {}
    override fun getIGSYSurfaceListener(): IGSYSurfaceListener {
        return mIGSYSurfaceListener!!
    }

    override fun setIGSYSurfaceListener(surfaceListener: IGSYSurfaceListener) {
        holder.addCallback(this)
        mIGSYSurfaceListener = surfaceListener
    }

    override fun getSizeH(): Int {
        return measureHelper!!.measuredHeight
    }

    override fun getSizeW(): Int {
        return measureHelper!!.measuredWidth
    }

    override fun taskShotPic(gsyVideoShotListener: GSYVideoShotListener, shotHigh: Boolean) {}
    override fun saveFrame(
        file: File,
        high: Boolean,
        gsyVideoShotSaveListener: GSYVideoShotSaveListener
    ) {
    }

    override fun getRenderView(): View {
        return this
    }

    override fun initCover(): Bitmap? {
        return null
    }

    override fun initCoverHigh(): Bitmap? {
        return null
    }

    override fun onRenderResume() {}
    override fun onRenderPause() {}
    override fun releaseRenderAll() {}
    override fun setRenderMode(mode: Int) {}
    override fun setRenderTransform(transform: Matrix?) {}
    override fun setGLRenderer(renderer: GSYVideoGLViewBaseRender) {}
    override fun setGLMVPMatrix(MVPMatrix: FloatArray) {}
    override fun setGLEffectFilter(effectFilter: ShaderInterface) {}
    override fun setVideoParamsListener(listener: MeasureFormVideoParamsListener) {
        mVideoParamsListener = listener
    }

    override fun getCurrentVideoWidth(): Int {
        return if (mVideoParamsListener != null) {
            mVideoParamsListener!!.currentVideoWidth
        } else 0
    }

    override fun getCurrentVideoHeight(): Int {
        return if (mVideoParamsListener != null) {
            mVideoParamsListener!!.currentVideoHeight
        } else 0
    }

    override fun getVideoSarNum(): Int {
        return if (mVideoParamsListener != null) {
            mVideoParamsListener!!.videoSarNum
        } else 0
    }

    override fun getVideoSarDen(): Int {
        return if (mVideoParamsListener != null) {
            mVideoParamsListener!!.videoSarDen
        } else 0
    }

    companion object {
        /**
         * 添加播放的view
         */
        fun addSurfaceView(
            context: Context?, textureViewContainer: ViewGroup, rotate: Int,
            gsySurfaceListener: IGSYSurfaceListener,
            videoParamsListener: MeasureFormVideoParamsListener,
            surface: Surface
        ): CustomTextureSurface {
            if (textureViewContainer.childCount > 0) {
                textureViewContainer.removeAllViews()
            }
            val showSurfaceView = CustomTextureSurface(context)
            showSurfaceView.setIGSYSurfaceListener(gsySurfaceListener)
            showSurfaceView.rotation = rotate.toFloat()
            showSurfaceView.setVideoParamsListener(videoParamsListener)
            GSYRenderView.addToParent(textureViewContainer, showSurfaceView)
            return showSurfaceView
        }
    }
}
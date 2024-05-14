package com.alizda.gsy_video_player

import android.content.Context
import android.view.Surface
import android.view.ViewGroup
import com.shuyu.gsyvideoplayer.render.GSYRenderView
import com.shuyu.gsyvideoplayer.render.glrender.GSYVideoGLViewBaseRender
import com.shuyu.gsyvideoplayer.render.view.GSYVideoGLView.ShaderInterface
import com.shuyu.gsyvideoplayer.render.view.listener.IGSYSurfaceListener
import com.shuyu.gsyvideoplayer.utils.MeasureHelper.MeasureFormVideoParamsListener

class CustomRenderView(private var surface: Surface) : GSYRenderView() {
    override fun addView(
        context: Context,
        textureViewContainer: ViewGroup,
        rotate: Int,
        gsySurfaceListener: IGSYSurfaceListener,
        videoParamsListener: MeasureFormVideoParamsListener,
        effect: ShaderInterface,
        transform: FloatArray,
        customRender: GSYVideoGLViewBaseRender,
        mode: Int
    ) {
        mShowView = CustomTextureSurface.addSurfaceView(
            context,
            textureViewContainer,
            rotate,
            gsySurfaceListener,
            videoParamsListener,
            surface
        )
    }
}
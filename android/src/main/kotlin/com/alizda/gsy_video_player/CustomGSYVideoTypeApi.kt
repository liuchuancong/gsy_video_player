package com.alizda.gsy_video_player

import com.alizda.gsy_video_player.GsyVideoPlayerPlugin.Companion.getParameter
import com.shuyu.gsyvideoplayer.utils.GSYVideoType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CustomGSYVideoTypeApi {

    fun isMediaCodec(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["isMediaCodec"] = GSYVideoType.isMediaCodec()
        result.success(reply)
    }

    fun getScreenScaleRatio(call: MethodCall, result: MethodChannel.Result) {
        val screenScaleRatio = (call.argument<Any>("screenScaleRatio") as Float?)!!.toFloat()
        GSYVideoType.setScreenScaleRatio(screenScaleRatio)
    }

    fun setScreenScaleRatio(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["screenScaleRatio"] = GSYVideoType.getScreenScaleRatio()
        result.success(reply)
    }

    fun isMediaCodecTexture(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["isMediaCodecTexture"] = GSYVideoType.isMediaCodecTexture()
        result.success(reply)
    }

    fun getRenderType(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["renderType"] = GSYVideoType.getRenderType()
        result.success(reply)
    }

    fun setRenderType(call: MethodCall, result: MethodChannel.Result) {
        val renderType = (call.argument<Any>("renderType") as Number?)!!.toInt()
        when (renderType) {
            0 -> GSYVideoType.setRenderType(GSYVideoType.TEXTURE)
            1 -> GSYVideoType.setRenderType(GSYVideoType.SUFRACE)
            2 -> GSYVideoType.setRenderType(GSYVideoType.GLSURFACE)
        }
        val reply: MutableMap<String, Any> = HashMap()
        reply["setRenderType"] = true
        result.success(reply)
    }

    fun setMediaCodec(call: MethodCall, result: MethodChannel.Result) {
        val enableCodec: Boolean = call.argument("enableCodec")!!
        if (enableCodec) {
            GSYVideoType.enableMediaCodec()
        } else {
            GSYVideoType.disableMediaCodec()
        }
    }

    fun setMediaCodecTexture(call: MethodCall, result: MethodChannel.Result) {
        val enableCodecTexture: Boolean = call.argument("enableCodecTexture")!!
        if (enableCodecTexture) {
            GSYVideoType.enableMediaCodecTexture()
        } else {
            GSYVideoType.disableMediaCodecTexture()
        }
    }
}
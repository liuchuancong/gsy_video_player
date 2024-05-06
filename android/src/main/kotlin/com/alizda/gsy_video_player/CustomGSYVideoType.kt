package com.alizda.gsy_video_player

import com.alizda.gsy_video_player.GsyVideoPlayerView.Companion.getParameter
import com.shuyu.aliplay.AliPlayerManager
import com.shuyu.gsyvideoplayer.player.IjkPlayerManager
import com.shuyu.gsyvideoplayer.player.PlayerFactory
import com.shuyu.gsyvideoplayer.player.SystemPlayerManager
import com.shuyu.gsyvideoplayer.utils.GSYVideoType
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import tv.danmaku.ijk.media.exo2.Exo2PlayerManager
import tv.danmaku.ijk.media.player.IjkMediaPlayer

class CustomGSYVideoType() {

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

    fun getShowType(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["type"] = GSYVideoType.getShowType()
        result.success(reply)
    }

    private fun setShowType(call: MethodCall, result: MethodChannel.Result) {
        val showTypeOptions = call.argument<Map<String, Any?>>("showTypeOptions")!!
        val showType = getParameter(showTypeOptions, "showType", 0);
        val screenScaleRatio = getParameter(showTypeOptions, "screenScaleRatio", 0.0F);
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

    fun getRenderType(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["renderType"] = GSYVideoType.getRenderType()
        result.success(reply)
    }

    private fun setRenderType(call: MethodCall, result: MethodChannel.Result) {
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
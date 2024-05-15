package com.alizda.gsy_video_player

import android.content.Context
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
class CustomOrientationUtilsApi(private var videoPlayer: CustomVideoPlayer, private val context: Context,) {
    private var orientationUtils: OrientationUtils = OrientationUtils(GsyVideoShared.activity, videoPlayer)

    fun resolveByClick(){
        orientationUtils.resolveByClick()
    }

    fun backToProtVideo(){
        orientationUtils.backToProtVideo()
    }

    fun isEnable(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["isEnable"] = orientationUtils.isEnable
        result.success(reply)
    }

    fun setEnable(call: MethodCall, result: MethodChannel.Result){
        val enable: Boolean = call.argument("enable")!!
        orientationUtils.isEnable = enable
    }
    fun getIsLand(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["isLand"] = orientationUtils.isLand
        result.success(reply)
    }

    fun setLand(call: MethodCall, result: MethodChannel.Result){
        val isLand: Int = call.argument("land")!!
        orientationUtils.isLand = isLand
    }




    fun getScreenType(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["screenType"] = orientationUtils.screenType
        result.success(reply)
    }
    fun setScreenType(call: MethodCall, result: MethodChannel.Result){
        val screenType: Int = call.argument("screenType")!!
        orientationUtils.screenType = screenType
    }

    fun isClick(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["isClick"] = orientationUtils.isClick
        result.success(reply)
    }
    fun setIsClick(call: MethodCall, result: MethodChannel.Result){
        val isClick: Boolean = call.argument("isClick")!!
        orientationUtils.isClick = isClick
    }

    fun isClickLand(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["isClickLand"] = orientationUtils.isClickLand
        result.success(reply)
    }
    fun setIsClickLand(call: MethodCall, result: MethodChannel.Result){
        val isClickLand: Boolean = call.argument("isClickLand")!!
        orientationUtils.isClickLand = isClickLand
    }

    fun isClickPort(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["isClickPort"] = orientationUtils.isClickPort
        result.success(reply)
    }
    fun setIslickPort(call: MethodCall, result: MethodChannel.Result){
        val isClickPort: Boolean = call.argument("isClickPort")!!
        orientationUtils.isClickPort = isClickPort
    }
    fun isPause(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["isPause"] = orientationUtils.isPause
        result.success(reply)
    }
    fun setIsPause(call: MethodCall, result: MethodChannel.Result){
        val isPause: Boolean = call.argument("isPause")!!
        orientationUtils.setIsPause(isPause)
    }


    fun isOnlyRotateLand(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["isOnlyRotateLand"] = orientationUtils.isOnlyRotateLand
        result.success(reply)
    }

    fun setIsOnlyRotateLand(call: MethodCall, result: MethodChannel.Result){
        val isOnlyRotateLand: Boolean = call.argument("isOnlyRotateLand")!!
        orientationUtils.isOnlyRotateLand = isOnlyRotateLand
    }
    fun isRotateWithSystem(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["rotateWithSystem"] = orientationUtils.isRotateWithSystem
        result.success(reply)
    }
    fun setRotateWithSystem(call: MethodCall, result: MethodChannel.Result){
        val rotateWithSystem: Boolean = call.argument("rotateWithSystem")!!
        orientationUtils.isRotateWithSystem = rotateWithSystem
    }

    fun releaseListener(){
        orientationUtils.releaseListener()
    }
}
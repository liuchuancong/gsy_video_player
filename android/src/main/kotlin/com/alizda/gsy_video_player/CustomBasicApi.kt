package com.alizda.gsy_video_player

import android.content.Context
import android.graphics.Point
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CustomBasicApi(private var videoPlayer: CustomVideoPlayer, private val context: Context) {

    fun startWindowFullscreen(call: MethodCall, result: MethodChannel.Result) {
        val startWindowFullscreenOptions = call.argument<Map<String, Any?>>("startWindowFullscreenOptions")!!
        val actionBar = GsyVideoPlayerView.getParameter(startWindowFullscreenOptions, "actionBar", true);
        val statusBar = GsyVideoPlayerView.getParameter(startWindowFullscreenOptions, "statusBar", true);
        videoPlayer.startWindowFullscreen(context, actionBar, statusBar)
    }

    fun showSmallVideo(call: MethodCall, result: MethodChannel.Result) {
        val showSmallVideoOptions = call.argument<Map<String, Any?>>("showSmallVideoOptions")!!
        val sizeObjects: MutableMap<String, Any> = HashMap()
        val size = GsyVideoPlayerView.getParameter(showSmallVideoOptions, "size", sizeObjects);
        val width = (size["width"] as Number).toInt();
        val height = (size["height"] as Number).toInt();
        val actionBar = GsyVideoPlayerView.getParameter(showSmallVideoOptions, "actionBar", true);
        val statusBar = GsyVideoPlayerView.getParameter(showSmallVideoOptions, "statusBar", true);
        videoPlayer.showSmallVideo(Point(width, height), actionBar, statusBar)
    }

    fun hideSmallVideo(call: MethodCall, result: MethodChannel.Result) {
        videoPlayer.hideSmallVideo()
    }

    fun isShowFullAnimation(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["isShowFullAnimation"] = videoPlayer.isShowFullAnimation
        result.success(reply)
    }

    fun setShowFullAnimation(call: MethodCall, result: MethodChannel.Result) {
        val isShowFullAnimation: Boolean = call.argument<Boolean>("isShowFullAnimation")!!
        videoPlayer.isShowFullAnimation = isShowFullAnimation
    }

    fun isRotateViewAuto(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["isRotateViewAuto"] = videoPlayer.isRotateViewAuto
        result.success(reply)
    }

    fun setRotateViewAuto(call: MethodCall, result: MethodChannel.Result) {
        val isRotateViewAuto: Boolean = call.argument<Boolean>("isRotateViewAuto")!!
        videoPlayer.isRotateViewAuto = isRotateViewAuto
    }


    fun isLockLand(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["isLockLand"] = videoPlayer.isLockLand
        result.success(reply)
    }

    fun setLockLand(call: MethodCall, result: MethodChannel.Result) {
        val isLockLand: Boolean = call.argument<Boolean>("isLockLand")!!
        videoPlayer.isLockLand = isLockLand
    }

    fun isRotateWithSystem(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["isRotateWithSystem"] = videoPlayer.isRotateWithSystem
        result.success(reply)
    }

    fun setRotateWithSystem(call: MethodCall, result: MethodChannel.Result) {
        val isRotateWithSystem: Boolean = call.argument<Boolean>("isRotateWithSystem")!!
        videoPlayer.isRotateWithSystem = isRotateWithSystem
    }

    fun initUIState() {
        videoPlayer.initUIState()
    }

    fun getEnlargeImageRes(call: MethodCall, result: MethodChannel.Result) {
        val enlargeImageRes = videoPlayer.enlargeImageRes
        val reply: MutableMap<String, Any> = HashMap()
        reply["enlargeImageRes"] = enlargeImageRes
        result.success(reply)
    }


    fun setEnlargeImageRes(call: MethodCall, result: MethodChannel.Result) {
        val enlargeImageRes = call.argument<Int>("enlargeImageRes")!!
        videoPlayer.enlargeImageRes = enlargeImageRes
    }

    fun getShrinkImageRes(call: MethodCall, result: MethodChannel.Result) {
        val shrinkImageRes = videoPlayer.shrinkImageRes
        val reply: MutableMap<String, Any> = HashMap()
        reply["shrinkImageRes"] = shrinkImageRes
        result.success(reply)
    }

    fun setShrinkImageRes(call: MethodCall, result: MethodChannel.Result) {
        val shrinkImageRes = call.argument<Int>("shrinkImageRes")!!
        videoPlayer.shrinkImageRes = shrinkImageRes
    }

    fun setIsTouchWigetFull(call: MethodCall, result: MethodChannel.Result) {
        val isTouchWigetFull = call.argument<Boolean>("isTouchWigetFull")!!
        videoPlayer.setIsTouchWigetFull(isTouchWigetFull)
    }

    fun getIsTouchWigetFull(call: MethodCall, result: MethodChannel.Result) {
        val isTouchWigetFull = videoPlayer.isTouchWigetFull
        val reply: MutableMap<String, Any> = HashMap()
        reply["isTouchWigetFull"] = isTouchWigetFull
        result.success(reply)
    }

    fun setThumbPlay(call: MethodCall, result: MethodChannel.Result) {
        val thumbPlay = call.argument<Boolean>("thumbPlay")!!
        videoPlayer.setThumbPlay(thumbPlay)
    }

    fun isHideKeyBoard(call: MethodCall, result: MethodChannel.Result) {
        val isHideKeyBoard = videoPlayer.isHideKey
        val reply: MutableMap<String, Any> = HashMap()
        reply["isHideKeyBoard"] = isHideKeyBoard
        result.success(reply)
    }

    fun setHideKeyBoard(call: MethodCall, result: MethodChannel.Result) {
        val isHideKeyBoard = call.argument<Boolean>("isHideKeyBoard")!!
        videoPlayer.isHideKey = isHideKeyBoard
    }

    fun isNeedShowWifiTip(call: MethodCall, result: MethodChannel.Result) {
        val isNeedShowWifiTip = videoPlayer.isNeedShowWifiTip
        val reply: MutableMap<String, Any> = HashMap()
        reply["isNeedShowWifiTip"] = isNeedShowWifiTip
        result.success(reply)
    }

    fun setNeedShowWifiTip(call: MethodCall, result: MethodChannel.Result) {
        val isNeedShowWifiTip = call.argument<Boolean>("isNeedShowWifiTip")!!
        videoPlayer.isNeedShowWifiTip = isNeedShowWifiTip
    }

    fun isTouchWiget(call: MethodCall, result: MethodChannel.Result) {
        val isTouchWiget = videoPlayer.isTouchWiget
        val reply: MutableMap<String, Any> = HashMap()
        reply["isTouchWiget"] = isTouchWiget
        result.success(reply)
    }

    fun setTouchWiget(call: MethodCall, result: MethodChannel.Result) {
        val isTouchWiget = call.argument<Boolean>("isTouchWiget")!!
        videoPlayer.setIsTouchWiget(isTouchWiget)
    }

    fun setSeekRatio(call: MethodCall, result: MethodChannel.Result) {
        val seekRatio = (call.argument<Any>("seekRatio") as Number).toFloat()
        videoPlayer.seekRatio = seekRatio
    }

    fun getSeekRatio(call: MethodCall, result: MethodChannel.Result) {
        val seekRatio = videoPlayer.seekRatio
        val reply: MutableMap<String, Any> = HashMap()
        reply["seekRatio"] = seekRatio
        result.success(reply)
    }

    fun isNeedLockFull(call: MethodCall, result: MethodChannel.Result) {
        val isNeedLockFull = videoPlayer.isNeedLockFull
        val reply: MutableMap<String, Any> = HashMap()
        reply["isNeedLockFull"] = isNeedLockFull
        result.success(reply)
    }

    fun setNeedLockFull(call: MethodCall, result: MethodChannel.Result) {
        val isNeedLockFull = call.argument<Boolean>("isNeedLockFull")!!
        videoPlayer.isNeedLockFull = isNeedLockFull
    }

    fun setDismissControlTime(call: MethodCall, result: MethodChannel.Result) {
        val dismissControlTime = (call.argument<Any>("dismissControlTime") as Number).toInt()
        videoPlayer.dismissControlTime = dismissControlTime
    }

    fun getDismissControlTime(call: MethodCall, result: MethodChannel.Result) {
        val dismissControlTime = videoPlayer.dismissControlTime
        val reply: MutableMap<String, Any> = HashMap()
        reply["dismissControlTime"] = dismissControlTime
        result.success(reply)
    }

    fun getCurrentState(call: MethodCall, result: MethodChannel.Result) {
        val currentState = videoPlayer.currentState
        val reply: MutableMap<String, Any> = HashMap()
        reply["currentState"] = currentState
        result.success(reply)
    }


    fun setPlayTag(call: MethodCall, result: MethodChannel.Result) {
        val playTag = call.argument<String>("playTag")!!
        videoPlayer.playTag = playTag
    }

    fun getPlayTag(call: MethodCall, result: MethodChannel.Result) {
        val playTag = videoPlayer.playTag
        val reply: MutableMap<String, Any> = HashMap()
        reply["playTag"] = playTag
        result.success(reply)
    }

    fun setPlayPosition(call: MethodCall, result: MethodChannel.Result) {
        val playPosition = (call.argument<Any>("playPosition") as Number).toInt()
        videoPlayer.playPosition = playPosition
    }

    fun getPlayPosition(call: MethodCall, result: MethodChannel.Result) {
        val playPosition = videoPlayer.playPosition

        val reply: MutableMap<String, Any> = HashMap()
        reply["playPosition"] = playPosition
        result.success(reply)

    }

    fun getNetSpeed(call: MethodCall, result: MethodChannel.Result) {
        val netSpeed = videoPlayer.netSpeed
        val reply: MutableMap<String, Any> = HashMap()
        reply["netSpeed"] = netSpeed
        result.success(reply)
    }

    fun getNetSpeedText(call: MethodCall, result: MethodChannel.Result) {
        val netSpeedText = videoPlayer.netSpeedText
        val reply: MutableMap<String, Any> = HashMap()
        reply["netSpeedText"] = netSpeedText
        result.success(reply)

    }

    fun getSeekOnStart(call: MethodCall, result: MethodChannel.Result) {
        val seekOnStart = videoPlayer.seekOnStart
        val reply: MutableMap<String, Any> = HashMap()
        reply["seekOnStart"] = seekOnStart
        result.success(reply)
    }

    fun setSeekOnStart(call: MethodCall, result: MethodChannel.Result) {
        val seekOnStart = (call.argument<Any>("seekOnStart") as Number).toInt()
        videoPlayer.seekOnStart = seekOnStart.toLong()
    }

    fun getBuffterPoint(call: MethodCall, result: MethodChannel.Result) {
        val buffterPoint = videoPlayer.buffterPoint
        val reply: MutableMap<String, Any> = HashMap()
        reply["buffterPoint"] = buffterPoint
        result.success(reply)

    }

    fun isIfCurrentIsFullscreen(call: MethodCall, result: MethodChannel.Result) {
        val isIfCurrentIsFullscreen = videoPlayer.isIfCurrentIsFullscreen
        val reply: MutableMap<String, Any> = HashMap()
        reply["isIfCurrentIsFullscreen"] = isIfCurrentIsFullscreen
        result.success(reply)
    }

    fun setIfCurrentIsFullscreen(call: MethodCall, result: MethodChannel.Result) {
        val isIfCurrentIsFullscreen = call.argument<Boolean>("isIfCurrentIsFullscreen")!!
        videoPlayer.isIfCurrentIsFullscreen = isIfCurrentIsFullscreen
    }

    fun isLooping(call: MethodCall, result: MethodChannel.Result) {
        val isLooping = videoPlayer.isLooping
        val reply: MutableMap<String, Any> = HashMap()
        reply["isLooping"] = isLooping
        result.success(reply)
    }

    fun setLooping(call: MethodCall, result: MethodChannel.Result) {
        val isLooping = call.argument<Boolean>("isLooping")!!
        videoPlayer.isLooping = isLooping
    }

    fun getSpeed(call: MethodCall, result: MethodChannel.Result) {
        val speed = videoPlayer.speed
        val reply: MutableMap<String, Any> = HashMap()
        reply["speed"] = speed
        result.success(reply)
    }

    fun setSpeed(call: MethodCall, result: MethodChannel.Result) {
        val speedOptions = call.argument<Map<String, Any?>>("speedOptions")!!
        val speed = GsyVideoPlayerView.getParameter(speedOptions, "speed", 1.0F);
        val soundTouch = GsyVideoPlayerView.getParameter(speedOptions, "soundTouch", true);
        videoPlayer.setSpeed(speed, soundTouch)
    }

    fun setSpeedPlaying(call: MethodCall, result: MethodChannel.Result) {
        val speedOptions = call.argument<Map<String, Any?>>("speedPlayingOptions")!!
        val speed = GsyVideoPlayerView.getParameter(speedOptions, "speed", 1.0F);
        val soundTouch = GsyVideoPlayerView.getParameter(speedOptions, "soundTouch", true);
        videoPlayer.setSpeedPlaying(speed, soundTouch)
    }

    fun isShowPauseCover(call: MethodCall, result: MethodChannel.Result) {
        val isShowPauseCover = videoPlayer.isShowPauseCover
        val reply: MutableMap<String, Any> = HashMap()
        reply["isShowPauseCover"] = isShowPauseCover
        result.success(reply)
    }

    fun setShowPauseCover(call: MethodCall, result: MethodChannel.Result) {
        val isShowPauseCover = call.argument<Boolean>("isShowPauseCover")!!
        videoPlayer.isShowPauseCover = isShowPauseCover
    }

    fun seekTo(call: MethodCall, result: MethodChannel.Result) {
        val position = (call.argument<Any>("position") as Number).toLong()
        videoPlayer.seekTo(position)
    }

    fun setMatrixGL(call: MethodCall, result: MethodChannel.Result) {
        val matrix = call.argument<List<Any>>("matrix")!!
        val matrixArray: FloatArray = FloatArray(matrix.size);
        for (i in matrix.indices) {
            matrixArray[i] = (matrix[i] as Number).toFloat()
        }
        videoPlayer.setMatrixGL(matrixArray)
    }

    fun releaseWhenLossAudio(call: MethodCall, result: MethodChannel.Result) {
        val releaseWhenLossAudio = call.argument<Boolean>("releaseWhenLossAudio")!!
        videoPlayer.isReleaseWhenLossAudio = releaseWhenLossAudio
    }

    fun setReleaseWhenLossAudio(call: MethodCall, result: MethodChannel.Result) {
        val releaseWhenLossAudio = call.argument<Boolean>("releaseWhenLossAudio")!!
        videoPlayer.isReleaseWhenLossAudio = releaseWhenLossAudio
    }

    fun setAutoFullWithSize(call: MethodCall, result: MethodChannel.Result) {
        val autoFullWithSize = call.argument<Boolean>("autoFullWithSize")!!
        videoPlayer.isAutoFullWithSize = autoFullWithSize
    }

    fun getAutoFullWithSize(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["autoFullWithSize"] = videoPlayer.isAutoFullWithSize
        result.success(reply)
    }
}
package com.alizda.gsy_video_player

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CustomMethodCallApi(
        private val videoPlayer: GsyVideoPlayer,
        val context: Context,
        private var customGSYVideoManagerApi: CustomGSYVideoManagerApi,
        private var customBasicApi: CustomBasicApi,
        private var gSYVideoPlayer: CustomGSYVideoPlayerApi,
        private var customGSYVideoTypeApi: CustomGSYVideoTypeApi,
        private var customOrientationUtilsApi: CustomOrientationUtilsApi,
        private var  eventSink: QueuingEventSink
) {
    fun handleMethod(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            // --------------------- CustomGSYVideoOptionBuilder  start ----------------------------

            "startPlayLogic" -> {
                gSYVideoPlayer.startPlayLogic(call, result)
            }

            "setVideoOptionBuilder" -> {
                videoPlayer.gsyVideoOptionBuilder =  CustomGSYVideoOptionBuilderApi().setVideoConfig(videoPlayer,call, result)
            }
            "setUp" -> {
                gSYVideoPlayer.setUp(call, result)
            }

            "pause" -> {
                gSYVideoPlayer.onVideoPause()
            }

            "resume" -> {
                gSYVideoPlayer.onVideoResume()
            }

            "clearCurrentCache" -> {
                gSYVideoPlayer.clearCurrentCache()
            }

            "getCurrentPositionWhenPlaying" -> {
                gSYVideoPlayer.getCurrentPositionWhenPlaying(call, result)
            }

            "releaseAllVideos" -> {
                gSYVideoPlayer.releaseAllVideos()
            }

            "getCurrentState" -> {
                gSYVideoPlayer.getCurrentState(call, result)
            }

            "setPlayTag" -> {
                gSYVideoPlayer.setPlayTag(call, result)
            }

            "setPlayPosition" -> {
                gSYVideoPlayer.setPlayPosition(call, result)
            }

            "getNetSpeed" -> {
                gSYVideoPlayer.getNetSpeed(call, result)
            }

            "getNetSpeedText" -> {
                gSYVideoPlayer.getNetSpeedText(call, result)
            }

            "setSeekOnStart" -> {
                gSYVideoPlayer.setSeekOnStart(call, result)
            }

            "getBuffterPoint" -> {
                gSYVideoPlayer.getBuffterPoint(call, result)
            }

            "setPlayerFactory" -> {
                customGSYVideoManagerApi.setCurrentPlayer(call, result)
            }

            "getPlayFactory" -> {
                customGSYVideoManagerApi.getPlayManager(call, result)
            }

            "setExoCacheManager" -> {
                customGSYVideoManagerApi.setExoCacheManager()
            }

            "setProxyCacheManager" -> {
                customGSYVideoManagerApi.setProxyCacheManager()
            }

            "clearAllDefaultCache" -> {
                customGSYVideoManagerApi.clearAllDefaultCache()
            }

            "clearDefaultCache" -> {
                customGSYVideoManagerApi.clearDefaultCache(call, result)
            }

            "releaseMediaPlayer" -> {
                customGSYVideoManagerApi.releaseMediaPlayer()
            }

            "getPlayTag" -> {
                customGSYVideoManagerApi.getPlayTag(call, result)
            }

            "getPlayPosition" -> {
                customGSYVideoManagerApi.getPlayPosition(call, result)
            }

            "getOptionModelList" -> {
                customGSYVideoManagerApi.getOptionModelList(call, result)
            }

            "setOptionModelList" -> {
                customGSYVideoManagerApi.setOptionModelList(call, result)
            }

            "isNeedMute" -> {
                customGSYVideoManagerApi.isNeedMute(call, result)
            }

            "setNeedMute" -> {
                customGSYVideoManagerApi.setNeedMute(call, result)
            }

            "getTimeOut" -> {
                customGSYVideoManagerApi.getTimeOut(call, result)
            }

            "isNeedTimeOutOther" -> {
                customGSYVideoManagerApi.isNeedTimeOutOther(call, result)
            }

            "setTimeOut" -> {
                customGSYVideoManagerApi.setTimeOut(call, result)
            }

            "setLogLevel" -> {
                customGSYVideoManagerApi.setLogLevel(call, result)
            }
            "setVolume" ->{
                customGSYVideoManagerApi.setVolume(call, result)
            }

            "isMediaCodec" -> {
                customGSYVideoTypeApi.isMediaCodec(call, result)
            }

            "getScreenScaleRatio" -> {
                customGSYVideoTypeApi.getScreenScaleRatio(call, result)
            }

            "setScreenScaleRatio" -> {
                customGSYVideoTypeApi.setScreenScaleRatio(call, result)
            }

            "isMediaCodecTexture" -> {
                customGSYVideoTypeApi.isMediaCodecTexture(call, result)
            }

            "getRenderType" -> {
                customGSYVideoTypeApi.getRenderType(call, result)
            }

            "setRenderType" -> {
                customGSYVideoTypeApi.setRenderType(call, result)
            }

            "setMediaCodec" -> {
                customGSYVideoTypeApi.setMediaCodec(call, result)
            }

            "setMediaCodecTexture" -> {
                customGSYVideoTypeApi.setMediaCodecTexture(call, result)
            }

            "resolveByClick" ->{
                customOrientationUtilsApi.resolveByClick()
            }

            "backToProtVideo" ->{
                customOrientationUtilsApi.backToProtVideo()
            }
            "isOrientationRotateEnable" ->{
                customOrientationUtilsApi.isEnable(call, result)
            }
            "setOrientationRotateEnable" ->{
                customOrientationUtilsApi.setEnable(call, result)
            }
            "getOrientationRotateIsLand" ->{
                customOrientationUtilsApi.getIsLand(call, result)
            }
            "setOrientationRotateLand" ->{
                customOrientationUtilsApi.setLand(call, result)
            }
            "getOrientationRotateScreenType" ->{
                customOrientationUtilsApi.getScreenType(call, result)
            }
            "setOrientationRotateScreenType" ->{
                customOrientationUtilsApi.setScreenType(call, result)
            }
            "isOrientationRotateClick" ->{
                customOrientationUtilsApi.isClick(call, result)
            }
            "setOrientationRotateIsClick" ->{
                customOrientationUtilsApi.setIsClick(call, result)
            }
            "isOrientationRotateClickLand" ->{
                customOrientationUtilsApi.isClickLand(call, result)
            }
            "setOrientationRotateIsClickLand" ->{
                customOrientationUtilsApi.setIsClickLand(call, result)
            }
            "isOrientationRotateClickPort" ->{
                customOrientationUtilsApi.isClickPort(call, result)
            }
            "setOrientationRotateIslickPort" ->{
                customOrientationUtilsApi.setIslickPort(call, result)
            }
            "isOrientationRotatePause" ->{
                customOrientationUtilsApi.isPause(call, result)
            }
            "setOrientationRotateIsPause" ->{
                customOrientationUtilsApi.setIsPause(call, result)
            }
            "isOrientationRotateOnlyRotateLand" ->{
                customOrientationUtilsApi.isOnlyRotateLand(call, result)
            }
            "setOrientationRotateIsOnlyRotateLand" ->{
                customOrientationUtilsApi.setIsOnlyRotateLand(call, result)
            }
            "isOrientationRotateWithSystem" ->{
                customOrientationUtilsApi.isRotateWithSystem(call, result)
            }
            "setOrientationRotateWithSystem" ->{
                customOrientationUtilsApi.setRotateWithSystem(call, result)
            }
            "releaseOrientation" ->{
                customOrientationUtilsApi.releaseListener()
            }

            "getSeekOnStart" -> {
                customBasicApi.getSeekOnStart(call, result)
            }

            "isLooping" -> {
                customBasicApi.isLooping(call, result)
            }

            "setLooping" -> {
                customBasicApi.setLooping(call, result)
            }

            "getSpeed" -> {
                customBasicApi.getSpeed(call, result)
            }

            "setSpeed" -> {
                customBasicApi.setSpeed(call, result)
            }

            "setSpeedPlaying" -> {
                customBasicApi.setSpeedPlaying(call, result)
            }

            "seekTo" -> {
                customBasicApi.seekTo(call, result)
            }

            "setMatrixGL" -> {
                customBasicApi.setMatrixGL(call, result)
            }

            "releaseWhenLossAudio" -> {
                customBasicApi.releaseWhenLossAudio(call, result)
            }

            "setReleaseWhenLossAudio" -> {
                customBasicApi.setReleaseWhenLossAudio(call, result)
            }
        }
    }
}
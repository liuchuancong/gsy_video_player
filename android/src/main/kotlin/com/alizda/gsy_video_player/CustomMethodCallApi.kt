package com.alizda.gsy_video_player

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CustomMethodCallApi(
        private val videoPlayer: GsyVideoPlayer,
        val context: Context,
        private var customGSYVideoManagerApi: CustomGSYVideoManagerApi,
        private var customBasicApi: CustomBasicApi,
        private var gSYVideoPlayer: CustomGSYVideoPlayerApi,
        private var customGSYVideoTypeApi: CustomGSYVideoTypeApi,
        private var customOrientationUtilsApi: CustomOrientationUtilsApi
) {

    fun handleMethod(call: MethodCall, result: MethodChannel.Result,view: GsyVideoPlayerView) {
        when (call.method) {
            // --------------------- Global  start ----------------------------
            "create" -> {
                gSYVideoPlayer.create(call, result)
            }
            "dispose"->{
                gSYVideoPlayer.dispose()
            }
            // --------------------- CustomGSYVideoOptionBuilder  start ----------------------------
            "setVideoOptionBuilder" -> {
                videoPlayer.gsyVideoOptionBuilder =  CustomGSYVideoOptionBuilderApi().setVideoConfig(videoPlayer,call, result)
            }
            // --------------------- GSYVideoPlayer  start --------
            "getLayoutId" -> {
                gSYVideoPlayer.getLayoutId(call, result)
            }

            "startPlayLogic" -> {
                gSYVideoPlayer.startPlayLogic(call, result)
            }

            "setUp" -> {
                gSYVideoPlayer.setUp(call, result)
            }

            "onVideoPause" -> {
                gSYVideoPlayer.onVideoPause()
            }

            "onVideoResume" -> {
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

            "backFromWindowFull" -> {
                gSYVideoPlayer.backFromWindowFull(call, result)
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
            // --------------------- CustomGSYVideoManagerApi start ----------------------------
            "setCurrentPlayer" -> {
                customGSYVideoManagerApi.setCurrentPlayer(call, result)
            }

            "getPlayManager" -> {
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

            "onPause" -> {
                customGSYVideoManagerApi.onPause()
            }

            "onResume" -> {
                customGSYVideoManagerApi.onResume()
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
            // --------------------- CustomGSYVideoType  start --------
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

            "getShowType" -> {
                customGSYVideoTypeApi.getShowType(call, result)
            }

            "setShowType" -> {
                customGSYVideoTypeApi.setShowType(call, result)
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
            // --------------------- CustomBasicApi [start] ----------------------------
            "startWindowFullscreen" -> {
                customBasicApi.startWindowFullscreen(call, result)
            }

            "showSmallVideo" -> {
                customBasicApi.showSmallVideo(call, result)
            }

            "hideSmallVideo" -> {
                customBasicApi.hideSmallVideo(call, result)
            }

            "isShowFullAnimation" -> {
                customBasicApi.isShowFullAnimation(call, result)
            }

            "setShowFullAnimation" -> {
                customBasicApi.setShowFullAnimation(call, result)
            }

            "isRotateViewAuto" -> {
                customBasicApi.isRotateViewAuto(call, result)
            }

            "setRotateViewAuto" -> {
                customBasicApi.setRotateViewAuto(call, result)
            }

            "isLockLand" -> {
                customBasicApi.isLockLand(call, result)
            }

            "setLockLand" -> {
                customBasicApi.setLockLand(call, result)
            }

            "isRotateWithSystem" -> {
                customBasicApi.isRotateWithSystem(call, result)
            }

            "setRotateWithSystem" -> {
                customBasicApi.setRotateWithSystem(call, result)
            }

            "initUIState" -> {
                customBasicApi.initUIState()
            }

            "getEnlargeImageRes" -> {
                customBasicApi.getEnlargeImageRes(call, result)
            }

            "setEnlargeImageRes" -> {
                customBasicApi.setEnlargeImageRes(call, result)
            }

            "getShrinkImageRes" -> {
                customBasicApi.getShrinkImageRes(call, result)
            }

            "setShrinkImageRes" -> {
                customBasicApi.setShrinkImageRes(call, result)
            }

            "setIsTouchWigetFull" -> {
                customBasicApi.setIsTouchWigetFull(call, result)
            }

            "getIsTouchWigetFull" -> {
                customBasicApi.getIsTouchWigetFull(call, result)
            }

            "setThumbPlay" -> {
                customBasicApi.setThumbPlay(call, result)
            }

            "isHideKeyBoard" -> {
                customBasicApi.isHideKeyBoard(call, result)
            }

            "setHideKeyBoard" -> {
                customBasicApi.setHideKeyBoard(call, result)
            }

            "isNeedShowWifiTip" -> {
                customBasicApi.isNeedShowWifiTip(call, result)
            }

            "setNeedShowWifiTip" -> {
                customBasicApi.setNeedShowWifiTip(call, result)
            }

            "isTouchWiget" -> {
                customBasicApi.isTouchWiget(call, result)
            }

            "setTouchWiget" -> {
                customBasicApi.setTouchWiget(call, result)
            }

            "setSeekRatio" -> {
                customBasicApi.setSeekRatio(call, result)
            }

            "getSeekRatio" -> {
                customBasicApi.getSeekRatio(call, result)
            }

            "isNeedLockFull" -> {
                customBasicApi.isNeedLockFull(call, result)
            }

            "setNeedLockFull" -> {
                customBasicApi.setNeedLockFull(call, result)
            }

            "setDismissControlTime" -> {
                customBasicApi.setDismissControlTime(call, result)
            }

            "getDismissControlTime" ->{
                customBasicApi.getDismissControlTime(call, result)
            }

            "getSeekOnStart" -> {
                customBasicApi.getSeekOnStart(call, result)
            }

            "isIfCurrentIsFullscreen" -> {
                customBasicApi.isIfCurrentIsFullscreen(call, result)
            }

            "setIfCurrentIsFullscreen" -> {
                customBasicApi.setIfCurrentIsFullscreen(call, result)
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

            "isShowPauseCover" -> {
                customBasicApi.isShowPauseCover(call, result)
            }

            "setShowPauseCover" -> {
                customBasicApi.setShowPauseCover(call, result)
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

            "setAutoFullWithSize" -> {
                customBasicApi.setAutoFullWithSize(call, result)
            }

            "getAutoFullWithSize" -> {
                customBasicApi.getAutoFullWithSize(call, result)
            }

            "initDanmaku" -> {
                videoPlayer.getCurrentPlayer()!!.initDanmaku(call, result)
            }

            "showDanmaku" -> {
                videoPlayer.getCurrentPlayer()!!.showDanmaku(call, result)
            }

            "getDanmakuShow" -> {
                videoPlayer.getCurrentPlayer()!!.getDanmakuShow(call, result)
            }

            "hideDanmaku" -> {
                videoPlayer.getCurrentPlayer()!!.hideDanmaku(call, result)
            }

            "setDanmakuStyle" -> {
                videoPlayer.getCurrentPlayer()!!.setDanmakuStyle(call, result)
            }

            "setDanmakuBold" -> {
                videoPlayer.getCurrentPlayer()!!.setDanmakuBold(call, result)
            }

            "setScrollSpeedFactor" -> {
                videoPlayer.getCurrentPlayer()!!.setScrollSpeedFactor(call, result)
            }

            "setDuplicateMergingEnabled" -> {
                videoPlayer.getCurrentPlayer()!!.setDuplicateMergingEnabled(call, result)
            }

            "setMaximumLines" -> {
                videoPlayer.getCurrentPlayer()!!.setMaximumLines(call, result)
            }

            "preventOverlapping" -> {
                videoPlayer.getCurrentPlayer()!!.preventOverlapping(call, result)
            }

            "setMarginTop" -> {
                videoPlayer.getCurrentPlayer()!!.setMarginTop(call, result)
            }

            "setDanmakuTransparency" -> {
                videoPlayer.getCurrentPlayer()!!.setDanmakuTransparency(call, result)
            }

            "setDanmakuMargin" -> {
                videoPlayer.getCurrentPlayer()!!.setDanmakuMargin(call, result)
            }

            "setScaleTextSize" -> {
                videoPlayer.getCurrentPlayer()!!.setScaleTextSize(call, result)
            }

            "setMaximumVisibleSizeInScreen" -> {
                videoPlayer.getCurrentPlayer()!!.setMaximumVisibleSizeInScreen(call, result)
            }

            "addDanmaku" -> {
                videoPlayer.getCurrentPlayer()!!.addDanmaku(call, result)
            }
            "startDanmaku" -> {
                videoPlayer.getCurrentPlayer()!!.startDanmaku(call, result)
            }

            "getDannakuStatus" -> {
                videoPlayer.getCurrentPlayer()!!.getDannakuStatus(call, result)
            }

            "resumeDanmaku" -> {
                videoPlayer.getCurrentPlayer()!!.resumeDanmaku(call, result)
            }

            "pauseDanmaku" -> {
                videoPlayer.getCurrentPlayer()!!.pauseDanmaku(call, result)
            }

            "stopDanmaku" -> {
                videoPlayer.getCurrentPlayer()!!.stopDanmaku(call, result)
            }

            "seekToDanmaku" -> {
                videoPlayer.getCurrentPlayer()!!.seekToDanmaku(call, result)
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
            "releaseOrientationListener" ->{
                customOrientationUtilsApi.releaseListener()
            }
        }
    }
}
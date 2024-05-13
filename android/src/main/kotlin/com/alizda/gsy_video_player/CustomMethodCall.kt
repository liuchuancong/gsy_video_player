package com.alizda.gsy_video_player

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CustomMethodCall(
        private val videoPlayer: CustomVideoPlayer,
        val context: Context,
        private val id: Int,
        private var customGSYVideoManagerApi: CustomGSYVideoManagerApi,
        private var customBasicApi: CustomBasicApi,
        private var gSYVideoPlayer: GSYVideoPlayer,
        private var customGSYVideoType: CustomGSYVideoType,
        private var customOrientationUtils: CustomOrientationUtils
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
                view.gsyVideoOptionBuilder =  CustomGSYVideoOptionBuilder(view.getCurVideoPlayer()).setVideoConfig(call, result)
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
                customGSYVideoType.isMediaCodec(call, result)
            }

            "getScreenScaleRatio" -> {
                customGSYVideoType.getScreenScaleRatio(call, result)
            }

            "setScreenScaleRatio" -> {
                customGSYVideoType.setScreenScaleRatio(call, result)
            }

            "isMediaCodecTexture" -> {
                customGSYVideoType.isMediaCodecTexture(call, result)
            }

            "getShowType" -> {
                customGSYVideoType.getShowType(call, result)
            }

            "setShowType" -> {
                customGSYVideoType.setShowType(call, result)
            }

            "getRenderType" -> {
                customGSYVideoType.getRenderType(call, result)
            }

            "setRenderType" -> {
                customGSYVideoType.setRenderType(call, result)
            }

            "setMediaCodec" -> {
                customGSYVideoType.setMediaCodec(call, result)
            }

            "setMediaCodecTexture" -> {
                customGSYVideoType.setMediaCodecTexture(call, result)
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
                videoPlayer.initDanmaku(call, result)
            }

            "showDanmaku" -> {
                videoPlayer.showDanmaku(call, result)
            }

            "getDanmakuShow" -> {
                videoPlayer.getDanmakuShow(call, result)
            }

            "hideDanmaku" -> {
                videoPlayer.hideDanmaku(call, result)
            }

            "setDanmakuStyle" -> {
                videoPlayer.setDanmakuStyle(call, result)
            }

            "setDanmakuBold" -> {
                videoPlayer.setDanmakuBold(call, result)
            }

            "setScrollSpeedFactor" -> {
                videoPlayer.setScrollSpeedFactor(call, result)
            }

            "setDuplicateMergingEnabled" -> {
                videoPlayer.setDuplicateMergingEnabled(call, result)
            }

            "setMaximumLines" -> {
                videoPlayer.setMaximumLines(call, result)
            }

            "preventOverlapping" -> {
                videoPlayer.preventOverlapping(call, result)
            }

            "setMarginTop" -> {
                videoPlayer.setMarginTop(call, result)
            }

            "setDanmakuTransparency" -> {
                videoPlayer.setDanmakuTransparency(call, result)
            }

            "setDanmakuMargin" -> {
                videoPlayer.setDanmakuMargin(call, result)
            }

            "setScaleTextSize" -> {
                videoPlayer.setScaleTextSize(call, result)
            }

            "setMaximumVisibleSizeInScreen" -> {
                videoPlayer.setMaximumVisibleSizeInScreen(call, result)
            }

            "addDanmaku" -> {
                videoPlayer.addDanmaku(call, result)
            }
            "startDanmaku" -> {
                videoPlayer.startDanmaku(call, result)
            }

            "getDannakuStatus" -> {
                videoPlayer.getDannakuStatus(call, result)
            }

            "resumeDanmaku" -> {
                videoPlayer.resumeDanmaku(call, result)
            }

            "pauseDanmaku" -> {
                videoPlayer.pauseDanmaku(call, result)
            }

            "stopDanmaku" -> {
                videoPlayer.stopDanmaku(call, result)
            }

            "seekToDanmaku" -> {
                videoPlayer.seekToDanmaku(call, result)
            }
            "resolveByClick" ->{
                customOrientationUtils.resolveByClick()
            }
            "backToProtVideo" ->{
                customOrientationUtils.backToProtVideo()
            }
            "isOrientationRotateEnable" ->{
                customOrientationUtils.isEnable(call, result)
            }
            "setOrientationRotateEnable" ->{
                customOrientationUtils.setEnable(call, result)
            }
            "getOrientationRotateIsLand" ->{
                customOrientationUtils.getIsLand(call, result)
            }
            "setOrientationRotateLand" ->{
                customOrientationUtils.setLand(call, result)
            }
            "getOrientationRotateScreenType" ->{
                customOrientationUtils.getScreenType(call, result)
            }
            "setOrientationRotateScreenType" ->{
                customOrientationUtils.setScreenType(call, result)
            }
            "isOrientationRotateClick" ->{
                customOrientationUtils.isClick(call, result)
            }
            "setOrientationRotateIsClick" ->{
                customOrientationUtils.setIsClick(call, result)
            }
            "isOrientationRotateClickLand" ->{
                customOrientationUtils.isClickLand(call, result)
            }
            "setOrientationRotateIsClickLand" ->{
                customOrientationUtils.setIsClickLand(call, result)
            }
            "isOrientationRotateClickPort" ->{
                customOrientationUtils.isClickPort(call, result)
            }
            "setOrientationRotateIslickPort" ->{
                customOrientationUtils.setIslickPort(call, result)
            }
            "isOrientationRotatePause" ->{
                customOrientationUtils.isPause(call, result)
            }
            "setOrientationRotateIsPause" ->{
                customOrientationUtils.setIsPause(call, result)
            }
            "isOrientationRotateOnlyRotateLand" ->{
                customOrientationUtils.isOnlyRotateLand(call, result)
            }
            "setOrientationRotateIsOnlyRotateLand" ->{
                customOrientationUtils.setIsOnlyRotateLand(call, result)
            }
            "isOrientationRotateWithSystem" ->{
                customOrientationUtils.isRotateWithSystem(call, result)
            }
            "setOrientationRotateWithSystem" ->{
                customOrientationUtils.setRotateWithSystem(call, result)
            }
            "releaseOrientationListener" ->{
                customOrientationUtils.releaseListener()
            }
        }
    }
}
package com.alizda.gsy_video_player

import android.content.res.AssetManager
import android.util.Log
import android.view.View
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class CustomGSYVideoOptionBuilder(private var videoPlayer: CustomVideoPlayer): GSYVideoOptionBuilder() {
    fun setVideoConfig(call: MethodCall, result: MethodChannel.Result) {
        videoPlayer.release()
        val videoOptions = call.argument<Map<String, Any?>>("builderParams")!!
        val url = GsyVideoPlayerView.getParameter(videoOptions, "url", "")
        val playVideoDataSourceType = GsyVideoPlayerView.getParameter(videoOptions, "playVideoDataSourceType", 0)
        if (playVideoDataSourceType == 0) {
            val context = GsyVideoShared.activity?.applicationContext
            // 现在你可以使用 context 来获取 AssetManager
            val assetManager: AssetManager? = context?.assets
            val fd = assetManager!!.openFd(url)
            this.setUrl("asset:///$fd")
        } else {
            this.setUrl(url)
        }
        val releaseWhenLossAudio = GsyVideoPlayerView.getParameter(videoOptions, "releaseWhenLossAudio", true)
        this.setReleaseWhenLossAudio(releaseWhenLossAudio)
        val seekRatio = GsyVideoPlayerView.getParameter(videoOptions, "seekRatio", 1.0)
        this.setSeekRatio(seekRatio.toFloat())
        val startAfterPrepared = GsyVideoPlayerView.getParameter(videoOptions, "startAfterPrepared", true)
        this.setStartAfterPrepared(startAfterPrepared)
        val dismissControlTime = GsyVideoPlayerView.getParameter(videoOptions, "dismissControlTime", 2500)
        this.setDismissControlTime(dismissControlTime)
        val isTouchWiget = GsyVideoPlayerView.getParameter(videoOptions, "isTouchWiget", true)
        this.setIsTouchWiget(isTouchWiget)
        val isShowDragProgressTextOnSeekBar = GsyVideoPlayerView.getParameter(videoOptions, "isShowDragProgressTextOnSeekBar", false)
        this.setShowDragProgressTextOnSeekBar(isShowDragProgressTextOnSeekBar)
        val speed = GsyVideoPlayerView.getParameter(videoOptions, "speed", 1.0)
        this.setSpeed(speed.toFloat())
        val header: MutableMap<String, String> = HashMap()
        val mapHeadData = GsyVideoPlayerView.getParameter(videoOptions, "mapHeadData", header)
        this.setMapHeadData(mapHeadData)
        val playTag = GsyVideoPlayerView.getParameter(videoOptions, "playTag", "")
        if (playTag.isNotEmpty()) {
            this.setPlayTag(playTag)
        }
        val needOrientationUtils = GsyVideoPlayerView.getParameter(videoOptions, "needOrientationUtils", true)
        this.setNeedOrientationUtils(needOrientationUtils)
        val hideKey = GsyVideoPlayerView.getParameter(videoOptions, "hideKey", true)
        this.setHideKey(hideKey)
        val showPauseCover = GsyVideoPlayerView.getParameter(videoOptions, "showPauseCover", true)
        this.setShowPauseCover(showPauseCover)
        val statusBar = GsyVideoPlayerView.getParameter(videoOptions, "statusBar", false)
        this.setFullHideStatusBar(statusBar)
        val showFullAnimation = GsyVideoPlayerView.getParameter(videoOptions, "showFullAnimation", true)
        this.setShowFullAnimation(showFullAnimation)
        val rotateWithSystem = GsyVideoPlayerView.getParameter(videoOptions, "rotateWithSystem", true)
        this.setRotateWithSystem(rotateWithSystem)
        val enlargeImageRes = GsyVideoPlayerView.getParameter(videoOptions, "enlargeImageRes", -1)
        this.setEnlargeImageRes(enlargeImageRes)
        val shrinkImageRes = GsyVideoPlayerView.getParameter(videoOptions, "shrinkImageRes", -1)
        this.setShrinkImageRes(shrinkImageRes)
        val isUseCustomCachePath = GsyVideoPlayerView.getParameter(videoOptions, "isUseCustomCachePath", false)
        val cachePath = GsyVideoPlayerView.getParameter(videoOptions, "cachePath", "")
        if (isUseCustomCachePath && cachePath.isNotEmpty()) {
            this.setCachePath(File(cachePath))
        }
        val looping = GsyVideoPlayerView.getParameter(videoOptions, "looping", false)
        this.setLooping(looping)
        val dialogProgressHighLightColor = GsyVideoPlayerView.getParameter(videoOptions, "dialogProgressHighLightColor", -11)
        val dialogProgressNormalColor = GsyVideoPlayerView.getParameter(videoOptions, "dialogProgressNormalColor", -11)
        this.setDialogProgressColor(dialogProgressHighLightColor, dialogProgressNormalColor)
        val thumbPlay = GsyVideoPlayerView.getParameter(videoOptions, "thumbPlay", true)
        this.setThumbPlay(thumbPlay)
        val actionBar = GsyVideoPlayerView.getParameter(videoOptions, "actionBar", false)
        this.setFullHideActionBar(actionBar)
        val videoTitle = GsyVideoPlayerView.getParameter(videoOptions, "videoTitle", "")
        if (videoTitle.isNotEmpty()) {
            videoPlayer.titleTextView.visibility = View.VISIBLE
            this.setVideoTitle(videoTitle)
        } else {
            videoPlayer.titleTextView.visibility = View.GONE
        }
        val playPosition = GsyVideoPlayerView.getParameter(videoOptions, "playPosition", -22)
        this.setPlayPosition(playPosition)
        val isTouchWigetFull = GsyVideoPlayerView.getParameter(videoOptions, "isTouchWigetFull", true)
        this.setIsTouchWigetFull(isTouchWigetFull)
        val autoFullWithSize = GsyVideoPlayerView.getParameter(videoOptions, "autoFullWithSize", false)
        this.setAutoFullWithSize(autoFullWithSize)
        val cacheWithPlay = GsyVideoPlayerView.getParameter(videoOptions, "cacheWithPlay", true)
        this.setCacheWithPlay(cacheWithPlay)
        val sounchTouch = GsyVideoPlayerView.getParameter(videoOptions, "sounchTouch", true)
        this.setSoundTouch(sounchTouch)
        val rotateViewAuto = GsyVideoPlayerView.getParameter(videoOptions, "rotateViewAuto", true)
        this.setRotateViewAuto(rotateViewAuto)
        val isOnlyRotateLand = GsyVideoPlayerView.getParameter(videoOptions, "isOnlyRotateLand", false)
        this.setOnlyRotateLand(isOnlyRotateLand)
        val needLockFull = GsyVideoPlayerView.getParameter(videoOptions, "needLockFull", true)
        this.setNeedLockFull(needLockFull)
        val seekOnStart = GsyVideoPlayerView.getParameter(videoOptions, "seekOnStart", -1)
        this.setSeekOnStart(seekOnStart.toLong())
        val needShowWifiTip = GsyVideoPlayerView.getParameter(videoOptions, "needShowWifiTip", true)
        this.setNeedShowWifiTip(needShowWifiTip)
        val surfaceErrorPlay = GsyVideoPlayerView.getParameter(videoOptions, "surfaceErrorPlay", true)
        this.setSurfaceErrorPlay(surfaceErrorPlay)
        val lockLand = GsyVideoPlayerView.getParameter(videoOptions, "lockLand", false)
        this.setLockLand(lockLand)
        val overrideExtension = GsyVideoPlayerView.getParameter(videoOptions, "overrideExtension", "")
        if (overrideExtension.isNotEmpty()) {
            this.setOverrideExtension(overrideExtension)
        }
        videoPlayer.backButton.visibility = View.GONE
        this.build(videoPlayer)
        val autoPlay = GsyVideoPlayerView.getParameter(videoOptions, "autoPlay", true)
        if (autoPlay) {
            videoPlayer.startPlayLogic()
        }
        val reply: MutableMap<String, Any> = HashMap()
        reply["setVideoConfig"] = true
        result.success(reply)
    }

}
package com.alizda.gsy_video_player

import android.content.res.AssetManager
import android.os.Build
import android.view.View
import androidx.annotation.RequiresApi
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class CustomGSYVideoOptionBuilderApi {
    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun setVideoConfig(videoPlayer: GsyVideoPlayer, call: MethodCall, result: MethodChannel.Result): GSYVideoOptionBuilder {
        videoPlayer.getCurrentPlayer()!!.release()
        val gsyBuilder = GSYVideoOptionBuilder()
        val videoOptions = call.argument<Map<String, Any?>>("builderParams")!!
        val url = GsyVideoPlayerPlugin.getParameter(videoOptions, "url", "")
        val playVideoDataSourceType = GsyVideoPlayerPlugin.getParameter(videoOptions, "playVideoDataSourceType", 0)
        if (playVideoDataSourceType == 0) {
            val context = GsyVideoShared.activity?.applicationContext
            // 现在你可以使用 context 来获取 AssetManager
            val assetManager: AssetManager? = context?.assets
            val fd = assetManager!!.openFd(url)
            gsyBuilder.setUrl("asset:///$fd")
        } else {
            gsyBuilder.setUrl(url)
        }

        val releaseWhenLossAudio = GsyVideoPlayerPlugin.getParameter(videoOptions, "releaseWhenLossAudio", true)
        gsyBuilder.setReleaseWhenLossAudio(releaseWhenLossAudio)
        val seekRatio = GsyVideoPlayerPlugin.getParameter(videoOptions, "seekRatio", 1.0)
        gsyBuilder.setSeekRatio(seekRatio.toFloat())
        val startAfterPrepared = GsyVideoPlayerPlugin.getParameter(videoOptions, "startAfterPrepared", true)
        gsyBuilder.setStartAfterPrepared(startAfterPrepared)
        val dismissControlTime = GsyVideoPlayerPlugin.getParameter(videoOptions, "dismissControlTime", 2500)
        gsyBuilder.setDismissControlTime(dismissControlTime)
        val isTouchWiget = GsyVideoPlayerPlugin.getParameter(videoOptions, "isTouchWiget", true)
        gsyBuilder.setIsTouchWiget(isTouchWiget)
        val isShowDragProgressTextOnSeekBar = GsyVideoPlayerPlugin.getParameter(videoOptions, "isShowDragProgressTextOnSeekBar", false)
        gsyBuilder.setShowDragProgressTextOnSeekBar(isShowDragProgressTextOnSeekBar)
        val speed = GsyVideoPlayerPlugin.getParameter(videoOptions, "speed", 1.0)
        gsyBuilder.setSpeed(speed.toFloat())
        val header: MutableMap<String, String> = HashMap()
        val mapHeadData = GsyVideoPlayerPlugin.getParameter(videoOptions, "mapHeadData", header)
        gsyBuilder.setMapHeadData(mapHeadData)
        val playTag = GsyVideoPlayerPlugin.getParameter(videoOptions, "playTag", "")
        if (playTag.isNotEmpty()) {
            gsyBuilder.setPlayTag(playTag)
        }
        val needOrientationUtils = GsyVideoPlayerPlugin.getParameter(videoOptions, "needOrientationUtils", true)
        gsyBuilder.setNeedOrientationUtils(needOrientationUtils)
        val hideKey = GsyVideoPlayerPlugin.getParameter(videoOptions, "hideKey", true)
        gsyBuilder.setHideKey(hideKey)
        val showPauseCover = GsyVideoPlayerPlugin.getParameter(videoOptions, "showPauseCover", true)
        gsyBuilder.setShowPauseCover(showPauseCover)
        val statusBar = GsyVideoPlayerPlugin.getParameter(videoOptions, "statusBar", false)
        gsyBuilder.setFullHideStatusBar(statusBar)
        val showFullAnimation = GsyVideoPlayerPlugin.getParameter(videoOptions, "showFullAnimation", true)
        gsyBuilder.setShowFullAnimation(showFullAnimation)
        val rotateWithSystem = GsyVideoPlayerPlugin.getParameter(videoOptions, "rotateWithSystem", true)
        gsyBuilder.setRotateWithSystem(rotateWithSystem)
        val enlargeImageRes = GsyVideoPlayerPlugin.getParameter(videoOptions, "enlargeImageRes", -1)
        gsyBuilder.setEnlargeImageRes(enlargeImageRes)
        val shrinkImageRes = GsyVideoPlayerPlugin.getParameter(videoOptions, "shrinkImageRes", -1)
        gsyBuilder.setShrinkImageRes(shrinkImageRes)
        val isUseCustomCachePath = GsyVideoPlayerPlugin.getParameter(videoOptions, "isUseCustomCachePath", false)
        val cachePath = GsyVideoPlayerPlugin.getParameter(videoOptions, "cachePath", "")
        if (isUseCustomCachePath && cachePath.isNotEmpty()) {
            gsyBuilder.setCachePath(File(cachePath))
        }
        val looping = GsyVideoPlayerPlugin.getParameter(videoOptions, "looping", false)
        gsyBuilder.setLooping(looping)
        val dialogProgressHighLightColor = GsyVideoPlayerPlugin.getParameter(videoOptions, "dialogProgressHighLightColor", -11)
        val dialogProgressNormalColor = GsyVideoPlayerPlugin.getParameter(videoOptions, "dialogProgressNormalColor", -11)
        gsyBuilder.setDialogProgressColor(dialogProgressHighLightColor, dialogProgressNormalColor)
        val thumbPlay = GsyVideoPlayerPlugin.getParameter(videoOptions, "thumbPlay", true)
        gsyBuilder.setThumbPlay(thumbPlay)
        val actionBar = GsyVideoPlayerPlugin.getParameter(videoOptions, "actionBar", false)
        gsyBuilder.setFullHideActionBar(actionBar)
        val videoTitle = GsyVideoPlayerPlugin.getParameter(videoOptions, "videoTitle", "")
        if (videoTitle.isNotEmpty()) {
            videoPlayer.getCurrentPlayer()!!.titleTextView.visibility = View.VISIBLE
            gsyBuilder.setVideoTitle(videoTitle)
        } else {
            videoPlayer.getCurrentPlayer()!!.titleTextView.visibility = View.GONE
        }
        val playPosition = GsyVideoPlayerPlugin.getParameter(videoOptions, "playPosition", -22)
        gsyBuilder.setPlayPosition(playPosition)
        val isTouchWigetFull = GsyVideoPlayerPlugin.getParameter(videoOptions, "isTouchWigetFull", true)
        gsyBuilder.setIsTouchWigetFull(isTouchWigetFull)
        val autoFullWithSize = GsyVideoPlayerPlugin.getParameter(videoOptions, "autoFullWithSize", false)
        gsyBuilder.setAutoFullWithSize(autoFullWithSize)
        val cacheWithPlay = GsyVideoPlayerPlugin.getParameter(videoOptions, "cacheWithPlay", true)
        gsyBuilder.setCacheWithPlay(cacheWithPlay)
        val sounchTouch = GsyVideoPlayerPlugin.getParameter(videoOptions, "sounchTouch", true)
        gsyBuilder.setSoundTouch(sounchTouch)
        val rotateViewAuto = GsyVideoPlayerPlugin.getParameter(videoOptions, "rotateViewAuto", true)
        gsyBuilder.setRotateViewAuto(rotateViewAuto)
        val isOnlyRotateLand = GsyVideoPlayerPlugin.getParameter(videoOptions, "isOnlyRotateLand", false)
        gsyBuilder.setOnlyRotateLand(isOnlyRotateLand)
        val needLockFull = GsyVideoPlayerPlugin.getParameter(videoOptions, "needLockFull", true)
        gsyBuilder.setNeedLockFull(needLockFull)
        val seekOnStart = GsyVideoPlayerPlugin.getParameter(videoOptions, "seekOnStart", -1)
        gsyBuilder.setSeekOnStart(seekOnStart.toLong())
        val needShowWifiTip = GsyVideoPlayerPlugin.getParameter(videoOptions, "needShowWifiTip", true)
        gsyBuilder.setNeedShowWifiTip(needShowWifiTip)
        val surfaceErrorPlay = GsyVideoPlayerPlugin.getParameter(videoOptions, "surfaceErrorPlay", true)
        gsyBuilder.setSurfaceErrorPlay(surfaceErrorPlay)
        val lockLand = GsyVideoPlayerPlugin.getParameter(videoOptions, "lockLand", false)
        gsyBuilder.setLockLand(lockLand)
        val overrideExtension = GsyVideoPlayerPlugin.getParameter(videoOptions, "overrideExtension", "")
        if (overrideExtension.isNotEmpty()) {
            gsyBuilder.setOverrideExtension(overrideExtension)
        }
        videoPlayer.getCurrentPlayer()!!.backButton.visibility = View.GONE
        val autoPlay = GsyVideoPlayerPlugin.getParameter(videoOptions, "autoPlay", true)
        CustomVideoPlayer.autoPlay = autoPlay
        gsyBuilder.build(videoPlayer.getCurrentPlayer()!!)
        if (CustomVideoPlayer.autoPlay) {
            videoPlayer.getCurrentPlayer()!!.startPlayLogic()
        }
        val reply: MutableMap<String, Any> = HashMap()
        reply["setVideoConfig"] = true
        result.success(reply)
        return gsyBuilder
    }
}
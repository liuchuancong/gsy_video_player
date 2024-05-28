package com.alizda.gsy_video_player

import android.content.res.AssetManager
import android.os.Build
import android.view.View
import androidx.annotation.RequiresApi
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import tv.danmaku.ijk.media.player.IjkMediaPlayer
import java.io.File

class CustomGSYVideoOptionBuilderApi {
    fun setVideoConfig(videoPlayer: GsyVideoPlayer, customGSYVideoManagerApi: CustomGSYVideoManagerApi, call: MethodCall, result: MethodChannel.Result): GSYVideoOptionBuilder {
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
        val isUseCustomCachePath = GsyVideoPlayerPlugin.getParameter(videoOptions, "isUseCustomCachePath", false)
        val cachePath = GsyVideoPlayerPlugin.getParameter(videoOptions, "cachePath", "")
        if (isUseCustomCachePath && cachePath.isNotEmpty()) {
            gsyBuilder.setCachePath(File(cachePath))
        }
        val looping = GsyVideoPlayerPlugin.getParameter(videoOptions, "looping", false)
        gsyBuilder.setLooping(looping)

        val playPosition = GsyVideoPlayerPlugin.getParameter(videoOptions, "playPosition", 0)
        gsyBuilder.setPlayPosition(playPosition)

        val cacheWithPlay = GsyVideoPlayerPlugin.getParameter(videoOptions, "cacheWithPlay", true)
        gsyBuilder.setCacheWithPlay(cacheWithPlay)
        val sounchTouch = GsyVideoPlayerPlugin.getParameter(videoOptions, "sounchTouch", true)
        gsyBuilder.setSoundTouch(sounchTouch)

        val seekOnStart = GsyVideoPlayerPlugin.getParameter(videoOptions, "seekOnStart", -1)
        gsyBuilder.setSeekOnStart(seekOnStart.toLong())

        val surfaceErrorPlay = GsyVideoPlayerPlugin.getParameter(videoOptions, "surfaceErrorPlay", true)
        gsyBuilder.setSurfaceErrorPlay(surfaceErrorPlay)

        val overrideExtension = GsyVideoPlayerPlugin.getParameter(videoOptions, "overrideExtension", "")
        if (overrideExtension.isNotEmpty()) {
            gsyBuilder.setOverrideExtension(overrideExtension)
        }
        val autoPlay = GsyVideoPlayerPlugin.getParameter(videoOptions, "autoPlay", true)
        gsyBuilder.build(videoPlayer.getCurrentPlayer()!!)
        val useDefaultIjkOptions = GsyVideoPlayerPlugin.getParameter(videoOptions, "useDefaultIjkOptions", false)
        GsyVideoPlayer.useDefaultIjkOptions = useDefaultIjkOptions
        if (autoPlay) {
            videoPlayer.getCurrentPlayer()!!.startPlayLogic()
        }
        return gsyBuilder
    }
}
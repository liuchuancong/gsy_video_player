package com.alizda.gsy_video_player

import android.content.Context
import android.os.Build
import androidx.annotation.RequiresApi
import com.shuyu.gsyvideoplayer.GSYVideoManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class CustomGSYVideoPlayerApi(private var videoPlayer: GsyVideoPlayer, private val context: Context, private val id: Long) {
    //当前UI
    fun create(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["textureId"] = id
        result.success(reply)
    }

    fun dispose() {
        GSYVideoManager.instance().player.stop()
        GSYVideoManager.instance().player.release()
        GSYVideoManager.instance().player.releaseSurface()
        GSYVideoManager.instance().releaseMediaPlayer();
    }

    fun getLayoutId(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["layoutId"] = videoPlayer.getCurrentPlayer()!!.layoutId
        result.success(reply)
    }

    //开始播放
    fun startPlayLogic(call: MethodCall, result: MethodChannel.Result) {
        videoPlayer.getCurrentPlayer()!!.startPlayLogic()
    }

    fun setUp(call: MethodCall, result: MethodChannel.Result) {
        val setUpOptions = call.argument<Map<String, Any?>>("setUpOptions")!!
        val url = GsyVideoPlayerPlugin.getParameter(setUpOptions, "url", "")
        val cacheWithPlay = GsyVideoPlayerPlugin.getParameter(setUpOptions, "cacheWithPlay", true)
        val cachePath = GsyVideoPlayerPlugin.getParameter(setUpOptions, "cachePath", "")

        val title = GsyVideoPlayerPlugin.getParameter(setUpOptions, "title", "")
        if (cachePath.isNotEmpty()) {
            videoPlayer.getCurrentPlayer()!!.setUp(url, cacheWithPlay, File(cachePath), title)
        } else {
            videoPlayer.getCurrentPlayer()!!.setUp(url, cacheWithPlay, title)
        }
    }

    //暂停
    fun onVideoPause() {
        videoPlayer.getCurrentPlayer()!!.onVideoPause()
    }

    //继续播放

    fun onVideoResume() {
        videoPlayer.getCurrentPlayer()!!.onVideoResume()
    }


    fun clearCurrentCache() {
        videoPlayer.getCurrentPlayer()!!.clearCurrentCache()
    }


    fun getCurrentPositionWhenPlaying(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["currentPosition"] = videoPlayer.getCurrentPlayer()!!.currentPositionWhenPlaying
        result.success(reply)
    }

    fun releaseAllVideos() {
        GSYVideoManager.releaseAllVideos()
    }


    fun getCurrentState(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["currentState"] = videoPlayer.getCurrentPlayer()!!.currentState
        result.success(reply)
    }


    fun setPlayTag(call: MethodCall, result: MethodChannel.Result) {
        val playTag = call.argument<String>("playTag")!!
        videoPlayer.getCurrentPlayer()!!.playTag = playTag
    }


    fun setPlayPosition(call: MethodCall, result: MethodChannel.Result) {
        val playPosition = (call.argument<Any>("playPosition") as Number?)!!.toInt()
        videoPlayer.getCurrentPlayer()!!.playPosition = playPosition
    }

    fun backFromWindowFull(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["backFromWindowFull"] = GSYVideoManager.backFromWindowFull(context)
        result.success(reply)
    }


    fun getNetSpeed(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["netSpeed"] = videoPlayer.getCurrentPlayer()!!.netSpeed
        result.success(reply)
    }


    fun getNetSpeedText(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["netSpeedText"] = videoPlayer.getCurrentPlayer()!!.netSpeedText
        result.success(reply)
    }


    fun setSeekOnStart(call: MethodCall, result: MethodChannel.Result) {
        val location = (call.argument<Any>("location") as Number?)!!.toInt()
        videoPlayer.getCurrentPlayer()!!.seekOnStart = location.toLong()
    }


    fun getBuffterPoint(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["buffterPoint"] = videoPlayer.getCurrentPlayer()!!.buffterPoint
        result.success(reply)
    }
}
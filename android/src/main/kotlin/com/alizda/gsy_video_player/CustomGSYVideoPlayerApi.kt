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
        if (GsyVideoPlayerPlugin.isInitialized) {
            GsyVideoPlayerPlugin.isInitialized = false
            GSYVideoManager.instance().releaseMediaPlayer();
        }
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun getLayoutId(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["layoutId"] =videoPlayer.getCurrentPlayer()!!.layoutId
        result.success(reply)
    }

    //开始播放
    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun startPlayLogic(call: MethodCall, result: MethodChannel.Result) {
       videoPlayer.getCurrentPlayer()!!.startPlayLogic()
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
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

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun onVideoPause() {
       videoPlayer.getCurrentPlayer()!!.onVideoPause()
    }

    //继续播放
    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun onVideoResume() {
       videoPlayer.getCurrentPlayer()!!.onVideoResume()
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun clearCurrentCache() {
       videoPlayer.getCurrentPlayer()!!.clearCurrentCache()
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun getCurrentPositionWhenPlaying(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["currentPosition"] =videoPlayer.getCurrentPlayer()!!.currentPositionWhenPlaying
        result.success(reply)
    }

    fun releaseAllVideos() {
        GSYVideoManager.releaseAllVideos()
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun getCurrentState(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["currentState"] =videoPlayer.getCurrentPlayer()!!.currentState
        result.success(reply)
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun setPlayTag(call: MethodCall, result: MethodChannel.Result) {
        val playTag = call.argument<String>("playTag")!!
       videoPlayer.getCurrentPlayer()!!.playTag = playTag
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun setPlayPosition(call: MethodCall, result: MethodChannel.Result) {
        val playPosition = (call.argument<Any>("playPosition") as Number?)!!.toInt()
       videoPlayer.getCurrentPlayer()!!.playPosition = playPosition
    }

    fun backFromWindowFull(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["backFromWindowFull"] = GSYVideoManager.backFromWindowFull(context)
        result.success(reply)
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun getNetSpeed(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["netSpeed"] =videoPlayer.getCurrentPlayer()!!.netSpeed
        result.success(reply)
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun getNetSpeedText(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["netSpeedText"] =videoPlayer.getCurrentPlayer()!!.netSpeedText
        result.success(reply)
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun setSeekOnStart(call: MethodCall, result: MethodChannel.Result) {
        val location = (call.argument<Any>("location") as Number?)!!.toInt()
       videoPlayer.getCurrentPlayer()!!.seekOnStart = location.toLong()
    }

    @RequiresApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
    fun getBuffterPoint(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["buffterPoint"] =videoPlayer.getCurrentPlayer()!!.buffterPoint
        result.success(reply)
    }
}
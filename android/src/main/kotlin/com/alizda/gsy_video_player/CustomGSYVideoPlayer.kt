package com.alizda.gsy_video_player

import android.content.Context
import com.shuyu.gsyvideoplayer.GSYVideoManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

class GSYVideoPlayer(private var videoPlayer: CustomVideoPlayer,private val context: Context,private val id: Int) {
    //当前UI
    fun create(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["textureId"] = id
        result.success(reply)
    }
    fun getLayoutId(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["layoutId"] = videoPlayer.layoutId
        result.success(reply)
    }

    //开始播放
    fun startPlayLogic(call: MethodCall, result: MethodChannel.Result) {
        videoPlayer.startPlayLogic()
    }
    fun setUp(call: MethodCall, result: MethodChannel.Result) {
        val setUpOptions = call.argument<Map<String, Any?>>("setUpOptions")!!
        val url = GsyVideoPlayerView.getParameter(setUpOptions, "url", "")
        val cacheWithPlay = GsyVideoPlayerView.getParameter(setUpOptions, "cacheWithPlay", true)
        val cachePath = GsyVideoPlayerView.getParameter(setUpOptions, "cachePath", "")

        val title = GsyVideoPlayerView.getParameter(setUpOptions, "title", "")
        if(cachePath.isNotEmpty()){
            videoPlayer.setUp(url, cacheWithPlay, File(cachePath), title)
        }else{
            videoPlayer.setUp(url, cacheWithPlay, title)
        }
    }

    //暂停

    fun onVideoPause() {
        videoPlayer.onVideoPause()
    }
    //继续播放
    fun onVideoResume() {
        videoPlayer.onVideoResume()
    }

    fun clearCurrentCache() {
        videoPlayer.clearCurrentCache()
    }

    fun getCurrentPositionWhenPlaying(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["currentPosition"] = videoPlayer.currentPositionWhenPlaying
        result.success(reply)
    }
    fun  releaseAllVideos(){
        GSYVideoManager.releaseAllVideos()
    }
    fun getCurrentState(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["currentState"] = videoPlayer.currentState
        result.success(reply)
    }

    fun setPlayTag(call: MethodCall, result: MethodChannel.Result){
        val playTag = call.argument<String>("playTag")!!
        videoPlayer.playTag = playTag
    }

    fun setPlayPosition(call: MethodCall, result: MethodChannel.Result){
        val playPosition = (call.argument<Any>("playPosition") as Number?)!!.toInt()
        videoPlayer.playPosition = playPosition
    }

    fun backFromWindowFull(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["backFromWindowFull"] = GSYVideoManager.backFromWindowFull(context)
        result.success(reply)
    }
    fun getNetSpeed(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["netSpeed"] = videoPlayer.netSpeed
        result.success(reply)
    }
    fun getNetSpeedText(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["netSpeedText"] = videoPlayer.netSpeedText
        result.success(reply)
    }
    fun setSeekOnStart(call: MethodCall, result: MethodChannel.Result){
        val location = (call.argument<Any>("location") as Number?)!!.toInt()
        videoPlayer.seekOnStart = location.toLong()
    }

    fun getBuffterPoint(call: MethodCall, result: MethodChannel.Result){
        val reply: MutableMap<String, Any> = HashMap()
        reply["buffterPoint"] = videoPlayer.buffterPoint
        result.success(reply)
    }
}
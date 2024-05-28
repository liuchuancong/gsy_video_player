package com.alizda.gsy_video_player

import android.content.Context
import android.graphics.Point
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CustomBasicApi(private var videoPlayer: CustomVideoPlayer, private val context: Context) {

    fun getSeekOnStart(call: MethodCall, result: MethodChannel.Result) {
        val seekOnStart = videoPlayer.seekOnStart
        val reply: MutableMap<String, Any> = HashMap()
        reply["seekOnStart"] = seekOnStart
        result.success(reply)
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
        val speed = GsyVideoPlayerPlugin.getParameter(speedOptions, "speed", 1.0F);
        val soundTouch = GsyVideoPlayerPlugin.getParameter(speedOptions, "soundTouch", true);
        videoPlayer.setSpeed(speed, soundTouch)
    }

    fun setSpeedPlaying(call: MethodCall, result: MethodChannel.Result) {
        val speedOptions = call.argument<Map<String, Any?>>("speedPlayingOptions")!!
        val speed = GsyVideoPlayerPlugin.getParameter(speedOptions, "speed", 1.0F);
        val soundTouch = GsyVideoPlayerPlugin.getParameter(speedOptions, "soundTouch", true);
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
package com.alizda.gsy_video_player

import com.alizda.gsy_video_player.CustomVideoAllCallBackApi.Companion.videoDuration
import com.alizda.gsy_video_player.CustomVideoAllCallBackApi.Companion.videoPosition
import com.shuyu.gsyvideoplayer.GSYVideoManager


class CustomGSYMediaPlayerListenerApi(private var videoPlayer: CustomVideoPlayer) {
    private var lastSendBufferedPosition: Int = 0
    private fun isPlaying(): Boolean = GSYVideoManager.instance().isPlaying
    private fun getCurrentState(): Int = videoPlayer.currentState
    private fun sendBufferingUpdate(eventSink: QueuingEventSink, percent: Int) {
        val bufferedPosition = videoPlayer.buffterPoint
        if (bufferedPosition != lastSendBufferedPosition) {
            val event: MutableMap<String, Any> = HashMap()
            val reply: MutableMap<String, Any> = HashMap()
            val range: List<Number?> = listOf(0, bufferedPosition)
            event["event"] = "onListenerBufferingUpdate"
            reply["duration"] = videoDuration
            reply["position"] = videoPosition
            reply["isPlaying"] = isPlaying()
            reply["percent"] = percent
            reply["currentState"] = getCurrentState()
            reply["values"] = listOf(range)
            eventSink.success(event)
            lastSendBufferedPosition = bufferedPosition
        }
    }

    fun sendInitialized(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        event["event"] = "initialized"
        sink.success(event)
    }

    fun sendVideoPlayerInitialized(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "videoPlayerInitialized"
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        reply["isPlaying"] = isPlaying()
        reply["currentState"] = getCurrentState()
        reply["width"] = GSYVideoManager.instance().player.videoWidth
        reply["height"] = GSYVideoManager.instance().player.videoHeight
        reply["videoSarDen"] = GSYVideoManager.instance().player.videoWidth
        reply["videoSarNum"] = GSYVideoManager.instance().player.videoSarNum
        reply["width"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onConfigurationChanged(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerConfigurationChanged"
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        reply["isPlaying"] = isPlaying()
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onPrepared(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerPrepared"
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        reply["isPlaying"] = isPlaying()
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onAutoCompletion(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerAutoCompletion"
        reply["duration"] = videoDuration
        reply["isPlaying"] = isPlaying()
        reply["position"] = videoPosition
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onCompletion(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerCompletion"
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        reply["isPlaying"] = isPlaying()
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onBufferingUpdate(sink: QueuingEventSink, percent: Int) {
        sendBufferingUpdate(sink, percent)
    }

    fun onSeekComplete(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerSeekComplete"
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        reply["isPlaying"] = isPlaying()
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onError(sink: QueuingEventSink, what: Int, extra: Int) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerError"
        event["reply"] = reply
        reply["what"] = what
        reply["extra"] = extra
        reply["currentState"] = getCurrentState()
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        reply["isPlaying"] = isPlaying()
        sink.success(event)
    }

    fun onInfo(sink: QueuingEventSink, what: Int, extra: Int) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerInfo"
        reply["isPlaying"] = isPlaying()
        event["reply"] = reply
        reply["what"] = what
        reply["extra"] = extra
        reply["currentState"] = getCurrentState()
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        sink.success(event)
    }

    fun onFullButtonClick(sink: QueuingEventSink) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onFullButtonClick"
        reply["isPlaying"] = isPlaying()
        event["reply"] = reply
        reply["currentState"] = getCurrentState()
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        sink.success(event)
    }

    fun onVideoSizeChanged(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerVideoSizeChanged"
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        reply["isPlaying"] = isPlaying()
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onBackFullscreen(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerBackFullscreen"
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        reply["isPlaying"] = isPlaying()
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onVideoPause(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerVideoPause"
        reply["duration"] = videoDuration
        reply["currentState"] = getCurrentState()
        reply["position"] = videoPosition
        reply["isPlaying"] = isPlaying()
        event["reply"] = reply
        sink.success(event)
    }

    fun onVideoResume(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerVideoResume"
        reply["duration"] = videoDuration
        reply["isPlaying"] = isPlaying()
        reply["currentState"] = getCurrentState()
        reply["position"] = videoPosition
        event["reply"] = reply
        sink.success(event)
    }

    fun onVideoResume(sink: QueuingEventSink, seek: Boolean) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onListenerVideoResumeWithSeek"
        reply["duration"] = videoDuration
        reply["position"] = videoPosition
        reply["currentState"] = getCurrentState()
        reply["seek"] = seek
        reply["isPlaying"] = isPlaying()
        event["reply"] = reply
        sink.success(event)
    }
}
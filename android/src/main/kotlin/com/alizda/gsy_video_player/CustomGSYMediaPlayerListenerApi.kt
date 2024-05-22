package com.alizda.gsy_video_player

import android.util.Log
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.video.base.GSYVideoView.CURRENT_STATE_PLAYING_BUFFERING_START


class CustomGSYMediaPlayerListenerApi(private var videoPlayer: CustomVideoPlayer) {
    private fun getCurrentState(): Int = videoPlayer.currentState
    private fun sendBufferingUpdate(eventSink: QueuingEventSink, percent: Int) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onBufferingUpdate"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        reply["currentState"] = getCurrentState()
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["bufferPercent"] = percent
        event["reply"] = reply
        eventSink.success(event)
    }

    fun sendInitialized(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        event["event"] = "initialized"
        sink.success(event)
    }

    fun sendVideoPlayerInitialized(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onVideoPlayerInitialized"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        reply["currentState"] = getCurrentState()
        reply["width"] = GSYVideoManager.instance().player.videoWidth
        reply["height"] = GSYVideoManager.instance().player.videoHeight
        reply["videoSarDen"] = GSYVideoManager.instance().player.videoSarDen
        reply["videoSarNum"] = GSYVideoManager.instance().player.videoSarNum
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        event["reply"] = reply
        sink.success(event)
    }

    fun onConfigurationChanged(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onConfigurationChanged"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onPrepared(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onPrepared"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["isPlaying"] = true
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onAutoCompletion(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onAutoCompletion"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["isPlaying"] = false
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onCompletion(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onCompletion"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["isPlaying"] = false
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
        event["event"] = "onSeekComplete"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["isPlaying"] = false
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onError(sink: QueuingEventSink, what: Int, extra: Int) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onError"
        reply["what"] = what
        reply["extra"] = extra
        reply["currentState"] = getCurrentState()
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["isPlaying"] = false
        event["reply"] = reply
        sink.success(event)
    }

    fun onInfo(sink: QueuingEventSink, what: Int, extra: Int) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onInfo"
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        reply["what"] = what
        reply["extra"] = extra
        reply["currentState"] = getCurrentState()
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        event["reply"] = reply
        sink.success(event)
    }

    fun onBufferingEnd(sink: QueuingEventSink, what: Int, extra: Int) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onBufferingEnd"
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        reply["what"] = what
        reply["extra"] = extra
        reply["currentState"] = getCurrentState()
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        event["reply"] = reply
        sink.success(event)
    }



    fun onFullButtonClick(sink: QueuingEventSink) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onFullButtonClick"
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        reply["currentState"] = getCurrentState()
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        event["reply"] = reply
        sink.success(event)
    }

    fun onVideoSizeChanged(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onVideoSizeChanged"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["width"] = GSYVideoManager.instance().player.videoWidth
        reply["height"] = GSYVideoManager.instance().player.videoHeight
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["isPlaying"] = true
        reply["currentState"] = getCurrentState()

        event["reply"] = reply
        sink.success(event)
    }

    fun onBackFullscreen(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onBackFullscreen"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        reply["currentState"] = getCurrentState()
        event["reply"] = reply
        sink.success(event)
    }

    fun onVideoPause(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onVideoPause"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["currentState"] = getCurrentState()
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["isPlaying"] = false
        event["reply"] = reply
        sink.success(event)
    }

    fun onVideoResume(sink: QueuingEventSink) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onVideoResume"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["isPlaying"] = true
        reply["currentState"] = getCurrentState()
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        event["reply"] = reply
        sink.success(event)
    }

    fun onVideoResume(sink: QueuingEventSink, seek: Boolean) {
        val event: MutableMap<String, Any?> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onVideoResumeWithSeek"
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["isBuffering"] = getCurrentState() == CURRENT_STATE_PLAYING_BUFFERING_START
        reply["currentState"] = getCurrentState()
        reply["seek"] = seek
        reply["isPlaying"] = true
        event["reply"] = reply
        sink.success(event)
    }
}
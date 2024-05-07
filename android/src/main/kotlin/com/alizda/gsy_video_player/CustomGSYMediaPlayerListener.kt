package com.alizda.gsy_video_player

import com.shuyu.gsyvideoplayer.GSYVideoManager


class CustomGSYMediaPlayerListener(private var videoPlayer: CustomVideoPlayer) {
    private var lastSendBufferedPosition: Int = 0
    private fun getDuration(): Long = videoPlayer.duration

    private fun getPosition(): Int = videoPlayer.playPosition

    private fun isPlaying(): Boolean = GSYVideoManager.instance().isPlaying
    private fun getCurrentState(): Int = videoPlayer.currentState
    private fun sendBufferingUpdate(eventSink:QueuingEventSink,percent: Int) {
        val bufferedPosition = videoPlayer.buffterPoint
        if (bufferedPosition != lastSendBufferedPosition) {
            val event: MutableMap<String, Any> = HashMap()
            val reply: MutableMap<String, Any> = HashMap()
            val range: List<Number?> = listOf(0, bufferedPosition)
            event["event"] = "onListenerBufferingUpdate"
            reply["duration"] = getDuration()
            reply["position"] = getPosition()
            reply["isPlaying"] = isPlaying()
            reply["percent"] = percent
            reply["currentState"] = getCurrentState()
            reply["values"] = listOf(range)
            eventSink.success(event)
            lastSendBufferedPosition = bufferedPosition
        }
    }
    fun sendInitialized(sink: QueuingEventSink) {
        if (GsyVideoPlayerView.isInitialized) {
            val event: MutableMap<String, Any?> = HashMap()
            val reply: MutableMap<String, Any> = HashMap()
            event["event"] = "initialized"
            reply["duration"] = getDuration()
            reply["position"] = getPosition()
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
    }
     fun onPrepared(sink: QueuingEventSink) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onPrepared"
         reply["duration"] = getDuration()
         reply["position"] =getPosition()
         reply["isPlaying"] = isPlaying()
         reply["currentState"] = getCurrentState()
         event["reply"] = reply
         sink.success(event)
    }

     fun onAutoCompletion(sink: QueuingEventSink) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerVideoResumeWithSeek"
         reply["duration"] = getDuration()
         reply["isPlaying"] = isPlaying()
         reply["position"] =getPosition()
         reply["currentState"] = getCurrentState()
         event["reply"] = reply
         sink.success(event)
    }

     fun onCompletion(sink: QueuingEventSink) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerVideoResumeWithSeek"
         reply["duration"] = getDuration()
         reply["position"] =getPosition()
         reply["isPlaying"] = isPlaying()
         reply["currentState"] = getCurrentState()
         event["reply"] = reply
         sink.success(event)
    }

     fun onBufferingUpdate(sink: QueuingEventSink,percent: Int) {
         sendBufferingUpdate(sink,percent)
    }

     fun onSeekComplete(sink: QueuingEventSink) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onSeekComplete"
         reply["duration"] = getDuration()
         reply["position"] =getPosition()
         reply["isPlaying"] = isPlaying()
         reply["currentState"] = getCurrentState()
         event["reply"] = reply
         sink.success(event)
    }

     fun onError(sink: QueuingEventSink,what: Int, extra: Int) {
         val event: MutableMap<String, Any> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerError"
         event["reply"] = reply
         reply["what"] = what
         reply["extra"] = extra
         reply["currentState"] = getCurrentState()
         reply["duration"] = getDuration()
         reply["position"] =getPosition()
         reply["isPlaying"] = isPlaying()
         sink.error(what.toString(),extra.toString(),reply)
    }

     fun onInfo(sink: QueuingEventSink,what: Int, extra: Int) {
         val event: MutableMap<String, Any> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerInfo"
         reply["isPlaying"] = isPlaying()
         event["reply"] = reply
         reply["what"] = what
         reply["extra"] = extra
         reply["currentState"] = getCurrentState()
         reply["duration"] = getDuration()
         reply["position"] =getPosition()
         sink.success(event)
    }

     fun onVideoSizeChanged(sink: QueuingEventSink) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onVideoSizeChanged"
         reply["duration"] = getDuration()
         reply["position"] =getPosition()
         reply["isPlaying"] = isPlaying()
         reply["currentState"] = getCurrentState()
         event["reply"] = reply
         sink.success(event)
    }

     fun onBackFullscreen(sink: QueuingEventSink) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onBackFullscreen"
         reply["duration"] = getDuration()
         reply["position"] =getPosition()
         reply["isPlaying"] = isPlaying()
         reply["currentState"] = getCurrentState()
         event["reply"] = reply
         sink.success(event)
    }

     fun onVideoPause(sink: QueuingEventSink) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onVideoPause"
         reply["duration"] = getDuration()
         reply["currentState"] = getCurrentState()
         reply["position"] =getPosition()
         reply["isPlaying"] = isPlaying()
         event["reply"] = reply
         sink.success(event)
    }

     fun onVideoResume(sink: QueuingEventSink) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onVideoResume"
         reply["duration"] = getDuration()
         reply["isPlaying"] = isPlaying()
         reply["currentState"] = getCurrentState()
         reply["position"] =getPosition()
         event["reply"] = reply
         sink.success(event)
    }

     fun onVideoResume(sink: QueuingEventSink,seek: Boolean) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerVideoResumeWithSeek"
         reply["duration"] = getDuration()
         reply["position"] =getPosition()
         reply["currentState"] = getCurrentState()
         reply["seek"] = seek
         reply["isPlaying"] = isPlaying()
         event["reply"] = reply
         sink.success(event)
    }
}
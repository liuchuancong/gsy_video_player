package com.alizda.gsy_video_player


class CustomGSYMediaPlayerListener(private var videoPlayer: CustomVideoPlayer) {
    private var lastSendBufferedPosition: Int = 0
    private fun getDuration(): Long = videoPlayer.duration

    private fun getPosition(): Int = videoPlayer.playPosition

    private fun getCurrentState(): Int = videoPlayer.currentState
    private fun sendBufferingUpdate(eventSink:QueuingEventSink,percent: Int) {
        val bufferedPosition = videoPlayer.buffterPoint
        if (bufferedPosition != lastSendBufferedPosition) {
            val event: MutableMap<String, Any> = HashMap()
            val reply: MutableMap<String, Any> = HashMap()
            val range: List<Number?> = listOf(0, bufferedPosition)
            event["event"] = "onListenerBufferingUpdate"
            reply["duration"] = getDuration()
            reply["position"] =getPosition()
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
            reply["position"] =getPosition()
            reply["currentState"] = getCurrentState()
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
         reply["currentState"] = getCurrentState()
         event["reply"] = reply
         sink.success(event)
    }

     fun onAutoCompletion(sink: QueuingEventSink) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerVideoResumeWithSeek"
         reply["duration"] = getDuration()
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
         sink.error(what.toString(),extra.toString(),reply)
    }

     fun onInfo(sink: QueuingEventSink,what: Int, extra: Int) {
         val event: MutableMap<String, Any> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerInfo"
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
         event["reply"] = reply
         sink.success(event)
    }

     fun onVideoResume(sink: QueuingEventSink) {
         val event: MutableMap<String, Any?> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onVideoResume"
         reply["duration"] = getDuration()
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
         event["reply"] = reply
         sink.success(event)
    }
}
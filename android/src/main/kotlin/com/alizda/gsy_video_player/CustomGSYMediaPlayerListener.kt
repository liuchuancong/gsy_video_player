package com.alizda.gsy_video_player


class CustomGSYMediaPlayerListener {
     fun onPrepared(sink: QueuingEventSink) {
         val event: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerPrepared"
         sink.success(event)
    }

     fun onAutoCompletion(sink: QueuingEventSink) {
         val event: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerAutoCompletion"
         sink.success(event)
    }

     fun onCompletion(sink: QueuingEventSink) {
         val event: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerCompletion"
         sink.success(event)
    }

     fun onBufferingUpdate(sink: QueuingEventSink,percent: Int) {
         val event: MutableMap<String, Any> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerBufferingUpdate"
         event["reply"] = reply
         reply["percent"] = percent
         sink.success(event)
    }

     fun onSeekComplete(sink: QueuingEventSink) {
         val event: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerSeekComplete"
         sink.success(event)
    }

     fun onError(sink: QueuingEventSink,what: Int, extra: Int) {
         val event: MutableMap<String, Any> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerError"
         event["reply"] = reply
         reply["what"] = what
         reply["extra"] = extra
         sink.success(event)
    }

     fun onInfo(sink: QueuingEventSink,what: Int, extra: Int) {
         val event: MutableMap<String, Any> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerInfo"
         event["reply"] = reply
         reply["what"] = what
         reply["extra"] = extra
         sink.success(event)
    }

     fun onVideoSizeChanged(sink: QueuingEventSink) {
         val event: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerVideoSizeChanged"
         sink.success(event)
    }

     fun onBackFullscreen(sink: QueuingEventSink) {
         val event: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerBackFullscreen"
         sink.success(event)
    }

     fun onVideoPause(sink: QueuingEventSink) {
         val event: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerVideoPause"
         sink.success(event)
    }

     fun onVideoResume(sink: QueuingEventSink) {
         val event: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerVideoResume"
         sink.success(event)
    }

     fun onVideoResume(sink: QueuingEventSink,seek: Boolean) {
         val event: MutableMap<String, Any> = HashMap()
         val reply: MutableMap<String, Any> = HashMap()
         event["event"] = "onListenerVideoResumeWithSeek"
         event["reply"] = reply
         reply["seek"] = seek
         sink.success(event)
    }
}
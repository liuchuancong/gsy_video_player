package com.alizda.gsy_video_player

import com.shuyu.gsyvideoplayer.GSYVideoManager
import kotlin.math.floor

class CustomVideoAllCallBackApi(private var videoPlayer: CustomVideoPlayer) {
    private fun isPlaying(): Boolean = GSYVideoManager.instance().isPlaying
    private fun getCurrentState(): Int = videoPlayer.currentState
    fun onStartPrepared(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventStartPrepared"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onPrepared(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventPrepared"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    //点击了开始按键播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    fun onClickStartIcon(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickStartIcon"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    //点击了错误状态下的开始按键，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    fun onClickStartError(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickStartError"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    //点击了播放状态下的开始按键--->停止，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    fun onClickStop(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickStop"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onClickStopFullscreen(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickStopFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    //点击了暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    fun onClickResume(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickResume"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    //点击了全屏暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    fun onClickResumeFullscreen(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickResumeFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    //点击了空白弹出seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    fun onClickSeekbar(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickSeekbar"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    //点击了全屏的seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    fun onClickSeekbarFullscreen(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickSeekbarFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    //播放完了，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
    fun onAutoComplete(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventAutoComplete"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onEnterFullscreen(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventEnterFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onQuitFullscreen(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventQuitFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onQuitSmallWidget(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventQuitSmallWidget"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onEnterSmallWidget(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventEnterSmallWidget"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onTouchScreenSeekVolume(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventTouchScreenSeekVolume"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onTouchScreenSeekPosition(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventTouchScreenSeekPosition"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onTouchScreenSeekLight(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventTouchScreenSeekLight"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onPlayError(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventPlayError"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onClickStartThumb(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickStartThumb"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onClickBlank(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickBlank"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onClickBlankFullscreen(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventClickBlankFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onComplete(sink: QueuingEventSink, url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventComplete"
        event["reply"] = reply
        reply["url"] = url
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        sink.success(event)
    }

    fun onProgress(sink: QueuingEventSink) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEventProgress"
        event["reply"] = reply
        reply["duration"] = GSYVideoManager.instance().player.mediaPlayer.duration
        reply["position"] = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        reply["currentState"] = getCurrentState()
        reply["isPlaying"] = GSYVideoManager.instance().player.isPlaying
        val percent = floor((GSYVideoManager.instance().player.mediaPlayer.duration / GSYVideoManager.instance().player.mediaPlayer.currentPosition).toDouble())
        reply["percent"] = percent
        videoPosition = GSYVideoManager.instance().player.mediaPlayer.currentPosition
        videoDuration = GSYVideoManager.instance().player.mediaPlayer.duration
        sink.success(event)
    }

    companion object {
        var videoPosition: Long = 0L
        var videoDuration: Long = 0L
    }
}
package com.alizda.gsy_video_player

import io.flutter.plugin.common.EventChannel

class CustomVideoAllCallBack() {
     fun onStartPrepared(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onStartPrepared"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
         sink.success(event)
    }

     fun onPrepared(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onPrepared"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

    //点击了开始按键播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
     fun onClickStartIcon(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickStartIcon"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

    //点击了错误状态下的开始按键，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
     fun onClickStartError(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickStartIcon"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

    //点击了播放状态下的开始按键--->停止，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
     fun onClickStop(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickStop"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onClickStopFullscreen(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickStopFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

    //点击了暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
     fun onClickResume(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickResume"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

    //点击了全屏暂停状态下的开始按键--->播放，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
     fun onClickResumeFullscreen(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickResumeFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

    //点击了空白弹出seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
     fun onClickSeekbar(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickSeekbar"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

    //点击了全屏的seekbar，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
     fun onClickSeekbarFullscreen(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickSeekbarFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

    //播放完了，objects[0]是title，object[1]是当前所处播放器（全屏或非全屏）
     fun onAutoComplete(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onAutoComplete"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onEnterFullscreen(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEnterFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onQuitFullscreen(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onQuitFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onQuitSmallWidget(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onQuitSmallWidget"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onEnterSmallWidget(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onEnterSmallWidget"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onTouchScreenSeekVolume(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onTouchScreenSeekVolume"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onTouchScreenSeekPosition(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onTouchScreenSeekPosition"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onTouchScreenSeekLight(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onTouchScreenSeekLight"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onPlayError(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onPlayError"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onClickStartThumb(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickStartThumb"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onClickBlank(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickBlank"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onClickBlankFullscreen(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onClickBlankFullscreen"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onComplete(sink: EventChannel.EventSink,url: String, vararg objects: Any) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onComplete"
        event["reply"] = reply
        reply["url"] = url
        reply["title"] = objects[0]
        reply["player"] = objects[1]
        sink.success(event)
    }

     fun onProgress(sink: EventChannel.EventSink,progress: Long, secProgress: Long, currentPosition: Long, duration: Long) {
        val event: MutableMap<String, Any> = HashMap()
        val reply: MutableMap<String, Any> = HashMap()
        event["event"] = "onProgress"
        event["reply"] = reply
        reply["duration"] = duration
        reply["currentPosition"] = currentPosition
        sink.success(event)
    }
}
package com.alizda.gsy_video_player

import master.flame.danmaku.danmaku.model.BaseDanmaku.TYPE_SCROLL_RL
import master.flame.danmaku.danmaku.model.IDisplayer.DANMAKU_STYLE_DEFAULT

class DanmukuSettings {
    companion object{

        var showDanmaku:Boolean = false

        var url: String = ""

        var isLinkFile: Boolean = false

        var danmakuStyle: Int = DANMAKU_STYLE_DEFAULT

        var shadowRadius: Float = 0.0f

        var strokenWidth: Float = 0.0f

        var projectionOffsetX: Float = 0.0f

        var projectionOffsetY: Float = 0.0f

        var projectionAlpha: Float = 255F

        var isBold : Boolean = false

        var scrollSpeedFactor : Float = 1.0f

        var duplicateMergingEnabled : Boolean = false

        var overlappingEnablePair: HashMap<Int, Boolean>? = null

        var maxLinesPair: HashMap<Int, Int>? = null

        var opacity :Float = 255F

        var scaleTextSize :Float = 1.0f

        var margin : Int = 0

        var marginTop  : Int = 0

        var maximumVisibleSizeInScreen: Int = -1

        var pauseWhenVideoPaused: Boolean = false

        var enableDanmakuDrawingCache: Boolean = false

    }

}
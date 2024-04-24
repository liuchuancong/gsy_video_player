package com.alizda.gsy_video_player

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.platform.PlatformView

class GsyVideoPlayerView(private var messenger: BinaryMessenger, context: Context, viewId: Int, args: Any?) : PlatformView  {
    override fun getView(): View as  PlatformView{
        return GsyVideoPlayer(messenger,context,viewId,args)
    }

    override fun dispose() {
        TODO("Not yet implemented")
    }

}
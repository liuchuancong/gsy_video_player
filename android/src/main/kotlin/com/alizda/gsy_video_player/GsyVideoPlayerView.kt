package com.alizda.gsy_video_player

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.RelativeLayout
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView


class GsyVideoPlayerView(
    private val context: Context,
    messenger: BinaryMessenger,
    private val id: Int,
    private val params: HashMap<String, Any>
) : PlatformView, MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

    private val channel: MethodChannel = MethodChannel(
        messenger, "gsy_video_player_channel/videoView_$id"
    )

    init {
        channel.setMethodCallHandler(this)
    }

    override fun getView(): View = initGSYVideoPlayerView()

    private fun initGSYVideoPlayerView(): View {
        val layout = LayoutInflater.from(context)
            .inflate(R.layout.gsy_video_play, null) as RelativeLayout
        return layout;
    }

    override fun dispose() {
        TODO("Not yet implemented")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {

        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ): Boolean {
        TODO("Not yet implemented")
    }

}
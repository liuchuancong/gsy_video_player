package com.alizda.gsy_video_player

import android.content.Context
import android.view.Surface
import androidx.media3.exoplayer.ExoPlayer
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry

internal class GsyVideoPlayer(
    context: Context,
    private val eventChannel: EventChannel,
    private val textureEntry: TextureRegistry.SurfaceTextureEntry,
    result: MethodChannel.Result
) {
    private var player: CustomVideoPlayer? = null
    private val eventSink = QueuingEventSink()
    private var isInitialized = false
    private var surface: Surface? = null

    init {
        surface = Surface(textureEntry.surfaceTexture())
        player = CustomVideoPlayer(context,surface)
        setupVideoPlayer(eventChannel, textureEntry, result)
    }
    private fun setupVideoPlayer(
        eventChannel: EventChannel, textureEntry: TextureRegistry.SurfaceTextureEntry, result: MethodChannel.Result
    ) {
        eventChannel.setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(o: Any?, sink: EventChannel.EventSink) {
                    eventSink.setDelegate(sink)
                }

                override fun onCancel(o: Any?) {
                    eventSink.setDelegate(null)
                }
            })

//        player
    }

    fun dispose() {
        TODO("Not yet implemented")
    }

}
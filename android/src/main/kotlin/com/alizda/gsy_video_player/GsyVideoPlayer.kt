package com.alizda.gsy_video_player


import android.content.Context
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import io.flutter.plugin.common.BinaryMessenger

class GsyVideoPlayer(private var messenger: BinaryMessenger, context: Context, viewId: Int, args: Any?) : AppCompatActivity(viewId) {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.gsy_video_play)
    }
}
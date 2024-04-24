package com.alizda.gsy_video_player

import android.annotation.SuppressLint
import android.app.Activity
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

@SuppressLint("StaticFieldLeak")
object GsyVideoShared {
    const val VIDEO_PLAYER_ID = 513469796

    var activity: Activity? = null

    var binding: ActivityPluginBinding? = null

}
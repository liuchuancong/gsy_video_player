package com.alizda.gsy_video_player

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer




class DetailActivity : AppCompatActivity() {
    var detailPlayer: StandardGSYVideoPlayer? = null

    private var isPlay: kotlin.Boolean = false
    private var isPause: kotlin.Boolean = false
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

    }
}
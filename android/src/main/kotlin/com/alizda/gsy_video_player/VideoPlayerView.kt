package com.alizda.gsy_video_player

import android.os.Bundle
import android.os.PersistableBundle

import androidx.appcompat.app.AppCompatActivity


class VideoPlayerView(contentLayoutId: Int) : AppCompatActivity(contentLayoutId){
    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        setContentView(R.layout.gsy_video_play)
    }
}
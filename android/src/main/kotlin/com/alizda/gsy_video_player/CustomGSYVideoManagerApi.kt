package com.alizda.gsy_video_player

import android.content.Context
import androidx.annotation.OptIn
import androidx.media3.common.util.UnstableApi
import androidx.media3.datasource.DataSink
import androidx.media3.datasource.DataSource
import androidx.media3.datasource.TransferListener
import androidx.media3.exoplayer.source.MediaSource
import com.shuyu.aliplay.AliPlayerManager
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.cache.CacheFactory
import com.shuyu.gsyvideoplayer.cache.ProxyCacheManager
import com.shuyu.gsyvideoplayer.model.VideoOptionModel
import com.shuyu.gsyvideoplayer.player.IjkPlayerManager
import com.shuyu.gsyvideoplayer.player.PlayerFactory
import com.shuyu.gsyvideoplayer.player.SystemPlayerManager
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import tv.danmaku.ijk.media.exo2.Exo2PlayerManager
import tv.danmaku.ijk.media.exo2.ExoMediaSourceInterceptListener
import tv.danmaku.ijk.media.exo2.ExoPlayerCacheManager
import tv.danmaku.ijk.media.exo2.ExoSourceManager
import java.io.File


class CustomGSYVideoManagerApi(private val context: Context) {


    fun setCurrentPlayer(call: MethodCall, result: MethodChannel.Result) {
        val playerOptions = call.argument<Map<String, Any?>>("playerOptions")!!
        val currentPlayer = GsyVideoPlayerPlugin.getParameter(playerOptions, "currentPlayer", 0)
        when (currentPlayer) {
            0 -> PlayerFactory.setPlayManager(Exo2PlayerManager::class.java)
            1 -> PlayerFactory.setPlayManager(SystemPlayerManager::class.java)
            2 -> PlayerFactory.setPlayManager(IjkPlayerManager::class.java)
            3 -> PlayerFactory.setPlayManager(AliPlayerManager::class.java)
        }
    }

    fun getPlayManager(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        val player = PlayerFactory.getPlayManager()
        when (player) {
            Exo2PlayerManager::class.java -> reply["currentPlayer"] = 0
            SystemPlayerManager::class.java -> reply["currentPlayer"] = 1
            IjkPlayerManager::class.java -> reply["currentPlayer"] = 2
            AliPlayerManager::class.java -> reply["currentPlayer"] = 3
        }
        result.success(reply)
    }

    fun setExoCacheManager() {
        CacheFactory.setCacheManager(ExoPlayerCacheManager::class.java)
    }

    fun setProxyCacheManager() {
        CacheFactory.setCacheManager(ProxyCacheManager::class.java)
    }

    fun clearAllDefaultCache() {
        GSYVideoManager.instance().clearAllDefaultCache(context)
    }

    fun clearDefaultCache(call: MethodCall, result: MethodChannel.Result) {
        val playOptions = call.argument<Map<String, Any?>>("playOptions")!!
        val cacheDir = GsyVideoPlayerPlugin.getParameter(playOptions, "cacheDir", "")
        val url = GsyVideoPlayerPlugin.getParameter(playOptions, "url", "")
        GSYVideoManager.instance().clearDefaultCache(context, File(cacheDir), url)
    }

    fun releaseMediaPlayer() {
        GSYVideoManager.releaseAllVideos()
    }

    fun onPause() {
        GSYVideoManager.onPause()
    }

    fun onResume() {
        GSYVideoManager.onResume()
    }

    fun getPlayTag(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["playTag"] = GSYVideoManager.instance().playTag
        result.success(reply)
    }

    fun setPlayTag(call: MethodCall, result: MethodChannel.Result) {
        val playTag = call.argument<String>("playTag")!!
        GSYVideoManager.instance().playTag = playTag
    }

    fun setPlayPosition(call: MethodCall, result: MethodChannel.Result) {
        val playPosition = (call.argument<Any>("playPosition") as Number).toInt()
        GSYVideoManager.instance().playPosition = playPosition
    }

    fun getPlayPosition(call: MethodCall, result: MethodChannel.Result) {
        val playPosition = GSYVideoManager.instance().playPosition
        val reply: MutableMap<String, Any> = HashMap()
        reply["playPosition"] = playPosition
        result.success(reply)

    }

    fun getOptionModelList(call: MethodCall, result: MethodChannel.Result) {
        val optionModelList = GSYVideoManager.instance().optionModelList
        val reply: MutableMap<String, Any> = HashMap()
        val ijkOptions = optionModelList.map {
            val model: MutableMap<String, Any> = HashMap()
            model["category"] = it.category
            model["name"] = it.name
            model["valueInt"] = it.valueInt
        }.toTypedArray()
        reply["ijkOptions"] = ijkOptions
        result.success(reply)
    }

    fun setOptionModelList(call: MethodCall, result: MethodChannel.Result) {
        val ijkOptions = call.argument<List<Map<String, Any?>>>("ijkOptions")!!
        val list = ArrayList<VideoOptionModel>()
        for (option in ijkOptions) {
            val category = (option["category"] as Number).toInt()
            val valueInt = (option["valueInt"] as Number).toInt()
            val name = option["name"].toString()
            val videoOptionMode = VideoOptionModel(category, name, valueInt)
            list.add(videoOptionMode)
        }
        GSYVideoManager.instance().optionModelList = list
    }

    fun isNeedMute(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["isNeedMute"] = GSYVideoManager.instance().isNeedMute
        result.success(reply)

    }

    fun setNeedMute(call: MethodCall, result: MethodChannel.Result) {
        val isNeedMute = call.argument<Boolean>("isNeedMute")!!
        GSYVideoManager.instance().isNeedMute = isNeedMute
    }

    fun getTimeOut(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["timeOut"] = GSYVideoManager.instance().timeOut
        result.success(reply)
    }

    fun isNeedTimeOutOther(call: MethodCall, result: MethodChannel.Result) {
        val reply: MutableMap<String, Any> = HashMap()
        reply["isNeedTimeOutOther"] = GSYVideoManager.instance().isNeedTimeOutOther
        result.success(reply)
    }

    fun setTimeOut(call: MethodCall, result: MethodChannel.Result) {
        val timeOutOptions = call.argument<Map<String, Any?>>("timeOutOptions")
        val timeOut = GsyVideoPlayerPlugin.getParameter(timeOutOptions, "timeOut", 8000)
        val needTimeOutOther = GsyVideoPlayerPlugin.getParameter(timeOutOptions, "needTimeOutOther", false)
        GSYVideoManager.instance().setTimeOut(timeOut, needTimeOutOther)
    }

    fun setLogLevel(call: MethodCall, result: MethodChannel.Result){
        val logLevel = (call.argument<Any>("logLevel") as Number).toInt()
        IjkPlayerManager.setLogLevel(logLevel)
    }

    fun customExoMediaSource(call: MethodCall, result: MethodChannel.Result){
        ExoSourceManager.setExoMediaSourceInterceptListener(object : ExoMediaSourceInterceptListener {
            override fun getMediaSource(dataSource: String, preview: Boolean, cacheEnable: Boolean, isLooping: Boolean, cacheDir: File): MediaSource? {
                //如果返回 null，就使用默认的
                return null
            }

            @OptIn(UnstableApi::class) override fun getHttpDataSourceFactory(userAgent: String?, listener: TransferListener?, connectTimeoutMillis: Int, readTimeoutMillis: Int, mapHeadData: MutableMap<String, String>?, allowCrossProtocolRedirects: Boolean): DataSource.Factory? {
                return ExoSourceManager.getDataSourceFactory(context,true,null,mapHeadData)
            }

            @OptIn(UnstableApi::class) override fun cacheWriteDataSinkFactory(p0: String?, p1: String?): DataSink.Factory? {
                return null
            }
        })
    }

    fun  setVolume(call: MethodCall, result: MethodChannel.Result){
        val volume = (call.argument<Any>("volume") as Number).toFloat()
        GSYVideoManager.instance().player.setVolume(volume,volume)
    }
}
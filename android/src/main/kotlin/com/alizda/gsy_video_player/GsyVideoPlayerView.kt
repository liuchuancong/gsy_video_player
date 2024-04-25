package com.alizda.gsy_video_player

import android.content.Context
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.widget.RelativeLayout
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView


class GsyVideoPlayerView(
        private val context: Context,
        messenger: BinaryMessenger,
        private val id: Int,
        private val params: HashMap<*, *>
) : PlatformView, MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener {

    private val channel: MethodChannel = MethodChannel(messenger, "gsy_video_player_channel/videoView_$id")
    private lateinit var videoPlayer: StandardGSYVideoPlayer
    private var orientationUtils: OrientationUtils? = null
    private var gsyVideoOptionBuilder: GSYVideoOptionBuilder? = null

    init {
        channel.setMethodCallHandler(this)
        initVideoPlayer()
        setVideoConfig()

    }

    override fun getView(): View = initGSYVideoPlayerView()

    private fun initGSYVideoPlayerView(): View {
        return LayoutInflater.from(context)
                .inflate(R.layout.activity_danmaku_layout, null) as RelativeLayout
    }

    private fun  setVideoConfig(){
        gsyVideoOptionBuilder = GSYVideoOptionBuilder();
        val mHeader = HashMap<String, String>();
        mHeader["Referer"] = "https://www.huya.com";
        mHeader["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0";
        gsyVideoOptionBuilder!!.setMapHeadData(mHeader)
        gsyVideoOptionBuilder!!.setUrl("http://al.flv.huya.com/src/94525224-2583571962-11096357083652554752-3503038830-10057-A-0-1.flv?wsSecret=1bf7d229ba8516a38298c4a91ba6da12&wsTime=662a4b7c&seqid=10082953683646&ctype=tars_mp&ver=1&fs=bgct&sphdcdn=al_7-tx_3-js_3-ws_7-bd_2-hw_2&sphdDC=huya&sphd=264_%2A-265_%2A&exsphd=264_500%2C264_2000%2C&uid=8368927414786&uuid=3440215989&t=102&sv=2024042514")
        gsyVideoOptionBuilder!!.setCacheWithPlay(true)
        gsyVideoOptionBuilder!!.setStartAfterPrepared(true)
        videoPlayer.currentPlayer.startPlayLogic()
    }

    private fun initVideoPlayer() {

        videoPlayer = view.findViewById(R.id.danmaku_player)!!

        Log.d(TAG, "initVideoPlayer: ${videoPlayer.mapHeadData} ")

        //设置旋转
        orientationUtils = OrientationUtils(GsyVideoShared.activity, videoPlayer)
    }

    //    暂停
    private fun onPause() {
        videoPlayer.onVideoPause();
    }

    //    恢复
    private fun onResume() {
        videoPlayer.onVideoResume();
    }

    //    播放
    private fun onStart() {
        videoPlayer.startPlayLogic()
    }

    //快进
    private fun onSeekTo(location: Int) {
        videoPlayer.seekTo(location.toLong())
    }

    private fun onDestroy() {
        GSYVideoManager.releaseAllVideos()
        orientationUtils?.releaseListener();
        videoPlayer.setVideoAllCallBack(null);
    }

    override fun dispose() {
        onDestroy()
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


    companion object{
        private const val TAG ="GSY_VIDEO_PLAYER"
    }
}
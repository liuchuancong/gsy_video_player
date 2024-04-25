package com.alizda.gsy_video_player

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import com.shuyu.gsyvideoplayer.GSYVideoManager
import com.shuyu.gsyvideoplayer.builder.GSYVideoOptionBuilder
import com.shuyu.gsyvideoplayer.listener.VideoAllCallBack
import com.shuyu.gsyvideoplayer.player.IjkPlayerManager
import com.shuyu.gsyvideoplayer.player.PlayerFactory
import com.shuyu.gsyvideoplayer.player.SystemPlayerManager
import com.shuyu.gsyvideoplayer.utils.GSYVideoType
import com.shuyu.gsyvideoplayer.utils.OrientationUtils
import com.shuyu.gsyvideoplayer.video.StandardGSYVideoPlayer
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.platform.PlatformView
import tv.danmaku.ijk.media.exo2.Exo2PlayerManager


class GsyVideoPlayerView(
        private val context: Context,
        messenger: BinaryMessenger,
        private val id: Int,
        private val params: HashMap<*, *>
) : PlatformView, MethodChannel.MethodCallHandler, PluginRegistry.RequestPermissionsResultListener, VideoAllCallBack {

    private val channel: MethodChannel = MethodChannel(messenger, "gsy_video_player_channel/videoView_$id")
    private lateinit var videoPlayer: CustomVideoPlayer
    private var orientationUtils: OrientationUtils? = null
    private var gsyVideoOptionBuilder: GSYVideoOptionBuilder? = null
    private var rotateEnable:Boolean = false
    private var isPlay:Boolean = false
    private lateinit var mInflater: LayoutInflater
    private var gsyVideoType: Int = GSYVideoType.SCREEN_TYPE_16_9
    private var playerType: Int = 0;
    init {
        channel.setMethodCallHandler(this)
        setGlobalConfig()
        initVideoPlayer()
        setVideoConfig()

    }

    override fun getView(): View = initGSYVideoPlayerView()

    private fun initGSYVideoPlayerView(): View {
        val convertView = mInflater.inflate(R.layout.gsy_video_play, GsyVideoShared.activity?.findViewById(R.id.activity_play));
        return convertView
    }

    private fun  setVideoConfig(){
        gsyVideoOptionBuilder = GSYVideoOptionBuilder();
        val mHeader = HashMap<String, String>();
        mHeader["User-Agent"] = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0";
        gsyVideoOptionBuilder!!.setMapHeadData(mHeader)
        gsyVideoOptionBuilder!!.setUrl("https://cloud.video.taobao.com//play/u/57349687/p/1/e/6/t/1/239880949246.mp4")
        gsyVideoOptionBuilder!!.setCacheWithPlay(false)
        gsyVideoOptionBuilder!!.setStartAfterPrepared(true)
        gsyVideoOptionBuilder!!.setVideoAllCallBack(this);
        gsyVideoOptionBuilder!!.build(videoPlayer);
        videoPlayer.startPlayLogic()
    }

    private fun setGlobalConfig(){
        //EXOPlayer内核，支持格式更多
        PlayerFactory.setPlayManager(IjkPlayerManager::class.java)
        GSYVideoType.setRenderType(GSYVideoType.TEXTURE)
    }

    private fun initVideoPlayer() {

        mInflater = LayoutInflater.from(context);
        videoPlayer = view.findViewById(R.id.gsy_player)!!
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

    override fun onStartPrepared(url: String?, vararg objects: Any?) {}

    override fun onPrepared(url: String?, vararg objects: Any?) {
        if (orientationUtils == null) {
            throw NullPointerException("initVideo() or initVideoBuilderMode() first")
        }
        //开始播放了才能旋转和全屏
        orientationUtils!!.isEnable = rotateEnable && !videoPlayer.isAutoFullWithSize
        isPlay = true
    }

    override fun onClickStartIcon(url: String?, vararg objects: Any?) {}

    override fun onClickStartError(url: String?, vararg objects: Any?) {}

    override fun onClickStop(url: String?, vararg objects: Any?) {}

    override fun onClickStopFullscreen(url: String?, vararg objects: Any?) {}

    override fun onClickResume(url: String?, vararg objects: Any?) {}

    override fun onClickResumeFullscreen(url: String?, vararg objects: Any?) {}

    override fun onClickSeekbar(url: String?, vararg objects: Any?) {}

    override fun onClickSeekbarFullscreen(url: String?, vararg objects: Any?) {}

    override fun onAutoComplete(url: String?, vararg objects: Any?) {}

    override fun onEnterFullscreen(url: String?, vararg objects: Any?) {}

    override fun onQuitFullscreen(url: String?, vararg objects: Any?) {

        // ------- ！！！如果不需要旋转屏幕，可以不调用！！！-------
        // 不需要屏幕旋转，还需要设置 setNeedOrientationUtils(false)
        if (orientationUtils != null) {
            orientationUtils!!.backToProtVideo()
        }
    }

    override fun onQuitSmallWidget(url: String?, vararg objects: Any?) {}

    override fun onEnterSmallWidget(url: String?, vararg objects: Any?) {}

    override fun onTouchScreenSeekVolume(url: String?, vararg objects: Any?) {}

    override fun onTouchScreenSeekPosition(url: String?, vararg objects: Any?) {}

    override fun onTouchScreenSeekLight(url: String?, vararg objects: Any?) {}

    override fun onPlayError(url: String?, vararg objects: Any?) {}

    override fun onClickStartThumb(url: String?, vararg objects: Any?) {}

    override fun onClickBlank(url: String?, vararg objects: Any?) {}

    override fun onClickBlankFullscreen(url: String?, vararg objects: Any?) {}

    override fun onComplete(url: String?, vararg objects: Any?) {}


}
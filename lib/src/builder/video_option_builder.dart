import 'package:gsy_video_player/src/configuration/play_video_datasource_type.dart';

class VideoOptionBuilder {
  //退出全屏显示的案件图片
  static const int mShrinkImageRes = -1;
  //全屏显示的案件图片
  static const int mEnlargeImageRes = -1;

  //播放的tag，防止错误，因为普通的url也可能重复
  static const int mPlayPosition = -22;

  //触摸快进dialog的进度高量颜色
  static const int mDialogProgressHighLightColor = -11;

  //触摸快进dialog的进度普通颜色
  static const int mDialogProgressNormalColor = -11;

  //触摸隐藏等待时间
  static const int mDismissControlTime = 2500;

  //从哪个开始播放
  static const int mSeekOnStart = -1;

  //触摸滑动进度的比例系数
  static const double mSeekRatio = 1;

  //播放速度
  static const double mSpeed = 1;

  //是否隐藏虚拟按键
  static const bool mHideKey = true;

  //是否使用全屏动画效果
  static const bool mShowFullAnimation = true;

  //是否根据视频尺寸，自动选择竖屏全屏或者横屏全屏，注意，这时候默认旋转无效
  static const bool mAutoFullWithSize = false;

  //是否需要显示流量提示
  static const bool mNeedShowWifiTip = true;

  //是否自动旋转
  static const bool mRotateViewAuto = true;

  //当前全屏是否锁定全屏
  static const bool mLockLand = false;

  //循环
  static const bool mLooping = false;

  //是否支持非全屏滑动触摸有效
  static const bool mIsTouchWiget = true;

  //是否支持全屏滑动触摸有效
  static const bool mIsTouchWigetFull = true;

  //是否显示暂停图片
  static const bool mShowPauseCover = true;

  //旋转使能后是否跟随系统设置
  static const bool mRotateWithSystem = true;

  //播放错误时，是否点击触发重试
  static const bool mSurfaceErrorPlay = true;

  //边播放边缓存
  static const bool mCacheWithPlay = true;

  //是否需要锁定屏幕
  static const bool mNeedLockFull = true;

  //点击封面播放
  static const bool mThumbPlay = true;

  //是否需要变速不变调
  static const bool mSounchTouch = true;

  //Prepared之后是否自动开始播放
  static const bool mStartAfterPrepared = true;

  //是否播放器当失去音频焦点
  static const bool mReleaseWhenLossAudio = true;

  //是否需要在利用window实现全屏幕的时候隐藏actionbar
  static const bool mActionBar = false;

  //是否需要在利用window实现全屏幕的时候隐藏statusbar
  static const bool mStatusBar = false;

  //拖动进度条时，是否在 seekbar 开始部位显示拖动进度
  static const bool mShowDragProgressTextOnSeekBar = false;

  //播放的tag，防止错误，因为普通的url也可能重复
  static const String mPlayTag = "";

  //视频title
  static const String mVideoTitle = "";

  // 是否需要覆盖拓展类型
  static const String mOverrideExtension = "";

  static const bool mIsOnlyRotateLand = false;

  //是否自定义的缓冲文件路径
  static const bool mIsUseCustomCachePath = false;

  static const String mCachePath = "";

  //http请求头
  static const Map<String, String> mMapHeadData = {};

  //是否需要初始化内部 OrientationUtils
  static const bool mNeedOrientationUtils = true;

  // 播放地址
  String url;
  // 播放类型
  PlayVideoDataSourceType? playVideoDataSourceType;
  //退出全屏显示的案件图片
  int? shrinkImageRes;
  //
  int? enlargeImageRes;
  //播放的tag，防止错误，因为普通的url也可能重复
  int? playPosition;
  //触摸快进dialog的进度高量颜色
  int? dialogProgressHighLightColor;
  //触摸快进dialog的进度普通颜色
  int? dialogProgressNormalColor;
  //触摸隐藏等待时间
  int? dismissControlTime;
  //从哪个开始播放
  int? seekOnStart;
  //触摸滑动进度的比例系数
  double? seekRatio = 1;
  //播放速度
  double? speed = 1;
  //是否隐藏虚拟按键
  bool? hideKey;
  //是否使用全屏动画效果
  bool? showFullAnimation;
  //是否根据视频尺寸，自动选择竖屏全屏或者横屏全屏，注意，这时候默认旋转无效
  bool? autoFullWithSize;
  //是否需要显示流量提示
  bool? needShowWifiTip;
  //是否自动旋转
  bool? rotateViewAuto;
  //当前全屏是否锁定全屏
  bool? lockLand;
  //循环
  bool? looping;
  //是否支持非全屏滑动触摸有效
  bool? isTouchWiget;
  //是否支持全屏滑动触摸有效
  bool? isTouchWigetFull;
  //是否显示暂停图片
  bool? showPauseCover;
  //旋转使能后是否跟随系统设置
  bool? rotateWithSystem;
  //播放错误时，是否点击触发重试
  bool? surfaceErrorPlay;
  //边播放边缓存
  bool? cacheWithPlay;
  //是否需要锁定屏幕
  bool? needLockFull;
  //点击封面播放
  bool? thumbPlay;
  //是否需要变速不变调
  bool? sounchTouch;
  //Prepared之后是否自动开始播放
  bool? startAfterPrepared;
  //是否播放器当失去音频焦点
  bool? releaseWhenLossAudio;
  //是否需要在利用window实现全屏幕的时候隐藏actionbar
  bool? actionBar;
  //是否需要在利用window实现全屏幕的时候隐藏statusbar
  bool? statusBar;
  //拖动进度条时，是否在 seekbar 开始部位显示拖动进度
  bool? isShowDragProgressTextOnSeekBar;
  //播放的tag，防止错误，因为普通的url也可能重复
  String? playTag;
  //视频title
  String? videoTitle;

  //是否覆盖拓展类型
  String? overrideExtension;
  //是否只旋转横屏
  bool? isOnlyRotateLand;
  //是否使用自定义的缓冲
  bool? isUseCustomCachePath;
  //自定义的缓冲文件路径
  String? cachePath;
  //http请求头
  Map<String, String>? mapHeadData;
  //是否需要旋转的 OrientationUtils
  bool? needOrientationUtils;

  VideoOptionBuilder({
    required this.url,
    this.playVideoDataSourceType = PlayVideoDataSourceType.network,
    this.shrinkImageRes = mShrinkImageRes,
    this.enlargeImageRes = mEnlargeImageRes,
    this.playPosition = mPlayPosition,
    this.dialogProgressHighLightColor = mDialogProgressHighLightColor,
    this.dialogProgressNormalColor = mDialogProgressNormalColor,
    this.dismissControlTime = mDismissControlTime,
    this.seekOnStart = mSeekOnStart,
    this.hideKey = mHideKey,
    this.showFullAnimation = mShowFullAnimation,
    this.autoFullWithSize = mAutoFullWithSize,
    this.needShowWifiTip = mNeedShowWifiTip,
    this.rotateViewAuto = mRotateViewAuto,
    this.lockLand = mLockLand,
    this.looping = mLooping,
    this.isTouchWiget = mIsTouchWiget,
    this.isTouchWigetFull = mIsTouchWigetFull,
    this.showPauseCover = mShowPauseCover,
    this.rotateWithSystem = mRotateWithSystem,
    this.surfaceErrorPlay = mSurfaceErrorPlay,
    this.cacheWithPlay = mCacheWithPlay,
    this.needLockFull = mNeedLockFull,
    this.thumbPlay = mThumbPlay,
    this.sounchTouch = mSounchTouch,
    this.startAfterPrepared = mStartAfterPrepared,
    this.releaseWhenLossAudio = mReleaseWhenLossAudio,
    this.actionBar = mActionBar,
    this.statusBar = mStatusBar,
    this.isShowDragProgressTextOnSeekBar = mShowDragProgressTextOnSeekBar,
    this.playTag = mPlayTag,
    this.videoTitle = mVideoTitle,
    this.overrideExtension = mOverrideExtension,
    this.isOnlyRotateLand = mIsOnlyRotateLand,
    this.isUseCustomCachePath = mIsUseCustomCachePath,
    this.cachePath = mCachePath,
    this.mapHeadData = mMapHeadData,
    this.needOrientationUtils = mNeedOrientationUtils,
    this.seekRatio = mSeekRatio,
    this.speed = mSpeed,
  });

  /// 是否根据视频尺寸，自动选择竖屏全屏或者横屏全屏，注意，这时候默认旋转无效
  ///
  /// @param [autoFullWithSize] 默认false
  VideoOptionBuilder setAutoFullWithSize(bool autoFullWithSize) {
    this.autoFullWithSize = autoFullWithSize;
    return this;
  }

  /// 全屏动画
  ///
  /// @param [showFullAnimation] 是否使用全屏动画效果
  VideoOptionBuilder setShowFullAnimation(bool showFullAnimation) {
    this.showFullAnimation = showFullAnimation;
    return this;
  }

  /// 设置循环
  /// @param [looping] 是否使用循环
  VideoOptionBuilder setLooping(bool looping) {
    looping = looping;
    return this;
  }

  /// 是否开启自动旋转
  VideoOptionBuilder setRotateViewAuto(bool rotateViewAuto) {
    this.rotateViewAuto = rotateViewAuto;
    return this;
  }

  /// 一全屏就锁屏横屏，默认false竖屏，可配合setRotateViewAuto使用
  VideoOptionBuilder setLockLand(bool lockLand) {
    this.lockLand = lockLand;
    return this;
  }

  /// 播放速度
  VideoOptionBuilder setSpeed(double speed) {
    this.speed = speed;
    return this;
  }

  /// 变声不变调
  VideoOptionBuilder setSoundTouch(bool soundTouch) {
    sounchTouch = soundTouch;
    return this;
  }

  /// 全屏隐藏虚拟按键，默认打开
  VideoOptionBuilder setHideKey(bool hideKey) {
    this.hideKey = hideKey;
    return this;
  }

  /// 是否可以滑动界面改变进度，声音等
  /// 默认true
  VideoOptionBuilder setIsTouchWiget(bool isTouchWiget) {
    this.isTouchWiget = isTouchWiget;
    return this;
  }

  /// 是否可以全屏滑动界面改变进度，声音等
  /// 默认 true
  VideoOptionBuilder setIsTouchWigetFull(bool isTouchWigetFull) {
    this.isTouchWigetFull = isTouchWigetFull;
    return this;
  }

  /// 是否需要显示流量提示,默认true
  VideoOptionBuilder setNeedShowWifiTip(bool needShowWifiTip) {
    this.needShowWifiTip = needShowWifiTip;
    return this;
  }

  /// 设置右下角 显示切换到全屏 的按键资源
  /// 必须在setUp之前设置
  /// 不设置使用默认
  VideoOptionBuilder setEnlargeImageRes(int enlargeImageRes) {
    this.enlargeImageRes = enlargeImageRes;
    return this;
  }

  /// 设置右下角 显示退出全屏 的按键资源
  /// 必须在setUp之前设置
  /// 不设置使用默认
  VideoOptionBuilder setShrinkImageRes(int shrinkImageRes) {
    this.shrinkImageRes = shrinkImageRes;
    return this;
  }

  /// 是否需要加载显示暂停的cover图片
  /// 打开状态下，暂停退到后台，再回到前台不会显示黑屏，但可以对某些机型有概率出现OOM
  /// 关闭情况下，暂停退到后台，再回到前台显示黑屏
  ///
  /// @param showPauseCover 默认true
  VideoOptionBuilder setShowPauseCover(bool showPauseCover) {
    this.showPauseCover = showPauseCover;
    return this;
  }

  /// 调整触摸滑动快进的比例
  ///
  /// @param seekRatio 滑动快进的比例，默认1。数值越大，滑动的产生的seek越小
  VideoOptionBuilder setSeekRatio(double seekRatio) {
    if (seekRatio < 0) {
      return this;
    }
    this.seekRatio = seekRatio;
    return this;
  }

  /// 是否更新系统旋转，false的话，系统禁止旋转也会跟着旋转
  ///
  /// @param rotateWithSystem 默认true
  VideoOptionBuilder setRotateWithSystem(bool rotateWithSystem) {
    this.rotateWithSystem = rotateWithSystem;
    return this;
  }

  /// 播放tag防止错误，因为普通的url也可能重复
  ///
  /// @param playTag 保证不重复就好
  VideoOptionBuilder setPlayTag(String playTag) {
    this.playTag = playTag;
    return this;
  }

  /// 设置播放位置防止错位
  VideoOptionBuilder setPlayPosition(int playPosition) {
    this.playPosition = playPosition;
    return this;
  }

  /// 从哪里开始播放
  /// 目前有时候前几秒有跳动问题，毫秒
  /// 需要在startPlayLogic之前，即播放开始之前
  VideoOptionBuilder setSeekOnStart(int seekOnStart) {
    this.seekOnStart = seekOnStart;
    return this;
  }

  /// 播放url
  ///
  /// @param url
  VideoOptionBuilder setUrl(String url) {
    this.url = url;
    return this;
  }

  /// 视频title
  ///
  /// @param videoTitle
  VideoOptionBuilder setVideoTitle(String videoTitle) {
    this.videoTitle = videoTitle;
    return this;
  }

  /// 是否边缓存，m3u8等无效
  ///
  /// @param cacheWithPlay
  VideoOptionBuilder setCacheWithPlay(bool cacheWithPlay, String cachePath) {
    this.cacheWithPlay = cacheWithPlay;
    if (this.cacheWithPlay == true) {
      this.cachePath = cachePath;
    }
    return this;
  }

  /// 准备成功之后立即播放
  ///
  /// @param startAfterPrepared 默认true，false的时候需要在prepared后调用startAfterPrepared()
  VideoOptionBuilder setStartAfterPrepared(bool startAfterPrepared) {
    this.startAfterPrepared = startAfterPrepared;
    return this;
  }

  /// 长时间失去音频焦点，暂停播放器
  ///
  /// @param releaseWhenLossAudio 默认true，false的时候只会暂停
  VideoOptionBuilder setReleaseWhenLossAudio(bool releaseWhenLossAudio) {
    this.releaseWhenLossAudio = releaseWhenLossAudio;
    return this;
  }

  /// 自定指定缓存路径，推荐不设置，使用默认路径
  ///
  /// @param cachePath
  VideoOptionBuilder setCachePath(String cachePath) {
    this.cachePath = cachePath;
    return this;
  }

  /// 设置请求的头信息
  ///
  /// @param mapHeadData
  VideoOptionBuilder setMapHeadData(Map<String, String> mapHeadData) {
    this.mapHeadData = mapHeadData;
    return this;
  }

  /// 播放错误时，是否点击触发重试
  VideoOptionBuilder setSurfaceErrorPlay(bool surfaceErrorPlay) {
    this.surfaceErrorPlay = surfaceErrorPlay;
    return this;
  }

  /// 中间进度条字体颜色
  VideoOptionBuilder setDialogProgressColor(int dialogProgressHighLightColor, int dialogProgressNormalColor) {
    this.dialogProgressHighLightColor = dialogProgressHighLightColor;
    this.dialogProgressNormalColor = dialogProgressNormalColor;
    return this;
  }

  /// 是否点击封面可以播放
  VideoOptionBuilder setThumbPlay(bool thumbPlay) {
    this.thumbPlay = thumbPlay;
    return this;
  }

  /// 是否需要全屏锁定屏幕功能
  /// 如果单独使用请设置setIfCurrentIsFullscreen为true
  VideoOptionBuilder setNeedLockFull(bool needLockFull) {
    this.needLockFull = needLockFull;
    return this;
  }

  /// 设置触摸显示控制ui的消失时间
  ///
  /// @param dismissControlTime 毫秒，默认2500
  VideoOptionBuilder setDismissControlTime(int dismissControlTime) {
    this.dismissControlTime = dismissControlTime;
    return this;
  }

  /// 是否需要覆盖拓展类型，目前只针对exoPlayer内核模式有效
  ///
  /// @param overrideExtension 比如传入 m3u8,mp4,avi 等类型
  VideoOptionBuilder setOverrideExtension(String overrideExtension) {
    this.overrideExtension = overrideExtension;
    return this;
  }

  VideoOptionBuilder setOnlyRotateLand(bool isOnlyRotateLand) {
    this.isOnlyRotateLand = isOnlyRotateLand;
    return this;
  }

  VideoOptionBuilder setShowDragProgressTextOnSeekBar(bool isShowDragProgressTextOnSeekBar) {
    this.isShowDragProgressTextOnSeekBar = isShowDragProgressTextOnSeekBar;
    return this;
  }

  VideoOptionBuilder setFullHideActionBar(bool actionBar) {
    this.actionBar = actionBar;
    return this;
  }

  VideoOptionBuilder setFullHideStatusBar(bool statusBar) {
    this.statusBar = statusBar;
    return this;
  }

  /// 是否需要旋转的 OrientationUtils
  ///
  /// @param need 默认 true
  VideoOptionBuilder setNeedOrientationUtils(bool needOrientationUtils) {
    this.needOrientationUtils = needOrientationUtils;
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "playVideoDataSourceType": playVideoDataSourceType.toString(),
      "shrinkImageRes": shrinkImageRes,
      "enlargeImageRes": enlargeImageRes,
      "playPosition": playPosition,
      "dialogProgressHighLightColor": dialogProgressHighLightColor,
      "dialogProgressNormalColor": dialogProgressNormalColor,
      "dismissControlTime": dismissControlTime,
      "seekOnStart": seekOnStart,
      "hideKey": hideKey,
      "showFullAnimation": showFullAnimation,
      "autoFullWithSize": autoFullWithSize,
      "needShowWifiTip": needShowWifiTip,
      "rotateViewAuto": rotateViewAuto,
      "lockLand": lockLand,
      "looping": looping,
      "isTouchWiget": isTouchWiget,
      "isTouchWigetFull": isTouchWigetFull,
      "showPauseCover": showPauseCover,
      "rotateWithSystem": rotateWithSystem,
      "surfaceErrorPlay": surfaceErrorPlay,
      "cacheWithPlay": cacheWithPlay,
      "needLockFull": needLockFull,
      "thumbPlay": thumbPlay,
      "sounchTouch": sounchTouch,
      "startAfterPrepared": startAfterPrepared,
      "releaseWhenLossAudio": releaseWhenLossAudio,
      "actionBar": actionBar,
      "statusBar": statusBar,
      "isShowDragProgressTextOnSeekBar": isShowDragProgressTextOnSeekBar,
      "playTag": playTag,
      "videoTitle": videoTitle,
      "overrideExtension": overrideExtension,
      "isOnlyRotateLand": isOnlyRotateLand,
      "isUseCustomCachePath": isUseCustomCachePath,
      "cachePath": cachePath,
      "mapHeadData": mapHeadData,
      "needOrientationUtils": needOrientationUtils,
    };
  }
}

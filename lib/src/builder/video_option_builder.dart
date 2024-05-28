import 'package:gsy_video_player/src/configuration/play_video_datasource_type.dart';

class VideoOptionBuilder {
  //是否自动播放
  static const bool mAutoPlay = true;
  //退出全屏显示的案件图片

  //播放的tag，防止错误，因为普通的url也可能重复
  static const int mPlayPosition = 0;

  //从哪个开始播放
  static const int mSeekOnStart = -1;

  //播放速度
  static const double mSpeed = 1;

  //循环
  static const bool mLooping = false;

  //边播放边缓存
  static const bool mCacheWithPlay = true;

  //是否需要锁定屏幕
  static const bool mNeedLockFull = true;

  //是否需要变速不变调
  static const bool mSounchTouch = true;

  //Prepared之后是否自动开始播放
  static const bool mStartAfterPrepared = true;

  //是否播放器当失去音频焦点
  static const bool mReleaseWhenLossAudio = true;
  //播放的tag，防止错误，因为普通的url也可能重复
  static const String mPlayTag = "";
  // 是否需要覆盖拓展类型
  static const String mOverrideExtension = "";

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

  // 是否自动播放
  bool? autoPlay;
  //播放的tag，防止错误，因为普通的url也可能重复
  int? playPosition;

  //从哪个开始播放
  int? seekOnStart;
  //触摸滑动进度的比例系数
  double? seekRatio = 1;
  //播放速度
  double? speed = 1;

  //循环
  bool? looping;
  //边播放边缓存
  bool? cacheWithPlay;
  //是否需要变速不变调
  bool? sounchTouch;
  //Prepared之后是否自动开始播放
  bool? startAfterPrepared;
  //是否播放器当失去音频焦点
  bool? releaseWhenLossAudio;
  //播放的tag，防止错误，因为普通的url也可能重复
  String? playTag;

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
    this.autoPlay = mAutoPlay,
    this.playPosition = mPlayPosition,
    this.seekOnStart = mSeekOnStart,
    this.looping = mLooping,
    this.cacheWithPlay = mCacheWithPlay,
    this.sounchTouch = mSounchTouch,
    this.startAfterPrepared = mStartAfterPrepared,
    this.releaseWhenLossAudio = mReleaseWhenLossAudio,
    this.playTag = mPlayTag,
    this.overrideExtension = mOverrideExtension,
    this.isUseCustomCachePath = mIsUseCustomCachePath,
    this.cachePath = mCachePath,
    this.mapHeadData = mMapHeadData,
    this.needOrientationUtils = mNeedOrientationUtils,
    this.seekRatio = 1.0,
    this.speed = mSpeed,
  });

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "playVideoDataSourceType": playVideoDataSourceType?.index,
      "autoPlay": autoPlay,
      "playPosition": playPosition,
      "seekOnStart": seekOnStart,
      "speed": speed,
      "seekRatio": seekRatio,
      "looping": looping,
      "cacheWithPlay": cacheWithPlay,
      "sounchTouch": sounchTouch,
      "startAfterPrepared": startAfterPrepared,
      "releaseWhenLossAudio": releaseWhenLossAudio,
      "playTag": playTag,
      "overrideExtension": overrideExtension,
      "isOnlyRotateLand": isOnlyRotateLand,
      "isUseCustomCachePath": isUseCustomCachePath,
      "cachePath": cachePath,
      "mapHeadData": mapHeadData,
      "needOrientationUtils": needOrientationUtils,
    };
  }
}

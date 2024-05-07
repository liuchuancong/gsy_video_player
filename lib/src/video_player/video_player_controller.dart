import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'video_player_platform_interface.dart';
import 'package:gsy_video_player/gsy_video_player.dart';
import 'package:gsy_video_player/src/constants/log_level.dart';
import 'package:gsy_video_player/src/constants/ijk_option.dart';
import 'package:gsy_video_player/src/video_player/video_event.dart';
import 'package:gsy_video_player/src/constants/video_play_state.dart';
import 'package:gsy_video_player/src/builder/video_option_builder.dart';
import 'package:gsy_video_player/src/configuration/player_video_type.dart';
import 'package:gsy_video_player/src/configuration/player_video_show_type.dart';
import 'package:gsy_video_player/src/configuration/player_video_render_type.dart';
import 'package:gsy_video_player/src/configuration/play_video_datasource_type.dart';

final VideoPlayerPlatform _videoPlayerPlatform = VideoPlayerPlatform.instance;

/// Controls a platform video player, and provides updates when the state is
/// changing.
///
/// Instances must be initialized with initialize.
///
/// The video is displayed in a Flutter app by creating a [GsyVideoPlayer] widget.
///
/// To reclaim the resources used by the player call [dispose].
///
/// After [dispose] all further calls are ignored.
class GsyVideoPlayerController extends ValueNotifier<VideoPlayerValue> {
  /// Constructs a [GsyVideoPlayerController] and creates video controller on platform side.
  GsyVideoPlayerController() : super(VideoPlayerValue(duration: null)) {
    _create();
  }

  final StreamController<VideoEvent> videoEventStreamController = StreamController.broadcast();
  final Completer<void> _creatingCompleter = Completer<void>();

  bool _isDisposed = false;
  late Completer<void> _initializingCompleter;
  StreamSubscription<dynamic>? _eventSubscription;

  bool get _created => _creatingCompleter.isCompleted;

  Future<void> setAssetBuilder(
    String url, {
    int? shrinkImageRes,
    int? enlargeImageRes,
    int? playPosition,
    int? dialogProgressHighLightColor,
    int? dialogProgressNormalColor,
    int? dismissControlTime,
    int? seekOnStart,
    double? seekRatio,
    double? speed,
    bool? hideKey,
    bool? showFullAnimation,
    bool? autoFullWithSize,
    bool? needShowWifiTip,
    bool? rotateViewAuto,
    bool? lockLand,
    bool? looping,
    bool? isTouchWiget,
    bool? isTouchWigetFull,
    bool? showPauseCover,
    bool? rotateWithSystem,
    bool? surfaceErrorPlay,
    bool? cacheWithPlay,
    bool? needLockFull,
    bool? thumbPlay,
    bool? sounchTouch,
    bool? startAfterPrepared,
    bool? releaseWhenLossAudio,
    bool? actionBar,
    bool? statusBar,
    bool? isShowDragProgressTextOnSeekBar,
    String? playTag,
    String? videoTitle,
    String? overrideExtension,
    bool? isOnlyRotateLand,
    bool? isUseCustomCachePath,
    String? cachePath,
    Map<String, String>? mapHeadData,
    bool? needOrientationUtils,
    PlayVideoDataSourceType? playVideoDataSourceType,
    bool? autoPlay,
  }) {
    return _setDataSource(
      VideoOptionBuilder(
        url: url,
        autoPlay: autoPlay ?? VideoOptionBuilder.mAutoPlay,
        shrinkImageRes: shrinkImageRes ?? VideoOptionBuilder.mShrinkImageRes,
        enlargeImageRes: enlargeImageRes ?? VideoOptionBuilder.mEnlargeImageRes,
        playPosition: playPosition ?? VideoOptionBuilder.mPlayPosition,
        dialogProgressHighLightColor: dialogProgressHighLightColor ?? VideoOptionBuilder.mDialogProgressHighLightColor,
        dialogProgressNormalColor: dialogProgressNormalColor ?? VideoOptionBuilder.mDialogProgressNormalColor,
        dismissControlTime: dismissControlTime ?? VideoOptionBuilder.mDismissControlTime,
        seekOnStart: seekOnStart ?? VideoOptionBuilder.mSeekOnStart,
        seekRatio: seekRatio ?? VideoOptionBuilder.mSeekRatio,
        speed: speed ?? VideoOptionBuilder.mSpeed,
        hideKey: hideKey ?? VideoOptionBuilder.mHideKey,
        showFullAnimation: showFullAnimation ?? VideoOptionBuilder.mShowFullAnimation,
        autoFullWithSize: autoFullWithSize ?? VideoOptionBuilder.mAutoFullWithSize,
        needShowWifiTip: needShowWifiTip ?? VideoOptionBuilder.mNeedShowWifiTip,
        rotateViewAuto: rotateViewAuto ?? VideoOptionBuilder.mRotateViewAuto,
        lockLand: lockLand ?? VideoOptionBuilder.mLockLand,
        looping: looping ?? VideoOptionBuilder.mLooping,
        isTouchWiget: isTouchWiget ?? VideoOptionBuilder.mIsTouchWiget,
        isTouchWigetFull: isTouchWigetFull ?? VideoOptionBuilder.mIsTouchWigetFull,
        showPauseCover: showPauseCover ?? VideoOptionBuilder.mShowPauseCover,
        rotateWithSystem: rotateWithSystem ?? VideoOptionBuilder.mRotateWithSystem,
        surfaceErrorPlay: surfaceErrorPlay ?? VideoOptionBuilder.mSurfaceErrorPlay,
        cacheWithPlay: cacheWithPlay ?? VideoOptionBuilder.mCacheWithPlay,
        needLockFull: needLockFull ?? VideoOptionBuilder.mNeedLockFull,
        thumbPlay: thumbPlay ?? VideoOptionBuilder.mThumbPlay,
        sounchTouch: sounchTouch ?? VideoOptionBuilder.mSounchTouch,
        startAfterPrepared: startAfterPrepared ?? VideoOptionBuilder.mStartAfterPrepared,
        releaseWhenLossAudio: releaseWhenLossAudio ?? VideoOptionBuilder.mReleaseWhenLossAudio,
        actionBar: actionBar ?? VideoOptionBuilder.mActionBar,
        statusBar: statusBar ?? VideoOptionBuilder.mStatusBar,
        isShowDragProgressTextOnSeekBar:
            isShowDragProgressTextOnSeekBar ?? VideoOptionBuilder.mShowDragProgressTextOnSeekBar,
        playTag: playTag ?? VideoOptionBuilder.mPlayTag,
        videoTitle: videoTitle ?? VideoOptionBuilder.mVideoTitle,
        overrideExtension: overrideExtension ?? VideoOptionBuilder.mOverrideExtension,
        isOnlyRotateLand: isOnlyRotateLand ?? VideoOptionBuilder.mIsOnlyRotateLand,
        isUseCustomCachePath: isUseCustomCachePath ?? VideoOptionBuilder.mIsUseCustomCachePath,
        cachePath: cachePath ?? VideoOptionBuilder.mCachePath,
        mapHeadData: mapHeadData ?? VideoOptionBuilder.mMapHeadData,
        needOrientationUtils: needOrientationUtils ?? VideoOptionBuilder.mNeedOrientationUtils,
        playVideoDataSourceType: PlayVideoDataSourceType.asset,
      ),
    );
  }

  Future<void> setNetWorkBuilder(
    String url, {
    bool? autoPlay,
    int? shrinkImageRes,
    int? enlargeImageRes,
    int? playPosition,
    int? dialogProgressHighLightColor,
    int? dialogProgressNormalColor,
    int? dismissControlTime,
    int? seekOnStart,
    double? seekRatio,
    double? speed,
    bool? hideKey,
    bool? showFullAnimation,
    bool? autoFullWithSize,
    bool? needShowWifiTip,
    bool? rotateViewAuto,
    bool? lockLand,
    bool? looping,
    bool? isTouchWiget,
    bool? isTouchWigetFull,
    bool? showPauseCover,
    bool? rotateWithSystem,
    bool? surfaceErrorPlay,
    bool? cacheWithPlay,
    bool? needLockFull,
    bool? thumbPlay,
    bool? sounchTouch,
    bool? startAfterPrepared,
    bool? releaseWhenLossAudio,
    bool? actionBar,
    bool? statusBar,
    bool? isShowDragProgressTextOnSeekBar,
    String? playTag,
    String? videoTitle,
    String? overrideExtension,
    bool? isOnlyRotateLand,
    bool? isUseCustomCachePath,
    String? cachePath,
    Map<String, String>? mapHeadData,
    bool? needOrientationUtils,
    PlayVideoDataSourceType? playVideoDataSourceType,
  }) {
    return _setDataSource(
      VideoOptionBuilder(
        url: url,
        autoPlay: autoPlay ?? VideoOptionBuilder.mAutoPlay,
        shrinkImageRes: shrinkImageRes ?? VideoOptionBuilder.mShrinkImageRes,
        enlargeImageRes: enlargeImageRes ?? VideoOptionBuilder.mEnlargeImageRes,
        playPosition: playPosition ?? VideoOptionBuilder.mPlayPosition,
        dialogProgressHighLightColor: dialogProgressHighLightColor ?? VideoOptionBuilder.mDialogProgressHighLightColor,
        dialogProgressNormalColor: dialogProgressNormalColor ?? VideoOptionBuilder.mDialogProgressNormalColor,
        dismissControlTime: dismissControlTime ?? VideoOptionBuilder.mDismissControlTime,
        seekOnStart: seekOnStart ?? VideoOptionBuilder.mSeekOnStart,
        seekRatio: seekRatio ?? VideoOptionBuilder.mSeekRatio,
        speed: speed ?? VideoOptionBuilder.mSpeed,
        hideKey: hideKey ?? VideoOptionBuilder.mHideKey,
        showFullAnimation: showFullAnimation ?? VideoOptionBuilder.mShowFullAnimation,
        autoFullWithSize: autoFullWithSize ?? VideoOptionBuilder.mAutoFullWithSize,
        needShowWifiTip: needShowWifiTip ?? VideoOptionBuilder.mNeedShowWifiTip,
        rotateViewAuto: rotateViewAuto ?? VideoOptionBuilder.mRotateViewAuto,
        lockLand: lockLand ?? VideoOptionBuilder.mLockLand,
        looping: looping ?? VideoOptionBuilder.mLooping,
        isTouchWiget: isTouchWiget ?? VideoOptionBuilder.mIsTouchWiget,
        isTouchWigetFull: isTouchWigetFull ?? VideoOptionBuilder.mIsTouchWigetFull,
        showPauseCover: showPauseCover ?? VideoOptionBuilder.mShowPauseCover,
        rotateWithSystem: rotateWithSystem ?? VideoOptionBuilder.mRotateWithSystem,
        surfaceErrorPlay: surfaceErrorPlay ?? VideoOptionBuilder.mSurfaceErrorPlay,
        cacheWithPlay: cacheWithPlay ?? VideoOptionBuilder.mCacheWithPlay,
        needLockFull: needLockFull ?? VideoOptionBuilder.mNeedLockFull,
        thumbPlay: thumbPlay ?? VideoOptionBuilder.mThumbPlay,
        sounchTouch: sounchTouch ?? VideoOptionBuilder.mSounchTouch,
        startAfterPrepared: startAfterPrepared ?? VideoOptionBuilder.mStartAfterPrepared,
        releaseWhenLossAudio: releaseWhenLossAudio ?? VideoOptionBuilder.mReleaseWhenLossAudio,
        actionBar: actionBar ?? VideoOptionBuilder.mActionBar,
        statusBar: statusBar ?? VideoOptionBuilder.mStatusBar,
        isShowDragProgressTextOnSeekBar:
            isShowDragProgressTextOnSeekBar ?? VideoOptionBuilder.mShowDragProgressTextOnSeekBar,
        playTag: playTag ?? VideoOptionBuilder.mPlayTag,
        videoTitle: videoTitle ?? VideoOptionBuilder.mVideoTitle,
        overrideExtension: overrideExtension ?? VideoOptionBuilder.mOverrideExtension,
        isOnlyRotateLand: isOnlyRotateLand ?? VideoOptionBuilder.mIsOnlyRotateLand,
        isUseCustomCachePath: isUseCustomCachePath ?? VideoOptionBuilder.mIsUseCustomCachePath,
        cachePath: cachePath ?? VideoOptionBuilder.mCachePath,
        mapHeadData: mapHeadData ?? VideoOptionBuilder.mMapHeadData,
        needOrientationUtils: needOrientationUtils ?? VideoOptionBuilder.mNeedOrientationUtils,
        playVideoDataSourceType: PlayVideoDataSourceType.network,
      ),
    );
  }

  Future<void> setFileBuilder(
    String url, {
    bool? autoPlay,
    int? shrinkImageRes,
    int? enlargeImageRes,
    int? playPosition,
    int? dialogProgressHighLightColor,
    int? dialogProgressNormalColor,
    int? dismissControlTime,
    int? seekOnStart,
    double? seekRatio,
    double? speed,
    bool? hideKey,
    bool? showFullAnimation,
    bool? autoFullWithSize,
    bool? needShowWifiTip,
    bool? rotateViewAuto,
    bool? lockLand,
    bool? looping,
    bool? isTouchWiget,
    bool? isTouchWigetFull,
    bool? showPauseCover,
    bool? rotateWithSystem,
    bool? surfaceErrorPlay,
    bool? cacheWithPlay,
    bool? needLockFull,
    bool? thumbPlay,
    bool? sounchTouch,
    bool? startAfterPrepared,
    bool? releaseWhenLossAudio,
    bool? actionBar,
    bool? statusBar,
    bool? isShowDragProgressTextOnSeekBar,
    String? playTag,
    String? videoTitle,
    String? overrideExtension,
    bool? isOnlyRotateLand,
    bool? isUseCustomCachePath,
    String? cachePath,
    Map<String, String>? mapHeadData,
    bool? needOrientationUtils,
    PlayVideoDataSourceType? playVideoDataSourceType,
  }) {
    return _setDataSource(
      VideoOptionBuilder(
        url: url,
        autoPlay: autoPlay ?? VideoOptionBuilder.mAutoPlay,
        shrinkImageRes: shrinkImageRes ?? VideoOptionBuilder.mShrinkImageRes,
        enlargeImageRes: enlargeImageRes ?? VideoOptionBuilder.mEnlargeImageRes,
        playPosition: playPosition ?? VideoOptionBuilder.mPlayPosition,
        dialogProgressHighLightColor: dialogProgressHighLightColor ?? VideoOptionBuilder.mDialogProgressHighLightColor,
        dialogProgressNormalColor: dialogProgressNormalColor ?? VideoOptionBuilder.mDialogProgressNormalColor,
        dismissControlTime: dismissControlTime ?? VideoOptionBuilder.mDismissControlTime,
        seekOnStart: seekOnStart ?? VideoOptionBuilder.mSeekOnStart,
        seekRatio: seekRatio ?? VideoOptionBuilder.mSeekRatio,
        speed: speed ?? VideoOptionBuilder.mSpeed,
        hideKey: hideKey ?? VideoOptionBuilder.mHideKey,
        showFullAnimation: showFullAnimation ?? VideoOptionBuilder.mShowFullAnimation,
        autoFullWithSize: autoFullWithSize ?? VideoOptionBuilder.mAutoFullWithSize,
        needShowWifiTip: needShowWifiTip ?? VideoOptionBuilder.mNeedShowWifiTip,
        rotateViewAuto: rotateViewAuto ?? VideoOptionBuilder.mRotateViewAuto,
        lockLand: lockLand ?? VideoOptionBuilder.mLockLand,
        looping: looping ?? VideoOptionBuilder.mLooping,
        isTouchWiget: isTouchWiget ?? VideoOptionBuilder.mIsTouchWiget,
        isTouchWigetFull: isTouchWigetFull ?? VideoOptionBuilder.mIsTouchWigetFull,
        showPauseCover: showPauseCover ?? VideoOptionBuilder.mShowPauseCover,
        rotateWithSystem: rotateWithSystem ?? VideoOptionBuilder.mRotateWithSystem,
        surfaceErrorPlay: surfaceErrorPlay ?? VideoOptionBuilder.mSurfaceErrorPlay,
        cacheWithPlay: cacheWithPlay ?? VideoOptionBuilder.mCacheWithPlay,
        needLockFull: needLockFull ?? VideoOptionBuilder.mNeedLockFull,
        thumbPlay: thumbPlay ?? VideoOptionBuilder.mThumbPlay,
        sounchTouch: sounchTouch ?? VideoOptionBuilder.mSounchTouch,
        startAfterPrepared: startAfterPrepared ?? VideoOptionBuilder.mStartAfterPrepared,
        releaseWhenLossAudio: releaseWhenLossAudio ?? VideoOptionBuilder.mReleaseWhenLossAudio,
        actionBar: actionBar ?? VideoOptionBuilder.mActionBar,
        statusBar: statusBar ?? VideoOptionBuilder.mStatusBar,
        isShowDragProgressTextOnSeekBar:
            isShowDragProgressTextOnSeekBar ?? VideoOptionBuilder.mShowDragProgressTextOnSeekBar,
        playTag: playTag ?? VideoOptionBuilder.mPlayTag,
        videoTitle: videoTitle ?? VideoOptionBuilder.mVideoTitle,
        overrideExtension: overrideExtension ?? VideoOptionBuilder.mOverrideExtension,
        isOnlyRotateLand: isOnlyRotateLand ?? VideoOptionBuilder.mIsOnlyRotateLand,
        isUseCustomCachePath: isUseCustomCachePath ?? VideoOptionBuilder.mIsUseCustomCachePath,
        cachePath: cachePath ?? VideoOptionBuilder.mCachePath,
        mapHeadData: mapHeadData ?? VideoOptionBuilder.mMapHeadData,
        needOrientationUtils: needOrientationUtils ?? VideoOptionBuilder.mNeedOrientationUtils,
        playVideoDataSourceType: PlayVideoDataSourceType.file,
      ),
    );
  }

  /// Attempts to open the given [dataSource] and load metadata about the video.
  Future<void> _create() async {
    await _videoPlayerPlatform.create();
    _creatingCompleter.complete(null);
    unawaited(_applyVolume());
    setEventListener();
  }

  void setEventListener() {
    void eventListener(VideoEvent event) {
      if (_isDisposed) {
        return;
      }
      videoEventStreamController.add(event);
      switch (event.eventType) {
        case VideoEventType.initialized:
          value = value.copyWith(
            duration: event.duration,
            size: event.size,
          );
          _initializingCompleter.complete(null);
          _applyPlayPause();
          break;
        case VideoEventType.onEventStartPrepared:
          value = value.copyWith(isPlaying: false);
          break;
        case VideoEventType.onEventPrepared:
          value = value.copyWith(isPlaying: false);
          break;
        case VideoEventType.onEventClickStartIcon:
          value = value.copyWith(isPlaying: true);
          break;
        case VideoEventType.onEventClickStartError:
          break;
        case VideoEventType.onEventClickStop:
          value = value.copyWith(isPlaying: false);
          break;
        case VideoEventType.onEventClickStopFullscreen:
          break;
        case VideoEventType.onEventClickResume:
          value = value.copyWith(isPlaying: true);
          break;
        case VideoEventType.onEventClickResumeFullscreen:
          value = value.copyWith(isPlaying: true);
          break;
        case VideoEventType.onEventClickSeekbar:
          break;
        case VideoEventType.onEventClickSeekbarFullscreen:
          break;
        case VideoEventType.onEventAutoComplete:
          break;
        case VideoEventType.onEventEnterFullscreen:
          break;
        case VideoEventType.onEventQuitFullscreen:
          value = value.copyWith(isPlaying: true);
          break;
        case VideoEventType.onEventQuitSmallWidget:
          break;
        case VideoEventType.onEventEnterSmallWidget:
          break;
        case VideoEventType.onEventTouchScreenSeekVolume:
          break;
        case VideoEventType.onEventTouchScreenSeekPosition:
          break;
        case VideoEventType.onEventTouchScreenSeekLight:
          break;
        case VideoEventType.onEventPlayError:
          value = value.copyWith(isPlaying: false);
          break;
        case VideoEventType.onEventClickStartThumb:
          break;
        case VideoEventType.onEventClickBlank:
          break;
        case VideoEventType.onEventClickBlankFullscreen:
          break;
        case VideoEventType.onEventComplete:
          value = value.copyWith(isPlaying: false);
          break;
        case VideoEventType.onEventProgress:
          final int position = event.position!.inMilliseconds;
          final int duration = event.duration!.inMilliseconds;
          value = value.copyWith(
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
          );
          break;
        case VideoEventType.onListenerPrepared:
          value = value.copyWith(isPlaying: false);
          break;
        case VideoEventType.onListenerAutoCompletion:
          value = value.copyWith(isPlaying: false, position: value.duration);
          break;
        case VideoEventType.onListenerCompletion:
          value = value.copyWith(isPlaying: false, position: value.duration);
          break;
        case VideoEventType.onListenerBufferingUpdate:
          value = value.copyWith(buffered: event.buffered);
          break;
        case VideoEventType.onListenerSeekComplete:
          value = value.copyWith(isPlaying: true, position: value.position);
          break;
        case VideoEventType.onListenerError:
          value = value.copyWith(isPlaying: false, what: event.what, extra: event.extra);
          break;
        case VideoEventType.onListenerInfo:
          value = value.copyWith(isPlaying: true, what: event.what, extra: event.extra);
          break;
        case VideoEventType.onListenerVideoSizeChanged:
          value = value.copyWith(isPlaying: true);
          break;
        case VideoEventType.onListenerBackFullscreen:
          break;
        case VideoEventType.onListenerVideoPause:
          pause();
          break;
        case VideoEventType.onListenerVideoResume:
          onResume();
          break;
        case VideoEventType.onListenerVideoResumeWithSeek:
          onResume();
          break;
        case VideoEventType.unknown:
          break;
      }
    }

    void errorListener(Object object) {
      if (object is PlatformException) {
        final PlatformException e = object;
        value = value.copyWith(errorDescription: e.message);
      } else {
        value.copyWith(errorDescription: object.toString());
      }
      if (!_initializingCompleter.isCompleted) {
        _initializingCompleter.completeError(object);
      }
    }

    _eventSubscription = _videoPlayerPlatform.videoEventsFor().listen(eventListener, onError: errorListener);
  }

  Future<void> _setDataSource(VideoOptionBuilder builder) async {
    if (_isDisposed) {
      return;
    }
    value = VideoPlayerValue(
      duration: null,
      isLooping: value.isLooping,
      volume: value.volume,
    );

    if (!_creatingCompleter.isCompleted) await _creatingCompleter.future;

    _initializingCompleter = Completer<void>();

    await VideoPlayerPlatform.instance.setVideoOptionBuilder(builder);
    return _initializingCompleter.future;
  }

  @override
  Future<void> dispose() async {
    await _creatingCompleter.future;
    if (!_isDisposed) {
      _isDisposed = true;
      value = VideoPlayerValue.uninitialized();
      await _eventSubscription?.cancel();
      await _videoPlayerPlatform.dispose();
      videoEventStreamController.close();
    }
    _isDisposed = true;
    super.dispose();
  }

  Future<void> setVideoOptionBuilder(VideoOptionBuilder builder) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setVideoOptionBuilder(builder);
  }

  Future<int> getLayoutId() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getLayoutId();
  }

  Future<void> startPlayLogic() async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: true);
    await _videoPlayerPlatform.startPlayLogic();
  }

  Future<void> setUp(
    String url,
    bool cacheWithPlay,
    String cachePath,
    String title,
  ) async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: false);
    await _videoPlayerPlatform.setUp(url, cacheWithPlay, cachePath, title);
  }

  Future<void> onVideoPause() async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: false);
    await _videoPlayerPlatform.onVideoPause();
  }

  Future<void> onVideoResume() async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: true);
    await _videoPlayerPlatform.onVideoResume();
  }

  Future<void> clearCurrentCache() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.clearCurrentCache();
  }

  Future<int> getCurrentPositionWhenPlaying(bool looping) async {
    return await _videoPlayerPlatform.getCurrentPositionWhenPlaying();
  }

  Future<void> releaseAllVideos() async {
    await _videoPlayerPlatform.releaseAllVideos();
  }

  Future<VideoPlayState> getCurrentState() async {
    return await _videoPlayerPlatform.getCurrentState();
  }

  Future<void> setPlayTag(String tag) async {
    await _videoPlayerPlatform.setPlayTag(tag);
  }

  Future<void> setPlayPosition(int position) async {
    await _videoPlayerPlatform.setPlayPosition(position);
  }

  Future<void> backFromWindowFull() async {
    await _videoPlayerPlatform.backFromWindowFull();
  }

  Future<int> getNetSpeed() async {
    return await _videoPlayerPlatform.getNetSpeed();
  }

  Future<String> getNetSpeedText() async {
    return await _videoPlayerPlatform.getNetSpeedText();
  }

  Future<void> setSeekOnStart(int msec) async {
    await _videoPlayerPlatform.setSeekOnStart(msec);
  }

  Future<int> getBuffterPoint() async {
    return await _videoPlayerPlatform.getBuffterPoint();
  }

  Future<GsyVideoPlayerType> setCurrentPlayer(GsyVideoPlayerType playerType) async {
    return await _videoPlayerPlatform.setCurrentPlayer(playerType);
  }

  Future<void> getPlayManager() async {
    await _videoPlayerPlatform.getPlayManager();
  }

  Future<void> setExoCacheManager() async {
    await _videoPlayerPlatform.setExoCacheManager();
  }

  Future<void> setProxyCacheManager() async {
    await _videoPlayerPlatform.setProxyCacheManager();
  }

  Future<void> clearAllDefaultCache() async {
    await _videoPlayerPlatform.clearAllDefaultCache();
  }

  Future<void> clearDefaultCache(String cacheDir, String url) async {
    await _videoPlayerPlatform.clearDefaultCache(cacheDir, url);
  }

  Future<void> releaseMediaPlayer() async {
    await _videoPlayerPlatform.releaseMediaPlayer();
  }

  Future<void> onPause() async {
    await _videoPlayerPlatform.onPause();
  }

  Future<void> onResume() async {
    await _videoPlayerPlatform.onResume();
  }

  Future<String> getPlayTag() async {
    return await _videoPlayerPlatform.getPlayTag();
  }

  Future<int> getPlayPosition() async {
    return await _videoPlayerPlatform.getPlayPosition();
  }

  Future<List<IjkOption>> getOptionModelList() async {
    return await _videoPlayerPlatform.getOptionModelList();
  }

  Future<void> setOptionModelList(List<IjkOption> optionModelList) async {
    await _videoPlayerPlatform.setOptionModelList(optionModelList);
  }

  Future<bool> isNeedMute() async {
    return await _videoPlayerPlatform.isNeedMute();
  }

  Future<void> setNeedMute(bool needMute) async {
    await _videoPlayerPlatform.setNeedMute(needMute);
  }

  Future<int> getTimeOut() async {
    return await _videoPlayerPlatform.getTimeOut();
  }

  Future<bool> isNeedTimeOutOther() async {
    return await _videoPlayerPlatform.isNeedTimeOutOther();
  }

  Future<void> setTimeOut(int timeOut, {bool needTimeOutOther = false}) async {
    await _videoPlayerPlatform.setTimeOut(timeOut, needTimeOutOther: needTimeOutOther);
  }

  Future<void> setLogLevel(LogLevel level) async {
    await _videoPlayerPlatform.setLogLevel(level);
  }

  Future<bool> isMediaCodec() async {
    return await _videoPlayerPlatform.isMediaCodec();
  }

  Future<double> getScreenScaleRatio() async {
    return await _videoPlayerPlatform.getScreenScaleRatio();
  }

  Future<void> setScreenScaleRatio(double ratio) async {
    await _videoPlayerPlatform.setScreenScaleRatio(ratio);
  }

  Future<bool> isMediaCodecTexture() async {
    return await _videoPlayerPlatform.isMediaCodecTexture();
  }

  Future<PlayerVideoShowType> getShowType() async {
    return await _videoPlayerPlatform.getShowType();
  }

  Future<void> setShowType(PlayerVideoShowType showType, {double screenScaleRatio = 0.0}) async {
    await _videoPlayerPlatform.setShowType(showType, screenScaleRatio: screenScaleRatio);
  }

  Future<GsyVideoPlayerRenderType> getRenderType() async {
    return await _videoPlayerPlatform.getRenderType();
  }

  Future<void> setRenderType(GsyVideoPlayerRenderType renderType) async {
    await _videoPlayerPlatform.setRenderType(renderType);
  }

  Future<void> setMediaCodec(bool mediaCodec) async {
    await _videoPlayerPlatform.setMediaCodec(mediaCodec);
  }

  Future<void> setMediaCodecTexture(bool mediaCodecTexture) async {
    await _videoPlayerPlatform.setMediaCodecTexture(mediaCodecTexture);
  }

  Future<void> startWindowFullscreen(bool showActionBar, bool showStatusBar) async {
    await _videoPlayerPlatform.startWindowFullscreen(showActionBar, showStatusBar);
  }

  Future<void> showSmallVideo(Size size, bool showActionBar, bool showStatusBar) async {
    await _videoPlayerPlatform.showSmallVideo(size, showActionBar, showStatusBar);
  }

  Future<void> hideSmallVideo() async {
    await _videoPlayerPlatform.hideSmallVideo();
  }

  Future<bool> isShowFullAnimation() async {
    return await _videoPlayerPlatform.isShowFullAnimation();
  }

  Future<void> setShowFullAnimation(bool showFullAnimation) async {
    await _videoPlayerPlatform.setShowFullAnimation(showFullAnimation);
  }

  Future<bool> isRotateViewAuto() async {
    return await _videoPlayerPlatform.isRotateViewAuto();
  }

  Future<void> setRotateViewAuto(bool rotateViewAuto) async {
    await _videoPlayerPlatform.setRotateViewAuto(rotateViewAuto);
  }

  Future<bool> isLockLand() async {
    return await _videoPlayerPlatform.isLockLand();
  }

  Future<void> setLockLand(bool lockLand) async {
    await _videoPlayerPlatform.setLockLand(lockLand);
  }

  Future<bool> isRotateWithSystem() async {
    return await _videoPlayerPlatform.isRotateWithSystem();
  }

  Future<void> setRotateWithSystem(bool rotateWithSystem) async {
    await _videoPlayerPlatform.setRotateWithSystem(rotateWithSystem);
  }

  Future<void> initUIState() async {
    await _videoPlayerPlatform.initUIState();
  }

  Future<int> getEnlargeImageRes() async {
    return await _videoPlayerPlatform.getEnlargeImageRes();
  }

  Future<void> setEnlargeImageRes(int res) async {
    await _videoPlayerPlatform.setEnlargeImageRes(res);
  }

  Future<int> getShrinkImageRes() async {
    return await _videoPlayerPlatform.getShrinkImageRes();
  }

  Future<void> setShrinkImageRes(int res) async {
    await _videoPlayerPlatform.setShrinkImageRes(res);
  }

  Future<void> setIsTouchWigetFull(bool isTouchWigetFull) async {
    await _videoPlayerPlatform.setIsTouchWigetFull(isTouchWigetFull);
  }

  Future<bool> getIsTouchWigetFull() async {
    return await _videoPlayerPlatform.getIsTouchWigetFull();
  }

  Future<void> setThumbPlay(bool thumbPlay) async {
    await _videoPlayerPlatform.setThumbPlay(thumbPlay);
  }

  Future<bool> isHideKeyBoard() async {
    return await _videoPlayerPlatform.isHideKeyBoard();
  }

  Future<void> setHideKeyBoard(bool hideKeyBoard) async {
    await _videoPlayerPlatform.setHideKeyBoard(hideKeyBoard);
  }

  Future<bool> isNeedShowWifiTip() async {
    return await _videoPlayerPlatform.isNeedShowWifiTip();
  }

  Future<void> setNeedShowWifiTip(bool needShowWifiTip) async {
    await _videoPlayerPlatform.setNeedShowWifiTip(needShowWifiTip);
  }

  Future<bool> isTouchWiget() async {
    return await _videoPlayerPlatform.isTouchWiget();
  }

  Future<void> setTouchWiget(bool touchWiget) async {
    await _videoPlayerPlatform.setTouchWiget(touchWiget);
  }

  Future<void> setSeekRatio(double ratio) async {
    await _videoPlayerPlatform.setSeekRatio(ratio);
  }

  Future<double> getSeekRatio() async {
    return await _videoPlayerPlatform.getSeekRatio();
  }

  Future<bool> isNeedLockFull() async {
    return await _videoPlayerPlatform.isNeedLockFull();
  }

  Future<void> setNeedLockFull(bool needLockFull) async {
    await _videoPlayerPlatform.setNeedLockFull(needLockFull);
  }

  Future<void> setDismissControlTime(int msec) async {
    await _videoPlayerPlatform.setDismissControlTime(msec);
  }

  Future<int> getDismissControlTime() async {
    return await _videoPlayerPlatform.getDismissControlTime();
  }

  Future<int> getSeekOnStart() async {
    return await _videoPlayerPlatform.getSeekOnStart();
  }

  Future<bool> isIfCurrentIsFullscreen() async {
    return await _videoPlayerPlatform.isIfCurrentIsFullscreen();
  }

  Future<void> setIfCurrentIsFullscreen(bool ifCurrentIsFullscreen) async {
    await _videoPlayerPlatform.setIfCurrentIsFullscreen(ifCurrentIsFullscreen);
  }

  Future<bool> isLooping() async {
    return await _videoPlayerPlatform.isLooping();
  }

  Future<void> setLooping(bool looping) async {
    value = value.copyWith(isLooping: looping);
    await _applyLooping();
  }

  Future<double> getSpeed() async {
    return await _videoPlayerPlatform.getSpeed();
  }

  Future<void> setSpeed(double speed) async {
    value = value.copyWith(speed: speed);
    await _applySpeed();
  }

  Future<void> setSpeedPlaying(double speed, {bool soundTouch = true}) async {
    await _videoPlayerPlatform.setSpeedPlaying(speed, soundTouch: soundTouch);
  }

  Future<bool> isShowPauseCover() async {
    return await _videoPlayerPlatform.isShowPauseCover();
  }

  Future<void> setShowPauseCover(bool showPauseCover) async {
    await _videoPlayerPlatform.setShowPauseCover(showPauseCover);
  }

  Future<void> seekTo(double msec) async {
    await _videoPlayerPlatform.seekTo(msec);
  }

  Future<void> setMatrixGL(List<double> matrix) async {
    await _videoPlayerPlatform.setMatrixGL(matrix);
  }

  Future<void> releaseWhenLossAudio() async {
    await _videoPlayerPlatform.releaseWhenLossAudio();
  }

  Future<void> setReleaseWhenLossAudio(bool releaseWhenLossAudio) async {
    await _videoPlayerPlatform.setReleaseWhenLossAudio(releaseWhenLossAudio);
  }

  Future<void> setAutoFullWithSize(bool releaseWhenLossAudio) async {
    await _videoPlayerPlatform.setAutoFullWithSize(releaseWhenLossAudio);
  }

  Future<bool> getAutoFullWithSize() async {
    return await _videoPlayerPlatform.getAutoFullWithSize();
  }

  // "isHideKeyBoard" -> {
  //               customBasicApi.isHideKeyBoard(call, result)
  //           }

  //           "setHideKeyBoard" -> {
  //               customBasicApi.setHideKeyBoard(call, result)
  //           }

  //           "isNeedShowWifiTip" -> {
  //               customBasicApi.isNeedShowWifiTip(call, result)
  //           }

  //           "setNeedShowWifiTip" -> {
  //               customBasicApi.setNeedShowWifiTip(call, result)
  //           }

  //           "isTouchWiget" -> {
  //               customBasicApi.isTouchWiget(call, result)
  //           }

  //           "setTouchWiget" -> {
  //               customBasicApi.setTouchWiget(call, result)
  //           }

  //           "setSeekRatio" -> {
  //               customBasicApi.setSeekRatio(call, result)
  //           }

  //           "getSeekRatio" -> {
  //               customBasicApi.getSeekRatio(call, result)
  //           }

  //           "isNeedLockFull" -> {
  //               customBasicApi.isNeedLockFull(call, result)
  //           }

  //           "setNeedLockFull" -> {
  //               customBasicApi.setNeedLockFull(call, result)
  //           }

  //           "setDismissControlTime" -> {
  //               customBasicApi.setDismissControlTime(call, result)
  //           }

  //           "getDismissControlTime" ->{
  //               customBasicApi.getDismissControlTime(call, result)
  //           }

  //           "getSeekOnStart" -> {
  //               customBasicApi.getSeekOnStart(call, result)
  //           }

  //           "isIfCurrentIsFullscreen" -> {
  //               customBasicApi.isIfCurrentIsFullscreen(call, result)
  //           }

  //           "setIfCurrentIsFullscreen" -> {
  //               customBasicApi.setIfCurrentIsFullscreen(call, result)
  //           }

  //           "isLooping" -> {
  //               customBasicApi.isLooping(call, result)
  //           }

  //           "setLooping" -> {
  //               customBasicApi.setLooping(call, result)
  //           }

  //           "getSpeed" -> {
  //               customBasicApi.getSpeed(call, result)
  //           }

  //           "setSpeed" -> {
  //               customBasicApi.setSpeed(call, result)
  //           }

  //           "setSpeedPlaying" -> {
  //               customBasicApi.setSpeedPlaying(call, result)
  //           }

  //           "isShowPauseCover" -> {
  //               customBasicApi.isShowPauseCover(call, result)
  //           }

  //           "setShowPauseCover" -> {
  //               customBasicApi.setShowPauseCover(call, result)
  //           }

  //           "seekTo" -> {
  //               customBasicApi.seekTo(call, result)
  //           }

  //           "setMatrixGL" -> {
  //               customBasicApi.setMatrixGL(call, result)
  //           }

  //           "releaseWhenLossAudio" -> {
  //               customBasicApi.releaseWhenLossAudio(call, result)
  //           }

  //           "setReleaseWhenLossAudio" -> {
  //               customBasicApi.setReleaseWhenLossAudio(call, result)
  //           }

  //           "setAutoFullWithSize" -> {
  //               customBasicApi.setAutoFullWithSize(call, result)
  //           }

  //           "getAutoFullWithSize" -> {
  //               customBasicApi.getAutoFullWithSize(call, result)
  //           }

  /// Pauses the video.
  Future<void> pause() async {
    value = value.copyWith(isPlaying: false);
    await _applyPlayPause();
  }

  /// resume the video.
  Future<void> resume() async {
    value = value.copyWith(isPlaying: true);
    await _applyPlayPause();
  }

  Future<void> _applyLooping() async {
    if (!_created || _isDisposed) {
      return;
    }
    await _videoPlayerPlatform.setLooping(value.isLooping);
  }

  Future<void> _applyPlayPause() async {
    if (!_created || _isDisposed) {
      return;
    }
    if (value.isPlaying) {
      await _videoPlayerPlatform.onPause();
    } else {
      await _videoPlayerPlatform.onResume();
    }
  }

  Future<void> _applyVolume() async {
    if (!_created || _isDisposed) {
      return;
    }
    await _videoPlayerPlatform.setVolume(value.volume);
  }

  Future<void> _applySpeed() async {
    if (!_created || _isDisposed) {
      return;
    }
    await _videoPlayerPlatform.setSpeed(value.speed);
  }

  /// The position in the current video.
  Future<int?> get position async {
    if (!value.initialized && _isDisposed) {
      return null;
    }
    return await _videoPlayerPlatform.getPlayPosition();
  }

  /// Sets the audio volume of [this].
  ///
  /// [volume] indicates a value between 0.0 (silent) and 1.0 (full volume) on a
  /// linear scale.
  Future<void> setVolume(double volume) async {
    value = value.copyWith(volume: volume.clamp(0.0, 1.0));
    await _applyVolume();
  }

  void refresh() {
    value = value.copyWith();
  }
}

/// Widget that displays the video controlled by [controller].
class GsyVideoPlayer extends StatelessWidget {
  /// Uses the given [controller] for all video rendered in this widget.

  final GsyVideoPlayerController? controller;

  const GsyVideoPlayer({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return _videoPlayerPlatform.buildView();
  }
}

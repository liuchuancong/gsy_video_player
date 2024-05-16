import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsy_video_player/gsy_video_player.dart';

VideoPlayerPlatform? _lastVideoPlayerPlatform;

VideoPlayerPlatform get _videoPlayerPlatform {
  final VideoPlayerPlatform currentInstance = VideoPlayerPlatform.instance;
  if (_lastVideoPlayerPlatform != currentInstance) {
    // This will clear all open videos on the platform when a full restart is
    // performed.
    currentInstance.init();
    _lastVideoPlayerPlatform = currentInstance;
  }
  return currentInstance;
}

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
  GsyVideoPlayerController({this.danmakuSettings = const DanmakuSettings()}) : super(VideoPlayerValue(duration: null)) {
    _create();
  }

  static const int kUninitializedTextureId = -1;
  int _textureId = kUninitializedTextureId;
  int get textureId => _textureId;
  final DanmakuSettings danmakuSettings;

  /// Initializes the video controller on platform side.

  final StreamController<VideoEvent> videoEventStreamController = StreamController.broadcast();

  late final DanmakuController _danmakuController;

  DanmakuController get danmakuController => _danmakuController;

  ///StreamSubscription for VideoEvent listener
  StreamSubscription<VideoEvent>? _videoEventStreamSubscription;

  final Completer<void> _creatingCompleter = Completer<void>();

  bool _isDisposed = false;

  late Completer<void> _initializingCompleter;

  StreamSubscription<dynamic>? _eventSubscription;

  _VideoAppLifeCycleObserver? _lifeCycleObserver;

  bool get _created => _creatingCompleter.isCompleted;

  ///List of event listeners, which listen to events.
  final List<Function(VideoEventType)?> _eventListeners = [];

  ///Expose all active eventListeners
  List<Function(VideoEventType)?> get eventListeners => _eventListeners.sublist(1);

  Future _initializeVideo() async {
    _videoEventStreamSubscription?.cancel();
    _videoEventStreamSubscription = null;
    _videoEventStreamSubscription = videoEventStreamController.stream.listen(_handleVideoEvent);
  }

  Future<void> _create() async {
    final bool allowBackgroundPlayback = value.allowBackgroundPlayback;
    if (!allowBackgroundPlayback) {
      _lifeCycleObserver = _VideoAppLifeCycleObserver(this);
    }
    _lifeCycleObserver?.initialize();
    _textureId = (await _videoPlayerPlatform.create()) ?? kUninitializedTextureId;
    _creatingCompleter.complete(null);
    setEventListener();
  }

  ///Send player event. Shouldn't be used manually.
  void postEvent(VideoEventType eventType) {
    _postEvent(eventType);
  }

  ///Send player event to all listeners.
  void _postEvent(VideoEventType eventType) {
    for (final Function(VideoEventType)? eventListener in _eventListeners) {
      if (eventListener != null) {
        eventListener(eventType);
      }
    }
  }

  ///Add event listener which listens to player events.
  void addEventsListener(Function(VideoEventType) eventListener) {
    _eventListeners.add(eventListener);
  }

  ///Remove event listener. This method should be called once you're disposing
  ///Better Player.
  void removeEventsListener(Function(VideoEventType) eventListener) {
    _eventListeners.remove(eventListener);
  }

  ///Handle VideoEvent when remote controls notification / PiP is shown
  void _handleVideoEvent(VideoEvent event) async {
    /// The video has been initialized.
    switch (event.eventType) {
      case VideoEventType.initialized:
        _postEvent(VideoEventType.initialized);
        break;
      case VideoEventType.onFullButtonClick:
        _postEvent(VideoEventType.onFullButtonClick);
      case VideoEventType.videoPlayerInitialized:
        _postEvent(VideoEventType.videoPlayerInitialized);
        break;
      case VideoEventType.onEventStartPrepared:
        _postEvent(VideoEventType.onEventStartPrepared);
        break;
      case VideoEventType.onEventPrepared:
        _postEvent(VideoEventType.onEventPrepared);
        break;

      case VideoEventType.onEventClickStartIcon:
        _postEvent(VideoEventType.onEventClickStartIcon);
        break;

      case VideoEventType.onEventClickStartError:
        _postEvent(VideoEventType.onEventClickStartError);
        break;

      case VideoEventType.onEventClickStop:
        _postEvent(VideoEventType.onEventClickStop);
        break;

      case VideoEventType.onEventClickStopFullscreen:
        _postEvent(VideoEventType.onEventClickStopFullscreen);
        break;

      case VideoEventType.onEventClickResume:
        _postEvent(VideoEventType.onEventClickResume);
        break;

      case VideoEventType.onEventClickResumeFullscreen:
        _postEvent(VideoEventType.onEventClickResumeFullscreen);
        break;

      case VideoEventType.onEventClickSeekbar:
        _postEvent(VideoEventType.onEventClickSeekbar);
        break;

      case VideoEventType.onEventClickSeekbarFullscreen:
        _postEvent(VideoEventType.onEventClickSeekbarFullscreen);
        break;

      case VideoEventType.onEventAutoComplete:
        _postEvent(VideoEventType.onEventAutoComplete);
        break;

      case VideoEventType.onEventEnterFullscreen:
        _postEvent(VideoEventType.onEventEnterFullscreen);
        break;

      case VideoEventType.onEventQuitFullscreen:
        _postEvent(VideoEventType.onEventQuitFullscreen);
        break;

      case VideoEventType.onEventQuitSmallWidget:
        _postEvent(VideoEventType.onEventQuitSmallWidget);
        break;

      case VideoEventType.onEventEnterSmallWidget:
        _postEvent(VideoEventType.onEventEnterSmallWidget);
        break;

      case VideoEventType.onEventTouchScreenSeekVolume:
        _postEvent(VideoEventType.onEventTouchScreenSeekVolume);
        break;

      case VideoEventType.onEventTouchScreenSeekPosition:
        _postEvent(VideoEventType.onEventTouchScreenSeekPosition);
        break;

      case VideoEventType.onEventTouchScreenSeekLight:
        _postEvent(VideoEventType.onEventTouchScreenSeekLight);
        break;

      case VideoEventType.onEventPlayError:
        _postEvent(VideoEventType.onEventPlayError);
        break;

      case VideoEventType.onEventClickStartThumb:
        _postEvent(VideoEventType.onEventClickStartThumb);
        break;

      case VideoEventType.onEventClickBlank:
        _postEvent(VideoEventType.onEventClickBlank);
        break;

      case VideoEventType.onEventClickBlankFullscreen:
        _postEvent(VideoEventType.onEventClickBlankFullscreen);
        break;

      case VideoEventType.onEventComplete:
        _postEvent(VideoEventType.onEventComplete);
        break;

      case VideoEventType.onEventProgress:
        _postEvent(VideoEventType.onEventProgress);
        break;

      case VideoEventType.onListenerPrepared:
        _postEvent(VideoEventType.onListenerPrepared);
        break;

      case VideoEventType.onListenerAutoCompletion:
        _postEvent(VideoEventType.onListenerAutoCompletion);
        break;

      case VideoEventType.onListenerCompletion:
        _postEvent(VideoEventType.onListenerCompletion);
        break;

      case VideoEventType.onListenerBufferingUpdate:
        _postEvent(VideoEventType.onListenerBufferingUpdate);
        break;

      case VideoEventType.onListenerSeekComplete:
        _postEvent(VideoEventType.onListenerSeekComplete);
        break;

      case VideoEventType.onListenerError:
        _postEvent(VideoEventType.onListenerError);
        break;

      case VideoEventType.onListenerInfo:
        _postEvent(VideoEventType.onListenerInfo);
        break;

      case VideoEventType.onListenerVideoSizeChanged:
        _postEvent(VideoEventType.onListenerVideoSizeChanged);
        break;

      case VideoEventType.onListenerBackFullscreen:
        _postEvent(VideoEventType.onListenerBackFullscreen);
        break;

      case VideoEventType.onListenerVideoPause:
        _postEvent(VideoEventType.onListenerVideoPause);
        break;
      case VideoEventType.onListenerVideoResume:
        _postEvent(VideoEventType.onListenerVideoResume);
        break;
      case VideoEventType.onListenerVideoResumeWithSeek:
        _postEvent(VideoEventType.onListenerVideoResumeWithSeek);
        break;
      case VideoEventType.onListenerInitDanmakuSuccess:
        _postEvent(VideoEventType.onListenerInitDanmakuSuccess);
        break;
      case VideoEventType.unknown:
        _postEvent(VideoEventType.unknown);
        break;
      default:
        _postEvent(VideoEventType.unknown);
        break;
    }
  }

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

  void setEventListener() async {
    void eventListener(VideoEvent event) async {
      if (_isDisposed) {
        return;
      }
      videoEventStreamController.add(event);
      switch (event.eventType) {
        case VideoEventType.initialized:
          value = value.copyWith(
            duration: event.duration,
            rotationCorrection: event.rotationCorrection,
            isInitialized: event.duration != null,
            isCompleted: false,
          );
          _initializingCompleter.complete(null);
          break;
        case VideoEventType.onFullButtonClick:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            isFullScreen: true,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.videoPlayerInitialized:
          value = value.copyWith(
            videoPlayerInitialized: true,
          );
          _danmakuController = DanmakuController(this);
          _danmakuController.initDanmaku();
          unawaited(_applyVolume());
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
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onListenerConfigurationChanged:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onListenerPrepared:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onListenerAutoCompletion:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onListenerCompletion:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onListenerBufferingUpdate:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            buffered: event.buffered,
            percent: event.percent,
          );
          break;
        case VideoEventType.onListenerSeekComplete:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onListenerError:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            what: event.what,
            extra: event.extra,
          );
          break;
        case VideoEventType.onListenerInfo:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            what: event.what,
            extra: event.extra,
          );
          break;
        case VideoEventType.onListenerVideoSizeChanged:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onListenerBackFullscreen:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onListenerVideoPause:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onListenerVideoResume:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onListenerVideoResumeWithSeek:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            position: Duration(milliseconds: event.position!.inMilliseconds),
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            seek: value.seek,
          );
          break;
        case VideoEventType.onListenerInitDanmakuSuccess:
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

    _eventSubscription = _videoPlayerPlatform.videoEventsFor(_textureId).listen(eventListener, onError: errorListener);
    await _initializeVideo();
  }

  Future<void> _setDataSource(VideoOptionBuilder builder) async {
    await _creatingCompleter.future;
    if (_isDisposed) {
      return;
    }
    value = VideoPlayerValue(
      duration: null,
      isLooping: value.isLooping,
      volume: value.volume,
    );
    await VideoPlayerPlatform.instance.setVideoOptionBuilder(textureId, builder);
  }

  @override
  Future<void> dispose() async {
    await _creatingCompleter.future;
    if (!_isDisposed) {
      _isDisposed = true;
      value = VideoPlayerValue.uninitialized();
      await _eventSubscription?.cancel();
      await _videoPlayerPlatform.dispose(_textureId);
      videoEventStreamController.close();
      _videoEventStreamSubscription?.cancel();
      _eventListeners.clear();
    }
    _isDisposed = true;
    super.dispose();
  }

  Future<void> setVideoOptionBuilder(VideoOptionBuilder builder) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setVideoOptionBuilder(textureId, builder);
  }

  Future<int> getLayoutId() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getLayoutId(textureId);
  }

  Future<void> startPlayLogic() async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: true);
    await _videoPlayerPlatform.startPlayLogic(_textureId);
  }

  Future<void> setUp(
    String url,
    bool cacheWithPlay,
    String cachePath,
    String title,
  ) async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: false);
    await _videoPlayerPlatform.setUp(_textureId, url, cacheWithPlay, cachePath, title);
  }

  Future<void> onVideoPause() async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: false);
    await _videoPlayerPlatform.onVideoPause(_textureId);
  }

  Future<void> onVideoResume() async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: true);
    await _videoPlayerPlatform.onVideoResume(_textureId);
  }

  Future<void> clearCurrentCache() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.clearCurrentCache(_textureId);
  }

  Future<int> getCurrentPositionWhenPlaying(bool looping) async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getCurrentPositionWhenPlaying(_textureId);
  }

  Future<void> releaseAllVideos() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.releaseAllVideos(_textureId);
  }

  Future<VideoPlayState> getCurrentState() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getCurrentState(_textureId);
  }

  Future<void> setPlayTag(String tag) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setPlayTag(_textureId, tag);
  }

  Future<void> setPlayPosition(int position) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setPlayPosition(_textureId, position);
  }

  Future<void> backFromWindowFull() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.backFromWindowFull(_textureId);
  }

  Future<int> getNetSpeed() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getNetSpeed(_textureId);
  }

  Future<String> getNetSpeedText() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getNetSpeedText(_textureId);
  }

  Future<void> setSeekOnStart(int msec) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setSeekOnStart(_textureId, msec);
  }

  Future<int> getBuffterPoint() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getBuffterPoint(_textureId);
  }

  Future<GsyVideoPlayerType> setCurrentPlayer(GsyVideoPlayerType playerType) async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.setCurrentPlayer(_textureId, playerType);
  }

  Future<void> getPlayManager() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.getPlayManager(_textureId);
  }

  Future<void> setExoCacheManager() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setExoCacheManager(_textureId);
  }

  Future<void> setProxyCacheManager() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setProxyCacheManager(_textureId);
  }

  Future<void> clearAllDefaultCache() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.clearAllDefaultCache(_textureId);
  }

  Future<void> clearDefaultCache(String cacheDir, String url) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.clearDefaultCache(_textureId, cacheDir, url);
  }

  Future<void> releaseMediaPlayer() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.releaseMediaPlayer(_textureId);
  }

  Future<void> onPause() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.onPause(_textureId);
  }

  Future<void> onResume() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.onResume(_textureId);
  }

  Future<String> getPlayTag() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getPlayTag(_textureId);
  }

  Future<int> getPlayPosition() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getPlayPosition(_textureId);
  }

  Future<List<IjkOption>> getOptionModelList() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getOptionModelList(_textureId);
  }

  Future<void> setOptionModelList(List<IjkOption> optionModelList) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOptionModelList(_textureId, optionModelList);
  }

  Future<bool> isNeedMute() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isNeedMute(_textureId);
  }

  Future<void> setNeedMute(bool needMute) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setNeedMute(_textureId, needMute);
  }

  Future<int> getTimeOut() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getTimeOut(_textureId);
  }

  Future<bool> isNeedTimeOutOther() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isNeedTimeOutOther(_textureId);
  }

  Future<void> setTimeOut(int timeOut, {bool needTimeOutOther = false}) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setTimeOut(_textureId, timeOut, needTimeOutOther: needTimeOutOther);
  }

  Future<void> setLogLevel(LogLevel level) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setLogLevel(_textureId, level);
  }

  Future<bool> isMediaCodec() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isMediaCodec(_textureId);
  }

  Future<double> getScreenScaleRatio() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getScreenScaleRatio(_textureId);
  }

  Future<void> setScreenScaleRatio(double ratio) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setScreenScaleRatio(_textureId, ratio);
  }

  Future<bool> isMediaCodecTexture() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isMediaCodecTexture(_textureId);
  }

  Future<PlayerVideoShowType> getShowType() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getShowType(_textureId);
  }

  Future<void> setShowType(PlayerVideoShowType showType, {double screenScaleRatio = 0.0}) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setShowType(_textureId, showType, screenScaleRatio: screenScaleRatio);
  }

  Future<GsyVideoPlayerRenderType> getRenderType() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getRenderType(_textureId);
  }

  Future<void> setRenderType(GsyVideoPlayerRenderType renderType) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setRenderType(_textureId, renderType);
  }

  Future<void> setMediaCodec(bool mediaCodec) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMediaCodec(_textureId, mediaCodec);
  }

  Future<void> setMediaCodecTexture(bool mediaCodecTexture) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMediaCodecTexture(_textureId, mediaCodecTexture);
  }

  Future<void> startWindowFullscreen(bool showActionBar, bool showStatusBar) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.startWindowFullscreen(_textureId, showActionBar, showStatusBar);
  }

  Future<void> showSmallVideo(Size size, bool showActionBar, bool showStatusBar) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.showSmallVideo(_textureId, size, showActionBar, showStatusBar);
  }

  Future<void> hideSmallVideo() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.hideSmallVideo(_textureId);
  }

  Future<bool> isShowFullAnimation() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isShowFullAnimation(_textureId);
  }

  Future<void> setShowFullAnimation(bool showFullAnimation) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setShowFullAnimation(_textureId, showFullAnimation);
  }

  Future<bool> isRotateViewAuto() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isRotateViewAuto(_textureId);
  }

  Future<void> setRotateViewAuto(bool rotateViewAuto) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setRotateViewAuto(_textureId, rotateViewAuto);
  }

  Future<bool> isLockLand() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isLockLand(_textureId);
  }

  Future<void> setLockLand(bool lockLand) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setLockLand(_textureId, lockLand);
  }

  Future<bool> isRotateWithSystem() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isRotateWithSystem(_textureId);
  }

  Future<void> setRotateWithSystem(bool rotateWithSystem) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setRotateWithSystem(_textureId, rotateWithSystem);
  }

  Future<void> initUIState() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.initUIState(_textureId);
  }

  Future<int> getEnlargeImageRes() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getEnlargeImageRes(_textureId);
  }

  Future<void> setEnlargeImageRes(int res) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setEnlargeImageRes(_textureId, res);
  }

  Future<int> getShrinkImageRes() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getShrinkImageRes(_textureId);
  }

  Future<void> setShrinkImageRes(int res) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setShrinkImageRes(_textureId, res);
  }

  Future<void> setIsTouchWigetFull(bool isTouchWigetFull) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setIsTouchWigetFull(_textureId, isTouchWigetFull);
  }

  Future<bool> getIsTouchWigetFull() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getIsTouchWigetFull(_textureId);
  }

  Future<void> setThumbPlay(bool thumbPlay) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setThumbPlay(_textureId, thumbPlay);
  }

  Future<bool> isHideKeyBoard() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isHideKeyBoard(_textureId);
  }

  Future<void> setHideKeyBoard(bool hideKeyBoard) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setHideKeyBoard(_textureId, hideKeyBoard);
  }

  Future<bool> isNeedShowWifiTip() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isNeedShowWifiTip(_textureId);
  }

  Future<void> setNeedShowWifiTip(bool needShowWifiTip) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setNeedShowWifiTip(_textureId, needShowWifiTip);
  }

  Future<bool> isTouchWiget() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isTouchWiget(_textureId);
  }

  Future<void> setTouchWiget(bool touchWiget) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setTouchWiget(_textureId, touchWiget);
  }

  Future<void> setSeekRatio(double ratio) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setSeekRatio(_textureId, ratio);
  }

  Future<double> getSeekRatio() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getSeekRatio(_textureId);
  }

  Future<bool> isNeedLockFull() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isNeedLockFull(_textureId);
  }

  Future<void> setNeedLockFull(bool needLockFull) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setNeedLockFull(_textureId, needLockFull);
  }

  Future<void> setDismissControlTime(int msec) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDismissControlTime(_textureId, msec);
  }

  Future<int> getDismissControlTime() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getDismissControlTime(_textureId);
  }

  Future<int> getSeekOnStart() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getSeekOnStart(_textureId);
  }

  Future<bool> isIfCurrentIsFullscreen() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isIfCurrentIsFullscreen(_textureId);
  }

  Future<void> setIfCurrentIsFullscreen(bool ifCurrentIsFullscreen) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setIfCurrentIsFullscreen(_textureId, ifCurrentIsFullscreen);
  }

  Future<bool> isLooping() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isLooping(_textureId);
  }

  Future<void> setLooping(bool looping) async {
    await _creatingCompleter.future;
    value = value.copyWith(isLooping: looping);
    await _applyLooping();
  }

  Future<double> getSpeed() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getSpeed(_textureId);
  }

  Future<void> setSpeed(double speed) async {
    await _creatingCompleter.future;
    value = value.copyWith(speed: speed);
    await _applySpeed();
  }

  Future<void> setSpeedPlaying(double speed, {bool soundTouch = true}) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setSpeedPlaying(_textureId, speed, soundTouch: soundTouch);
  }

  Future<bool> isShowPauseCover() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isShowPauseCover(textureId);
  }

  Future<void> setShowPauseCover(bool showPauseCover) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setShowPauseCover(_textureId, showPauseCover);
  }

  Future<void> seekTo(Duration msec) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.seekTo(_textureId, msec.inMilliseconds);
  }

  Future<void> setMatrixGL(List<double> matrix) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMatrixGL(_textureId, matrix);
  }

  Future<void> releaseWhenLossAudio() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.releaseWhenLossAudio(_textureId);
  }

  Future<void> setReleaseWhenLossAudio(bool releaseWhenLossAudio) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setReleaseWhenLossAudio(_textureId, releaseWhenLossAudio);
  }

  Future<void> setAutoFullWithSize(bool releaseWhenLossAudio) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setAutoFullWithSize(_textureId, releaseWhenLossAudio);
  }

  Future<bool> getAutoFullWithSize() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getAutoFullWithSize(_textureId);
  }

  /// Pauses the video.
  Future<void> pause() async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: false);
    await _videoPlayerPlatform.onVideoPause(_textureId);
  }

  /// resume the video.
  Future<void> resume() async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: true);
    await _applyPlayPause();
  }

  Future<void> _applyLooping() async {
    await _creatingCompleter.future;
    if (!_created || _isDisposed) {
      return;
    }
    await _videoPlayerPlatform.setLooping(_textureId, value.isLooping);
  }

  playOrPause() {
    if (value.isPlaying) {
      value = value.copyWith(isPlaying: false);
    } else {
      value = value.copyWith(isPlaying: true);
    }
    _applyPlayPause();
  }

  Future<void> _applyPlayPause() async {
    await _creatingCompleter.future;
    if (!_created || _isDisposed) {
      return;
    }
    if (value.isPlaying) {
      await _videoPlayerPlatform.onResume(_textureId);
    } else {
      await _videoPlayerPlatform.onPause(_textureId);
    }
  }

  Future<void> _applyVolume() async {
    await _creatingCompleter.future;
    if (!_created || _isDisposed) {
      return;
    }
    await _videoPlayerPlatform.setVolume(_textureId, value.volume);
  }

  Future<void> _applySpeed() async {
    await _creatingCompleter.future;
    if (!_created || _isDisposed) {
      return;
    }
    await _videoPlayerPlatform.setSpeed(_textureId, value.speed);
  }

  /// The position in the current video.
  Future<int?> get position async {
    await _creatingCompleter.future;
    if (!value.initialized && _isDisposed) {
      return null;
    }
    return await _videoPlayerPlatform.getPlayPosition(_textureId);
  }

  Future<void> initDanmaku({required DanmakuSettings settings}) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.initDanmaku(_textureId, settings: settings);
  }

  Future<void> showDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.showDanmaku(_textureId);
  }

  Future<bool> getDanmakuShow() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getDanmakuShow(_textureId);
  }

  Future<void> hideDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.hideDanmaku(_textureId);
  }

  Future<void> setDanmakuStyle(DanmakuStyle danmakuStyle,
      {double danmuStyleShadow = 0.0,
      double danmuStyleStroked = 0.0,
      double danmuStyleProjectionOffsetX = 0.0,
      double danmuStyleProjectionOffsetY = 0.0,
      double danmuStyleProjectionAlpha = 255.0}) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDanmakuStyle(_textureId, danmakuStyle,
        danmuStyleShadow: danmuStyleShadow,
        danmuStyleStroked: danmuStyleStroked,
        danmuStyleProjectionOffsetX: danmuStyleProjectionOffsetX,
        danmuStyleProjectionOffsetY: danmuStyleProjectionOffsetY,
        danmuStyleProjectionAlpha: danmuStyleProjectionAlpha.clamp(0.0, 255.0));
  }

  Future<void> setDanmakuBold(bool bold) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDanmakuBold(_textureId, bold);
  }

  Future<void> setScrollSpeedFactor(double speedFactor) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setScrollSpeedFactor(_textureId, speedFactor);
  }

  Future<void> setDuplicateMergingEnabled(bool enabled) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDuplicateMergingEnabled(_textureId, enabled);
  }

  Future<void> setMaximumLines(Map<DanmakuTypeScroll, int> maxLinesPair) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMaximumLines(_textureId, maxLinesPair);
  }

  Future<void> preventOverlapping(Map<DanmakuTypeScroll, bool> preventPair) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.preventOverlapping(_textureId, preventPair);
  }

  Future<void> setMarginTop(double marginTop) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMarginTop(_textureId, marginTop);
  }

  Future<void> setDanmakuTransparency(double transparency) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDanmakuTransparency(_textureId, transparency);
  }

  Future<void> setDanmakuMargin(double margin) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDanmakuMargin(_textureId, margin);
  }

  Future<void> setScaleTextSize(double scale) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setScaleTextSize(_textureId, scale);
  }

  Future<void> setMaximumVisibleSizeInScreen(MaximumVisibleSizeInScreen maximumVisibleSizeInScreen) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMaximumVisibleSizeInScreen(_textureId, maximumVisibleSizeInScreen);
  }

  Future<void> addDanmaku(BaseDanmaku danmaku) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.addDanmaku(_textureId, danmaku);
  }

  Future<void> startDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.startDanmaku(_textureId);
  }

  Future<void> pauseDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.pauseDanmaku(_textureId);
  }

  Future<void> resumeDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.resumeDanmaku(_textureId);
  }

  Future<void> stopDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.stopDanmaku(_textureId);
  }

  Future<void> seekToDanmaku(Duration msec) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.seekToDanmaku(_textureId, msec);
  }

  Future<Map<String, dynamic>> getDanmakuStatus() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getDanmakuStatus(_textureId);
  }

  /// Sets the audio volume of [this].
  ///
  /// [volume] indicates a value between 0.0 (silent) and 1.0 (full volume) on a
  /// linear scale.
  Future<void> setVolume(double volume) async {
    await _creatingCompleter.future;
    value = value.copyWith(volume: volume.clamp(0.0, 1.0));
    await _applyVolume();
  }

  Future<void> resolveByClick() {
    return _videoPlayerPlatform.resolveByClick(_textureId);
  }

  Future<void> backToProtVideo() {
    return _videoPlayerPlatform.backToProtVideo(_textureId);
  }

  Future<bool> isOrientationRotateEnable() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateEnable(_textureId);
  }

  Future<void> setOrientationRotateEnable(bool enable) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateEnable(_textureId, enable);
  }

  Future<bool> getOrientationRotateIsLand() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getOrientationRotateIsLand(_textureId);
  }

  Future<void> setOrientationRotateLand(bool isLand) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateLand(_textureId, isLand);
  }

  Future<OrientationScreenType> getOrientationRotateScreenType() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getOrientationRotateScreenType(_textureId);
  }

  Future<void> setOrientationRotateScreenType(OrientationScreenType screenType) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateScreenType(_textureId, screenType);
  }

  Future<bool> isOrientationRotateClick() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateClick(_textureId);
  }

  Future<void> setOrientationRotateIsClick(bool isClick) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateIsClick(_textureId, isClick);
  }

  Future<bool> isOrientationRotateClickLand() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateClickLand(_textureId);
  }

  Future<void> setOrientationRotateIsClickLand(bool isClickLand) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateIsClickLand(_textureId, isClickLand);
  }

  Future<bool> isOrientationRotateClickPort() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateClickPort(_textureId);
  }

  Future<void> setOrientationRotateIslickPort(bool islickPort) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateIslickPort(_textureId, islickPort);
  }

  Future<bool> isOrientationRotatePause() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotatePause(_textureId);
  }

  Future<void> setOrientationRotateIsPause(bool isPause) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateIsPause(_textureId, isPause);
  }

  Future<bool> isOrientationRotateOnlyRotateLand() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateOnlyRotateLand(_textureId);
  }

  Future<void> setOrientationRotateIsOnlyRotateLand(bool isOnlyRotateLand) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateIsOnlyRotateLand(_textureId, isOnlyRotateLand);
  }

  Future<bool> isOrientationRotateWithSystem() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateWithSystem(_textureId);
  }

  Future<void> setOrientationRotateWithSystem(bool isRotateWithSystem) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateWithSystem(_textureId, isRotateWithSystem);
  }

  Future<void> releaseOrientationListener() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.releaseOrientationListener(_textureId);
  }

  void onEnterFullScreen() {
    setIfCurrentIsFullscreen(true);
    value = value.copyWith(isFullScreen: true);
  }

  void onExitFullScreen() {
    setIfCurrentIsFullscreen(false);
    value = value.copyWith(isFullScreen: false);
  }

  void refresh() {
    value = value.copyWith();
  }
}

/// Widget that displays the video controlled by [controller].
class GsyVideoPlayer extends StatefulWidget {
  /// Uses the given [controller] for all video rendered in this widget.
  ///
  final GsyVideoPlayerController controller;

  const GsyVideoPlayer({super.key, required this.controller, this.onViewReady});

  final void Function(int)? onViewReady;

  @override
  State<GsyVideoPlayer> createState() => _GsyVideoPlayerState();
}

class _GsyVideoPlayerState extends State<GsyVideoPlayer> {
  _GsyVideoPlayerState() {
    _listener = () {
      final int newTextureId = widget.controller.textureId;
      if (newTextureId != _textureId) {
        setState(() {
          _textureId = newTextureId;
        });
      }
    };
  }

  late VoidCallback _listener;

  late int _textureId;

  @override
  void initState() {
    super.initState();
    _textureId = widget.controller.textureId;
    widget.onViewReady?.call(_textureId);
    // Need to listen for initialization events since the actual texture ID
    // becomes available after asynchronous initialization finishes.
    widget.controller.addListener(_listener);
  }

  @override
  void didUpdateWidget(GsyVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(_listener);
    _textureId = widget.controller.textureId;
    widget.controller.addListener(_listener);
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.controller.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return _textureId == GsyVideoPlayerController.kUninitializedTextureId
        ? Container()
        : _VideoPlayerWithRotation(
            rotation: widget.controller.value.rotationCorrection,
            child: _videoPlayerPlatform.buildView(_textureId),
          );
  }
}

class _VideoPlayerWithRotation extends StatelessWidget {
  const _VideoPlayerWithRotation({required this.rotation, required this.child});
  final int rotation;
  final Widget child;

  @override
  Widget build(BuildContext context) => rotation == 0
      ? child
      : Transform.rotate(
          angle: rotation * math.pi / 180,
          child: child,
        );
}

class _VideoAppLifeCycleObserver extends Object with WidgetsBindingObserver {
  _VideoAppLifeCycleObserver(this._controller);

  bool _wasPlayingBeforePause = false;
  final GsyVideoPlayerController _controller;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasPlayingBeforePause = _controller.value.isPlaying;
      _controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (_wasPlayingBeforePause) {
        _controller.resume();
      }
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}

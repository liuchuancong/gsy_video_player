import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsy_video_player/gsy_video_player.dart';

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
  GsyVideoPlayerController({this.danmakuSettings = const DanmakuSettings()}) : super(VideoPlayerValue(duration: null)) {
    _create();
  }

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

  /// Attempts to open the given [dataSource] and load metadata about the video.
  Future<void> _create() async {
    await _videoPlayerPlatform.initialized.future;
    await _videoPlayerPlatform.create();
    _creatingCompleter.complete(null);
    _initializingCompleter = Completer<void>();
    setEventListener();
  }

  void setEventListener() async {
    void eventListener(VideoEvent event) async {
      if (_isDisposed) {
        return;
      }
      videoEventStreamController.add(event);
      switch (event.eventType) {
        case VideoEventType.initialized:
          value = value.copyWith(isInitialized: true);
          _initializingCompleter.complete(null);
          _danmakuController = DanmakuController(this);
          _danmakuController.initDanmaku();
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

    _eventSubscription = _videoPlayerPlatform.videoEventsFor().listen(eventListener, onError: errorListener);
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
    await VideoPlayerPlatform.instance.setVideoOptionBuilder(builder);
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
      _videoEventStreamSubscription?.cancel();
      _eventListeners.clear();
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
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getCurrentPositionWhenPlaying();
  }

  Future<void> releaseAllVideos() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.releaseAllVideos();
  }

  Future<VideoPlayState> getCurrentState() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getCurrentState();
  }

  Future<void> setPlayTag(String tag) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setPlayTag(tag);
  }

  Future<void> setPlayPosition(int position) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setPlayPosition(position);
  }

  Future<void> backFromWindowFull() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.backFromWindowFull();
  }

  Future<int> getNetSpeed() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getNetSpeed();
  }

  Future<String> getNetSpeedText() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getNetSpeedText();
  }

  Future<void> setSeekOnStart(int msec) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setSeekOnStart(msec);
  }

  Future<int> getBuffterPoint() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getBuffterPoint();
  }

  Future<GsyVideoPlayerType> setCurrentPlayer(GsyVideoPlayerType playerType) async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.setCurrentPlayer(playerType);
  }

  Future<void> getPlayManager() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.getPlayManager();
  }

  Future<void> setExoCacheManager() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setExoCacheManager();
  }

  Future<void> setProxyCacheManager() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setProxyCacheManager();
  }

  Future<void> clearAllDefaultCache() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.clearAllDefaultCache();
  }

  Future<void> clearDefaultCache(String cacheDir, String url) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.clearDefaultCache(cacheDir, url);
  }

  Future<void> releaseMediaPlayer() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.releaseMediaPlayer();
  }

  Future<void> onPause() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.onPause();
  }

  Future<void> onResume() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.onResume();
  }

  Future<String> getPlayTag() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getPlayTag();
  }

  Future<int> getPlayPosition() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getPlayPosition();
  }

  Future<List<IjkOption>> getOptionModelList() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getOptionModelList();
  }

  Future<void> setOptionModelList(List<IjkOption> optionModelList) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOptionModelList(optionModelList);
  }

  Future<bool> isNeedMute() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isNeedMute();
  }

  Future<void> setNeedMute(bool needMute) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setNeedMute(needMute);
  }

  Future<int> getTimeOut() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getTimeOut();
  }

  Future<bool> isNeedTimeOutOther() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isNeedTimeOutOther();
  }

  Future<void> setTimeOut(int timeOut, {bool needTimeOutOther = false}) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setTimeOut(timeOut, needTimeOutOther: needTimeOutOther);
  }

  Future<void> setLogLevel(LogLevel level) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setLogLevel(level);
  }

  Future<bool> isMediaCodec() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isMediaCodec();
  }

  Future<double> getScreenScaleRatio() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getScreenScaleRatio();
  }

  Future<void> setScreenScaleRatio(double ratio) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setScreenScaleRatio(ratio);
  }

  Future<bool> isMediaCodecTexture() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isMediaCodecTexture();
  }

  Future<PlayerVideoShowType> getShowType() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getShowType();
  }

  Future<void> setShowType(PlayerVideoShowType showType, {double screenScaleRatio = 0.0}) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setShowType(showType, screenScaleRatio: screenScaleRatio);
  }

  Future<GsyVideoPlayerRenderType> getRenderType() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getRenderType();
  }

  Future<void> setRenderType(GsyVideoPlayerRenderType renderType) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setRenderType(renderType);
  }

  Future<void> setMediaCodec(bool mediaCodec) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMediaCodec(mediaCodec);
  }

  Future<void> setMediaCodecTexture(bool mediaCodecTexture) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMediaCodecTexture(mediaCodecTexture);
  }

  Future<void> startWindowFullscreen(bool showActionBar, bool showStatusBar) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.startWindowFullscreen(showActionBar, showStatusBar);
  }

  Future<void> showSmallVideo(Size size, bool showActionBar, bool showStatusBar) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.showSmallVideo(size, showActionBar, showStatusBar);
  }

  Future<void> hideSmallVideo() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.hideSmallVideo();
  }

  Future<bool> isShowFullAnimation() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isShowFullAnimation();
  }

  Future<void> setShowFullAnimation(bool showFullAnimation) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setShowFullAnimation(showFullAnimation);
  }

  Future<bool> isRotateViewAuto() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isRotateViewAuto();
  }

  Future<void> setRotateViewAuto(bool rotateViewAuto) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setRotateViewAuto(rotateViewAuto);
  }

  Future<bool> isLockLand() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isLockLand();
  }

  Future<void> setLockLand(bool lockLand) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setLockLand(lockLand);
  }

  Future<bool> isRotateWithSystem() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isRotateWithSystem();
  }

  Future<void> setRotateWithSystem(bool rotateWithSystem) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setRotateWithSystem(rotateWithSystem);
  }

  Future<void> initUIState() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.initUIState();
  }

  Future<int> getEnlargeImageRes() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getEnlargeImageRes();
  }

  Future<void> setEnlargeImageRes(int res) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setEnlargeImageRes(res);
  }

  Future<int> getShrinkImageRes() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getShrinkImageRes();
  }

  Future<void> setShrinkImageRes(int res) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setShrinkImageRes(res);
  }

  Future<void> setIsTouchWigetFull(bool isTouchWigetFull) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setIsTouchWigetFull(isTouchWigetFull);
  }

  Future<bool> getIsTouchWigetFull() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getIsTouchWigetFull();
  }

  Future<void> setThumbPlay(bool thumbPlay) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setThumbPlay(thumbPlay);
  }

  Future<bool> isHideKeyBoard() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isHideKeyBoard();
  }

  Future<void> setHideKeyBoard(bool hideKeyBoard) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setHideKeyBoard(hideKeyBoard);
  }

  Future<bool> isNeedShowWifiTip() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isNeedShowWifiTip();
  }

  Future<void> setNeedShowWifiTip(bool needShowWifiTip) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setNeedShowWifiTip(needShowWifiTip);
  }

  Future<bool> isTouchWiget() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isTouchWiget();
  }

  Future<void> setTouchWiget(bool touchWiget) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setTouchWiget(touchWiget);
  }

  Future<void> setSeekRatio(double ratio) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setSeekRatio(ratio);
  }

  Future<double> getSeekRatio() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getSeekRatio();
  }

  Future<bool> isNeedLockFull() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isNeedLockFull();
  }

  Future<void> setNeedLockFull(bool needLockFull) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setNeedLockFull(needLockFull);
  }

  Future<void> setDismissControlTime(int msec) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDismissControlTime(msec);
  }

  Future<int> getDismissControlTime() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getDismissControlTime();
  }

  Future<int> getSeekOnStart() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getSeekOnStart();
  }

  Future<bool> isIfCurrentIsFullscreen() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isIfCurrentIsFullscreen();
  }

  Future<void> setIfCurrentIsFullscreen(bool ifCurrentIsFullscreen) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setIfCurrentIsFullscreen(ifCurrentIsFullscreen);
  }

  Future<bool> isLooping() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isLooping();
  }

  Future<void> setLooping(bool looping) async {
    await _creatingCompleter.future;
    value = value.copyWith(isLooping: looping);
    await _applyLooping();
  }

  Future<double> getSpeed() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getSpeed();
  }

  Future<void> setSpeed(double speed) async {
    await _creatingCompleter.future;
    value = value.copyWith(speed: speed);
    await _applySpeed();
  }

  Future<void> setSpeedPlaying(double speed, {bool soundTouch = true}) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setSpeedPlaying(speed, soundTouch: soundTouch);
  }

  Future<bool> isShowPauseCover() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isShowPauseCover();
  }

  Future<void> setShowPauseCover(bool showPauseCover) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setShowPauseCover(showPauseCover);
  }

  Future<void> seekTo(Duration msec) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.seekTo(msec.inMilliseconds);
  }

  Future<void> setMatrixGL(List<double> matrix) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMatrixGL(matrix);
  }

  Future<void> releaseWhenLossAudio() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.releaseWhenLossAudio();
  }

  Future<void> setReleaseWhenLossAudio(bool releaseWhenLossAudio) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setReleaseWhenLossAudio(releaseWhenLossAudio);
  }

  Future<void> setAutoFullWithSize(bool releaseWhenLossAudio) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setAutoFullWithSize(releaseWhenLossAudio);
  }

  Future<bool> getAutoFullWithSize() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getAutoFullWithSize();
  }

  /// Pauses the video.
  Future<void> pause() async {
    await _creatingCompleter.future;
    value = value.copyWith(isPlaying: false);
    await _videoPlayerPlatform.onVideoPause();
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
    await _videoPlayerPlatform.setLooping(value.isLooping);
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
      await _videoPlayerPlatform.onResume();
    } else {
      await _videoPlayerPlatform.onPause();
    }
  }

  Future<void> _applyVolume() async {
    await _creatingCompleter.future;
    if (!_created || _isDisposed) {
      return;
    }
    await _videoPlayerPlatform.setVolume(value.volume);
  }

  Future<void> _applySpeed() async {
    await _creatingCompleter.future;
    if (!_created || _isDisposed) {
      return;
    }
    await _videoPlayerPlatform.setSpeed(value.speed);
  }

  /// The position in the current video.
  Future<int?> get position async {
    await _creatingCompleter.future;
    if (!value.initialized && _isDisposed) {
      return null;
    }
    return await _videoPlayerPlatform.getPlayPosition();
  }

  Future<void> initDanmaku({required DanmakuSettings settings}) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.initDanmaku(settings: settings);
  }

  Future<void> showDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.showDanmaku();
  }

  Future<bool> getDanmakuShow() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getDanmakuShow();
  }

  Future<void> hideDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.hideDanmaku();
  }

  Future<void> setDanmakuStyle(DanmakuStyle danmakuStyle,
      {double danmuStyleShadow = 0.0,
      double danmuStyleStroked = 0.0,
      double danmuStyleProjectionOffsetX = 0.0,
      double danmuStyleProjectionOffsetY = 0.0,
      double danmuStyleProjectionAlpha = 255.0}) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDanmakuStyle(danmakuStyle,
        danmuStyleShadow: danmuStyleShadow,
        danmuStyleStroked: danmuStyleStroked,
        danmuStyleProjectionOffsetX: danmuStyleProjectionOffsetX,
        danmuStyleProjectionOffsetY: danmuStyleProjectionOffsetY,
        danmuStyleProjectionAlpha: danmuStyleProjectionAlpha.clamp(0.0, 255.0));
  }

  Future<void> setDanmakuBold(bool bold) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDanmakuBold(bold);
  }

  Future<void> setScrollSpeedFactor(double speedFactor) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setScrollSpeedFactor(speedFactor);
  }

  Future<void> setDuplicateMergingEnabled(bool enabled) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDuplicateMergingEnabled(enabled);
  }

  Future<void> setMaximumLines(Map<DanmakuTypeScroll, int> maxLinesPair) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMaximumLines(maxLinesPair);
  }

  Future<void> preventOverlapping(Map<DanmakuTypeScroll, bool> preventPair) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.preventOverlapping(preventPair);
  }

  Future<void> setMarginTop(double marginTop) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMarginTop(marginTop);
  }

  Future<void> setDanmakuTransparency(double transparency) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDanmakuTransparency(transparency);
  }

  Future<void> setDanmakuMargin(double margin) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setDanmakuMargin(margin);
  }

  Future<void> setScaleTextSize(double scale) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setScaleTextSize(scale);
  }

  Future<void> setMaximumVisibleSizeInScreen(MaximumVisibleSizeInScreen maximumVisibleSizeInScreen) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setMaximumVisibleSizeInScreen(maximumVisibleSizeInScreen);
  }

  Future<void> addDanmaku(BaseDanmaku danmaku) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.addDanmaku(danmaku);
  }

  Future<void> startDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.startDanmaku();
  }

  Future<void> pauseDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.pauseDanmaku();
  }

  Future<void> resumeDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.resumeDanmaku();
  }

  Future<void> stopDanmaku() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.stopDanmaku();
  }

  Future<void> seekToDanmaku(Duration msec) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.seekToDanmaku(msec);
  }

  Future<Map<String, dynamic>> getDanmakuStatus() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getDanmakuStatus();
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
    return _videoPlayerPlatform.resolveByClick();
  }

  Future<void> backToProtVideo() {
    return _videoPlayerPlatform.backToProtVideo();
  }

  Future<bool> isOrientationRotateEnable() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateEnable();
  }

  Future<void> setOrientationRotateEnable(bool enable) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateEnable(enable);
  }

  Future<bool> getOrientationRotateIsLand() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getOrientationRotateIsLand();
  }

  Future<void> setOrientationRotateLand(bool isLand) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateLand(isLand);
  }

  Future<OrientationScreenType> getOrientationRotateScreenType() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.getOrientationRotateScreenType();
  }

  Future<void> setOrientationRotateScreenType(OrientationScreenType screenType) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateScreenType(screenType);
  }

  Future<bool> isOrientationRotateClick() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateClick();
  }

  Future<void> setOrientationRotateIsClick(bool isClick) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateIsClick(isClick);
  }

  Future<bool> isOrientationRotateClickLand() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateClickLand();
  }

  Future<void> setOrientationRotateIsClickLand(bool isClickLand) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateIsClickLand(isClickLand);
  }

  Future<bool> isOrientationRotateClickPort() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateClickPort();
  }

  Future<void> setOrientationRotateIslickPort(bool islickPort) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateIslickPort(islickPort);
  }

  Future<bool> isOrientationRotatePause() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotatePause();
  }

  Future<void> setOrientationRotateIsPause(bool isPause) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateIsPause(isPause);
  }

  Future<bool> isOrientationRotateOnlyRotateLand() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateOnlyRotateLand();
  }

  Future<void> setOrientationRotateIsOnlyRotateLand(bool isOnlyRotateLand) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateIsOnlyRotateLand(isOnlyRotateLand);
  }

  Future<bool> isOrientationRotateWithSystem() async {
    await _creatingCompleter.future;
    return await _videoPlayerPlatform.isOrientationRotateWithSystem();
  }

  Future<void> setOrientationRotateWithSystem(bool isRotateWithSystem) async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.setOrientationRotateWithSystem(isRotateWithSystem);
  }

  Future<void> releaseOrientationListener() async {
    await _creatingCompleter.future;
    await _videoPlayerPlatform.releaseOrientationListener();
  }

  void onEnterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void refresh() {
    value = value.copyWith();
  }
}

/// Widget that displays the video controlled by [controller].
class GsyVideoPlayer extends StatefulWidget {
  /// Uses the given [controller] for all video rendered in this widget.
  ///
  final GsyVideoPlayerController? controller;

  const GsyVideoPlayer({super.key, this.controller, this.onViewReady});

  final void Function(int)? onViewReady;

  @override
  State<GsyVideoPlayer> createState() => _GsyVideoPlayerState();
}

class _GsyVideoPlayerState extends State<GsyVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: _videoPlayerPlatform.buildView(widget.onViewReady));
  }
}

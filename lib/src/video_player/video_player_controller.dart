import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'video_player_platform_interface.dart';
import 'package:gsy_video_player/gsy_video_player.dart';
import 'package:gsy_video_player/src/video_player/video_event.dart';
import 'package:gsy_video_player/src/builder/video_option_builder.dart';
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
          play();
          break;
        case VideoEventType.onListenerVideoResumeWithSeek:
          play();
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

  /// Starts playing the video.
  ///
  /// This method returns a future that completes as soon as the "play" command
  /// has been sent to the platform, not when playback itself is totally
  /// finished.
  Future<void> play() async {
    value = value.copyWith(isPlaying: true);
    await _applyPlayPause();
  }

  /// Sets whether or not the video should loop after playing once. See also
  /// [VideoPlayerValue.isLooping].
  Future<void> setLooping(bool looping) async {
    value = value.copyWith(isLooping: looping);
    await _applyLooping();
  }

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

  /// Sets the speed of [this].
  ///
  /// [speed] indicates a value between 0.0 and 2.0 on a linear scale.
  Future<void> setSpeed(double speed) async {
    final double previousSpeed = value.speed;
    try {
      value = value.copyWith(speed: speed);
      await _applySpeed();
    } catch (exception) {
      value = value.copyWith(speed: previousSpeed);
      rethrow;
    }
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

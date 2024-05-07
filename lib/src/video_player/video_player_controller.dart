import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'video_player_platform_interface.dart';
import 'package:gsy_video_player/gsy_video_player.dart';
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
  Timer? _timer;
  bool _isDisposed = false;
  late Completer<void> _initializingCompleter;
  StreamSubscription<dynamic>? _eventSubscription;

  bool get _created => _creatingCompleter.isCompleted;

  Duration? _seekPosition;

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
    unawaited(_applyLooping());
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
      _timer?.cancel();
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
      _timer?.cancel();
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
    _timer?.cancel();
    if (value.isPlaying) {
      await _videoPlayerPlatform.resume();
      _timer = Timer.periodic(
        const Duration(milliseconds: 300),
        (Timer timer) async {
          if (_isDisposed) {
            return;
          }
          final Duration? newPosition = await position;
          final DateTime? newAbsolutePosition = await absolutePosition;
          // ignore: invariant_booleans
          if (_isDisposed) {
            return;
          }
          _updatePosition(newPosition, absolutePosition: newAbsolutePosition);
          if (_seekPosition != null && newPosition != null) {
            final difference = newPosition.inMilliseconds - _seekPosition!.inMilliseconds;
            if (difference > 0) {
              _seekPosition = null;
            }
          }
        },
      );
      // This ensures that the correct playback speed is always applied when
      // playing back. This is necessary because we do not set playback speed
      // when paused.
      await _applyPlaybackSpeed();
    } else {
      await _videoPlayerPlatform.pause();
    }
  }

  Future<void> _applyPlaybackSpeed() async {
    if (!value.isInitialized || _isDisposed) {
      return;
    }
    // Setting the playback speed on iOS will trigger the video to play. We
    // prevent this from happening by not applying the playback speed until
    // the video is manually played from Flutter.
    if (!value.isPlaying) return;

    await _videoPlayerPlatform.setPlaybackSpeed(value.playbackSpeed);
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
  Future<Duration?> get position async {
    if (!value.initialized && _isDisposed) {
      return null;
    }
    return _videoPlayerPlatform.getPosition();
  }

  /// The absolute position in the current video stream
  /// (i.e. EXT-X-PROGRAM-DATE-TIME in HLS).
  Future<DateTime?> get absolutePosition async {
    if (!value.initialized && _isDisposed) {
      return null;
    }
    return _videoPlayerPlatform.getAbsolutePosition();
  }

  /// Sets the video's current timestamp to be at [moment]. The next
  /// time the video is played it will resume from the given [moment].
  ///
  /// If [moment] is outside of the video's full range it will be automatically
  /// and silently clamped.
  Future<void> seekTo(Duration? position) async {
    await _videoPlayerPlatform.seekTo(position);
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

  /// Sets the video track parameters of [this]
  ///
  /// [width] specifies width of the selected track
  /// [height] specifies height of the selected track
  /// [bitrate] specifies bitrate of the selected track
  Future<void> setTrackParameters(int? width, int? height, int? bitrate) async {
    await _videoPlayerPlatform.setTrackParameters(width, height, bitrate);
  }

  Future<void> enablePictureInPicture({double? top, double? left, double? width, double? height}) async {}

  Future<void> disablePictureInPicture() async {}

  Future<bool?> isPictureInPictureSupported() async {
    return _videoPlayerPlatform.isPictureInPictureEnabled();
  }

  void _updatePosition(Duration? position, {DateTime? absolutePosition}) {
    value = value.copyWith(position: _seekPosition ?? position);
    if (_seekPosition == null) {
      value = value.copyWith(absolutePosition: absolutePosition);
    }
  }

  void refresh() {
    value = value.copyWith();
  }

  void setAudioTrack(String? name, int? index) {
    _videoPlayerPlatform.setAudioTrack(name, index);
  }

  void setMixWithOthers(bool mixWithOthers) {
    _videoPlayerPlatform.setMixWithOthers(mixWithOthers);
  }

  static Future clearCache() async {
    return _videoPlayerPlatform.clearCache();
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

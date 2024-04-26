import 'dart:async';
import 'closed_caption_file.dart';
import 'package:flutter/material.dart';
import 'video_player_platform_interface.dart';
import 'package:gsy_video_player/src/builder/video_option_builder.dart';
import 'package:gsy_video_player/src/configuration/play_video_datasource_type.dart';

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Dart imports:

final VideoPlayerPlatform _videoPlayerPlatform = VideoPlayerPlatform.instance;
// This will clear all open videos on the platform when a full restart is
// performed.

/// The duration, current position, buffering state, error state and settings
/// of a [GsyVideoPlayerController].
class VideoPlayerValue {
  /// Constructs a video with the given values. Only [duration] is required. The
  /// rest will initialize with default values when unset.
  VideoPlayerValue({
    required this.duration,
    this.size = Size.zero,
    this.absolutePosition,
    this.position = Duration.zero,
    this.caption = Caption.none,
    this.buffered = const <DurationRange>[],
    this.isInitialized = false,
    this.isPlaying = false,
    this.isLooping = false,
    this.isBuffering = false,
    this.volume = 1.0,
    this.speed = 1.0,
    this.playbackSpeed = 1.0,
    this.errorDescription,
    this.isPip = false,
  });

  /// Returns an instance for a video that hasn't been loaded.
  VideoPlayerValue.uninitialized() : this(duration: Duration.zero, isInitialized: false);

  /// Returns an instance with a `null` [Duration] and the given
  /// [errorDescription].
  VideoPlayerValue.erroneous(String errorDescription) : this(duration: null, errorDescription: errorDescription);

  /// The total duration of the video.
  ///
  /// Is null when [initialized] is false.
  final Duration? duration;

  /// The current playback position.
  final Duration position;

  /// The current absolute playback position.
  ///
  /// Is null when is not available.
  final DateTime? absolutePosition;

  /// The currently buffered ranges.
  final List<DurationRange> buffered;

  /// True if the video is playing. False if it's paused.
  final bool isPlaying;

  /// True if the video is looping.
  final bool isLooping;

  /// True if the video is currently buffering.
  final bool isBuffering;

  /// The current volume of the playback.
  final double volume;

  /// The current speed of the playback
  final double speed;

  /// Indicates whether or not the video has been loaded and is ready to play.
  final bool isInitialized;

  /// A description of the error if present.
  ///
  /// If [hasError] is false this is [null].
  final String? errorDescription;

  /// The [size] of the currently loaded video.
  ///
  /// Is null when [initialized] is false.
  final Size? size;

  /// The current speed of the playback.
  final double playbackSpeed;

  ///Is in Picture in Picture Mode
  final bool isPip;

  /// The [Caption] that should be displayed based on the current [position].
  ///
  /// This field will never be null. If there is no caption for the current
  /// [position], this will be a [Caption.none] object.
  final Caption caption;

  /// Indicates whether or not the video has been loaded and is ready to play.
  bool get initialized => duration != null;

  /// Indicates whether or not the video is in an error state. If this is true
  /// [errorDescription] should have information about the problem.
  bool get hasError => errorDescription != null;

  /// Returns [size.width] / [size.height] when size is non-null, or `1.0.` when
  /// size is null or the aspect ratio would be less than or equal to 0.0.
  double get aspectRatio {
    if (size == null) {
      return 1.0;
    }
    final double aspectRatio = size!.width / size!.height;
    if (aspectRatio <= 0) {
      return 1.0;
    }
    return aspectRatio;
  }

  /// Returns a new instance that has the same values as this current instance,
  /// except for any overrides passed in as arguments to [copyWidth].
  VideoPlayerValue copyWith({
    Duration? duration,
    Size? size,
    Duration? position,
    DateTime? absolutePosition,
    Caption? caption,
    List<DurationRange>? buffered,
    bool? isInitialized,
    bool? isPlaying,
    bool? isLooping,
    bool? isBuffering,
    double? volume,
    double? playbackSpeed,
    String? errorDescription,
    double? speed,
    bool? isPip,
  }) {
    return VideoPlayerValue(
      duration: duration ?? this.duration,
      size: size ?? this.size,
      position: position ?? this.position,
      absolutePosition: absolutePosition ?? this.absolutePosition,
      caption: caption ?? this.caption,
      buffered: buffered ?? this.buffered,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isLooping: isLooping ?? this.isLooping,
      isBuffering: isBuffering ?? this.isBuffering,
      volume: volume ?? this.volume,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      errorDescription: errorDescription ?? this.errorDescription,
      isPip: isPip ?? this.isPip,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'duration: $duration, '
        'size: $size, '
        'position: $position, '
        'absolutePosition: $absolutePosition, '
        'caption: $caption, '
        'buffered: [${buffered.join(', ')}], '
        'isInitialized: $isInitialized, '
        'isPlaying: $isPlaying, '
        'isLooping: $isLooping, '
        'isBuffering: $isBuffering, '
        'volume: $volume, '
        'playbackSpeed: $playbackSpeed, '
        'isPip: $isPip, '
        'errorDescription: $errorDescription,)';
  }
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
  GsyVideoPlayerController() : super(VideoPlayerValue(duration: null));

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
        autoPlay: autoPlay,
        shrinkImageRes: shrinkImageRes,
        enlargeImageRes: enlargeImageRes,
        playPosition: playPosition,
        dialogProgressHighLightColor: dialogProgressHighLightColor,
        dialogProgressNormalColor: dialogProgressNormalColor,
        dismissControlTime: dismissControlTime,
        seekOnStart: seekOnStart,
        seekRatio: seekRatio,
        speed: speed,
        hideKey: hideKey,
        showFullAnimation: showFullAnimation,
        autoFullWithSize: autoFullWithSize,
        needShowWifiTip: needShowWifiTip,
        rotateViewAuto: rotateViewAuto,
        lockLand: lockLand,
        looping: looping,
        isTouchWiget: isTouchWiget,
        isTouchWigetFull: isTouchWigetFull,
        showPauseCover: showPauseCover,
        rotateWithSystem: rotateWithSystem,
        surfaceErrorPlay: surfaceErrorPlay,
        cacheWithPlay: cacheWithPlay,
        needLockFull: needLockFull,
        thumbPlay: thumbPlay,
        sounchTouch: sounchTouch,
        startAfterPrepared: startAfterPrepared,
        releaseWhenLossAudio: releaseWhenLossAudio,
        actionBar: actionBar,
        statusBar: statusBar,
        isShowDragProgressTextOnSeekBar: isShowDragProgressTextOnSeekBar,
        playTag: playTag,
        videoTitle: videoTitle,
        overrideExtension: overrideExtension,
        isOnlyRotateLand: isOnlyRotateLand,
        isUseCustomCachePath: isUseCustomCachePath,
        cachePath: cachePath,
        mapHeadData: mapHeadData,
        needOrientationUtils: needOrientationUtils,
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
        autoPlay: autoPlay,
        shrinkImageRes: shrinkImageRes,
        enlargeImageRes: enlargeImageRes,
        playPosition: playPosition,
        dialogProgressHighLightColor: dialogProgressHighLightColor,
        dialogProgressNormalColor: dialogProgressNormalColor,
        dismissControlTime: dismissControlTime,
        seekOnStart: seekOnStart,
        seekRatio: seekRatio,
        speed: speed,
        hideKey: hideKey,
        showFullAnimation: showFullAnimation,
        autoFullWithSize: autoFullWithSize,
        needShowWifiTip: needShowWifiTip,
        rotateViewAuto: rotateViewAuto,
        lockLand: lockLand,
        looping: looping,
        isTouchWiget: isTouchWiget,
        isTouchWigetFull: isTouchWigetFull,
        showPauseCover: showPauseCover,
        rotateWithSystem: rotateWithSystem,
        surfaceErrorPlay: surfaceErrorPlay,
        cacheWithPlay: cacheWithPlay,
        needLockFull: needLockFull,
        thumbPlay: thumbPlay,
        sounchTouch: sounchTouch,
        startAfterPrepared: startAfterPrepared,
        releaseWhenLossAudio: releaseWhenLossAudio,
        actionBar: actionBar,
        statusBar: statusBar,
        isShowDragProgressTextOnSeekBar: isShowDragProgressTextOnSeekBar,
        playTag: playTag,
        videoTitle: videoTitle,
        overrideExtension: overrideExtension,
        isOnlyRotateLand: isOnlyRotateLand,
        isUseCustomCachePath: isUseCustomCachePath,
        cachePath: cachePath,
        mapHeadData: mapHeadData,
        needOrientationUtils: needOrientationUtils,
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
        autoPlay: autoPlay,
        shrinkImageRes: shrinkImageRes,
        enlargeImageRes: enlargeImageRes,
        playPosition: playPosition,
        dialogProgressHighLightColor: dialogProgressHighLightColor,
        dialogProgressNormalColor: dialogProgressNormalColor,
        dismissControlTime: dismissControlTime,
        seekOnStart: seekOnStart,
        seekRatio: seekRatio,
        speed: speed,
        hideKey: hideKey,
        showFullAnimation: showFullAnimation,
        autoFullWithSize: autoFullWithSize,
        needShowWifiTip: needShowWifiTip,
        rotateViewAuto: rotateViewAuto,
        lockLand: lockLand,
        looping: looping,
        isTouchWiget: isTouchWiget,
        isTouchWigetFull: isTouchWigetFull,
        showPauseCover: showPauseCover,
        rotateWithSystem: rotateWithSystem,
        surfaceErrorPlay: surfaceErrorPlay,
        cacheWithPlay: cacheWithPlay,
        needLockFull: needLockFull,
        thumbPlay: thumbPlay,
        sounchTouch: sounchTouch,
        startAfterPrepared: startAfterPrepared,
        releaseWhenLossAudio: releaseWhenLossAudio,
        actionBar: actionBar,
        statusBar: statusBar,
        isShowDragProgressTextOnSeekBar: isShowDragProgressTextOnSeekBar,
        playTag: playTag,
        videoTitle: videoTitle,
        overrideExtension: overrideExtension,
        isOnlyRotateLand: isOnlyRotateLand,
        isUseCustomCachePath: isUseCustomCachePath,
        cachePath: cachePath,
        mapHeadData: mapHeadData,
        needOrientationUtils: needOrientationUtils,
        playVideoDataSourceType: PlayVideoDataSourceType.file,
      ),
    );
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
      await _videoPlayerPlatform.play();
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
    _timer?.cancel();
    bool isPlaying = value.isPlaying;
    final int positionInMs = value.position.inMilliseconds;
    final int durationInMs = value.duration?.inMilliseconds ?? 0;

    if (positionInMs >= durationInMs && position?.inMilliseconds == 0) {
      isPlaying = true;
    }
    if (_isDisposed) {
      return;
    }

    Duration? positionToSeek = position;
    if (position! > value.duration!) {
      positionToSeek = value.duration;
    } else if (position < const Duration()) {
      positionToSeek = const Duration();
    }
    _seekPosition = positionToSeek;

    await _videoPlayerPlatform.seekTo(positionToSeek);
    if (isPlaying) {
      play();
    } else {
      pause();
    }
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
class GsyVideoPlayer extends StatefulWidget {
  /// Uses the given [controller] for all video rendered in this widget.

  final GsyVideoPlayerController? controller;

  const GsyVideoPlayer({super.key, this.controller});

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<GsyVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return _videoPlayerPlatform.buildView();
  }
}

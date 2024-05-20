import 'package:flutter/material.dart';
import 'package:gsy_video_player/src/video_player/video_event.dart';
import 'package:gsy_video_player/src/constants/video_play_state.dart';

/// The duration, current position, buffering state, error state and settings
/// of a [GsyVideoPlayerController].
class VideoPlayerValue {
  /// Constructs a video with the given values. Only [duration] is required. The
  /// rest will initialize with default values when unset.
  VideoPlayerValue({
    required this.duration,
    this.size = Size.zero,
    this.position = Duration.zero,
    this.buffered = const <DurationRange>[],
    this.isInitialized = false,
    this.isPlaying = false,
    this.isLooping = false,
    this.isBuffering = false,
    this.volume = 1.0,
    this.speed = 1.0,
    this.playbackSpeed = 1.0,
    this.what,
    this.extra,
    this.percent = 0.0,
    this.seek,
    this.errorDescription,
    this.playState,
    this.isPip = false,
    this.isFullScreen = false,
    this.rotationCorrection = 0,
    this.videoPlayerInitialized = false,
    this.allowBackgroundPlayback = true,
    this.isCompleted = false,
    this.videoSarDen = 0,
    this.videoSarNum = 0,
    this.bufferPercent = 0,
    this.fit = BoxFit.contain,
  });

  /// Returns an instance for a video that hasn't been loaded.
  VideoPlayerValue.uninitialized() : this(duration: Duration.zero, isInitialized: false, videoPlayerInitialized: false);

  /// Returns an instance with a `null` [Duration] and the given
  /// [errorDescription].
  VideoPlayerValue.erroneous(String errorDescription)
      : this(duration: Duration.zero, isInitialized: false, percent: 0.0);

  final int? what;

  final int? extra;

  final double percent;

  final bool allowBackgroundPlayback;

  final bool? seek;

  final VideoPlayState? playState;

  /// The total duration of the video.
  ///
  /// Is null when [initialized] is false.
  final Duration duration;

  final bool isFullScreen;

  /// The current playback position.
  final Duration position;

  /// The currently buffered ranges.
  final List<DurationRange> buffered;

  /// True if the video is playing. False if it's paused.
  final bool isPlaying;

  /// True if the video is looping.
  final bool isLooping;

  /// True if the video is currently buffering.
  final bool isBuffering;

  final BoxFit fit;

  /// The current volume of the playback.
  final double volume;

  /// The current speed of the playback
  final double speed;

  /// Indicates whether or not the video has been loaded and is ready to play.
  final bool isInitialized;

  final bool videoPlayerInitialized;

  /// The [size] of the currently loaded video.
  ///
  /// Is null when [initialized] is false.
  final Size? size;

  /// The current speed of the playback.
  final double playbackSpeed;

  ///Is in Picture in Picture Mode
  final bool isPip;

  /// Degrees to rotate the video (clockwise) so it is displayed correctly.
  final int rotationCorrection;

  final int bufferPercent;

  /// Indicates whether or not the video has been loaded and is ready to play.
  bool get initialized => isInitialized;

  /// A description of the error if present.
  ///
  /// If [hasError] is false this is [null].
  final String? errorDescription;

  /// Indicates whether or not the video is in an error state. If this is true
  /// [errorDescription] should have information about the problem.
  bool get hasError => errorDescription != null;

  /// Returns [size.width] / [size.height] when size is non-null, or `1.0.` when
  /// size is null or the aspect ratio would be less than or equal to 0.0.
  double get aspectRatio {
    if (size == null || size!.width == 0.0 || size!.height == 0.0) {
      return 1.0;
    }
    final double aspectRatio = size!.width / size!.height;
    if (aspectRatio <= 0) {
      return 1.0;
    }
    return aspectRatio;
  }

  final bool isCompleted;

  final int videoSarNum;

  final int videoSarDen;

  /// Returns a new instance that has the same values as this current instance,
  /// except for any overrides passed in as arguments to [copyWidth].
  VideoPlayerValue copyWith({
    Duration? duration,
    Size? size,
    Duration? position,
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
    int? what,
    int? extra,
    double? percent,
    bool? seek,
    VideoPlayState? playState,
    bool? isFullScreen,
    bool? videoPlayerInitialized,
    int? rotationCorrection,
    bool? allowBackgroundPlayback,
    bool? isCompleted,
    int? videoSarNum,
    int? videoSarDen,
    int? bufferPercent,
    BoxFit? fit,
  }) {
    return VideoPlayerValue(
      duration: duration ?? this.duration,
      size: size ?? this.size,
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isLooping: isLooping ?? this.isLooping,
      isBuffering: isBuffering ?? this.isBuffering,
      volume: volume ?? this.volume,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      what: what ?? this.what,
      extra: extra ?? this.extra,
      rotationCorrection: rotationCorrection ?? this.rotationCorrection,
      percent: percent ?? this.percent,
      seek: seek ?? this.seek,
      errorDescription: errorDescription ?? this.errorDescription,
      isPip: isPip ?? this.isPip,
      speed: speed ?? this.speed,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      playState: playState ?? this.playState,
      videoPlayerInitialized: videoPlayerInitialized ?? this.videoPlayerInitialized,
      allowBackgroundPlayback: allowBackgroundPlayback ?? this.allowBackgroundPlayback,
      isCompleted: isCompleted ?? this.isCompleted,
      videoSarNum: videoSarNum ?? this.videoSarNum,
      videoSarDen: videoSarDen ?? this.videoSarDen,
      bufferPercent: bufferPercent ?? this.bufferPercent,
      fit: fit ?? this.fit,
    );
  }

  @override
  String toString() {
    return '$runtimeType('
        'duration: $duration, '
        'size: $size, '
        'position: $position, '
        'buffered: [${buffered.join(', ')}], '
        'isInitialized: $isInitialized, '
        'videoPlayerInitialized: $videoPlayerInitialized, '
        'isPlaying: $isPlaying, '
        'isLooping: $isLooping, '
        'isBuffering: $isBuffering, '
        'volume: $volume, '
        'isFullScreen: $isFullScreen, '
        'isPip: $isPip, '
        'rotationCorrection: $rotationCorrection, '
        'percent: $percent, '
        'errorDescription: $errorDescription, '
        'speed: $speed, '
        'allowBackgroundPlayback: $allowBackgroundPlayback, '
        'isCompleted: $isCompleted, '
        'videoSarNum: $videoSarNum, '
        'videoSarDen: $videoSarDen, '
        'bufferPercent: $bufferPercent, '
        'playbackSpeed: $playbackSpeed, '
        'isPip: $isPip, '
        'rotationCorrection: $rotationCorrection, '
        'playState: $playState, '
        'what: $what, '
        'extra: $extra, '
        'percent: $percent, '
        'seek: $seek, )';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VideoPlayerValue &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          size == other.size &&
          position == other.position &&
          buffered == other.buffered &&
          isInitialized == other.isInitialized &&
          isPlaying == other.isPlaying &&
          isLooping == other.isLooping &&
          isBuffering == other.isBuffering &&
          volume == other.volume &&
          playbackSpeed == other.playbackSpeed &&
          what == other.what &&
          extra == other.extra &&
          rotationCorrection == other.rotationCorrection &&
          percent == other.percent &&
          seek == other.seek &&
          errorDescription == other.errorDescription &&
          isPip == other.isPip &&
          speed == other.speed &&
          fit == other.fit &&
          isFullScreen == other.isFullScreen &&
          playState == other.playState;

  @override
  int get hashCode => Object.hash(
        duration,
        size,
        position,
        buffered,
        isInitialized,
        isPlaying,
        isLooping,
        isBuffering,
        volume,
        playbackSpeed,
        what,
        extra,
        rotationCorrection,
        percent,
        seek,
        errorDescription,
        isPip,
        speed,
        isFullScreen,
        playState,
      );
}

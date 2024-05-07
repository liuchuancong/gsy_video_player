import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:gsy_video_player/src/video_player/video_event.dart';

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
    this.percent,
    this.seek,
    this.errorDescription,
    this.isPip = false,
  });

  /// Returns an instance for a video that hasn't been loaded.
  VideoPlayerValue.uninitialized() : this(duration: Duration.zero, isInitialized: false);

  /// Returns an instance with a `null` [Duration] and the given
  /// [errorDescription].
  VideoPlayerValue.erroneous(String errorDescription) : this(duration: null);

  final int? what;

  final int? extra;

  final int? percent;

  final bool? seek;

  /// The total duration of the video.
  ///
  /// Is null when [initialized] is false.
  final Duration? duration;

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

  /// The current volume of the playback.
  final double volume;

  /// The current speed of the playback
  final double speed;

  /// Indicates whether or not the video has been loaded and is ready to play.
  final bool isInitialized;

  /// The [size] of the currently loaded video.
  ///
  /// Is null when [initialized] is false.
  final Size? size;

  /// The current speed of the playback.
  final double playbackSpeed;

  ///Is in Picture in Picture Mode
  final bool isPip;

  /// Indicates whether or not the video has been loaded and is ready to play.
  bool get initialized => duration != null;

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
    int? percent,
    bool? seek,
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
      percent: percent ?? this.percent,
      seek: seek ?? this.seek,
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
        'buffered: [${buffered.join(', ')}], '
        'isInitialized: $isInitialized, '
        'isPlaying: $isPlaying, '
        'isLooping: $isLooping, '
        'isBuffering: $isBuffering, '
        'volume: $volume, '
        'errorDescription: $errorDescription, '
        'playbackSpeed: $playbackSpeed, '
        'isPip: $isPip, '
        'what: $what, '
        'extra: $extra, '
        'percent: $percent, '
        'seek: $seek, )';
  }
}

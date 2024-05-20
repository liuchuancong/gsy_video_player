import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:gsy_video_player/gsy_video_player.dart';

/// Event emitted from the platform implementation.
class VideoEvent {
  /// Creates an instance of [VideoEvent].
  ///
  /// The [eventType] argument is required.
  ///
  /// Depending on the [eventType], the [duration], [size] and [buffered]
  /// arguments can be null.
  VideoEvent({
    required this.eventType,
    this.duration,
    this.size,
    this.buffered,
    this.position = Duration.zero,
    this.isPlaying,
    this.what,
    this.extra,
    this.percent = 0.0,
    this.seek,
    this.videoSarDen,
    this.videoSarNum,
    this.rotationCorrection,
    this.playState = VideoPlayState.unknown,
  });

  /// The type of the event.
  final VideoEventType eventType;

  final int? what;

  final int? extra;

  final double percent;

  final bool? seek;

  final int? videoSarDen;

  final int? videoSarNum;

  final VideoPlayState playState;

  final bool? isPlaying;

  /// Degrees to rotate the video (clockwise) so it is displayed correctly.
  ///
  /// Only used if [eventType] is [VideoEventType.initialized].
  final int? rotationCorrection;

  /// Data source of the video.

  /// Duration of the video.
  ///
  /// Only used if [eventType] is [VideoEventType.initialized].
  final Duration? duration;

  /// Size of the video.
  ///
  /// Only used if [eventType] is [VideoEventType.initialized].
  final Size? size;

  /// Buffered parts of the video.
  ///
  /// Only used if [eventType] is [VideoEventType.bufferingUpdate].
  final List<DurationRange>? buffered;

  ///Seek position
  final Duration position;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is VideoEvent &&
            runtimeType == other.runtimeType &&
            rotationCorrection == other.rotationCorrection &&
            eventType == other.eventType &&
            duration == other.duration &&
            size == other.size &&
            isPlaying == other.isPlaying &&
            what == other.what &&
            extra == other.extra &&
            percent == other.percent &&
            seek == other.seek &&
            videoSarDen == other.videoSarDen &&
            videoSarNum == other.videoSarNum &&
            playState == other.playState &&
            position == other.position &&
            listEquals(buffered, other.buffered);
  }

  @override
  int get hashCode => Object.hash(
        eventType,
        duration,
        size,
        rotationCorrection,
        buffered,
        isPlaying,
      );
}

/// Describes a discrete segment of time within a video using a [start] and
/// [end] [Duration].
class DurationRange {
  /// Trusts that the given [start] and [end] are actually in order. They should
  /// both be non-null.
  DurationRange(this.start, this.end);

  /// The beginning of the segment described relative to the beginning of the
  /// entire video. Should be shorter than or equal to [end].
  ///
  /// For example, if the entire video is 4 minutes long and the range is from
  /// 1:00-2:00, this should be a `Duration` of one minute.
  final Duration start;

  /// The end of the segment described as a duration relative to the beginning of
  /// the entire video. This is expected to be non-null and longer than or equal
  /// to [start].
  ///
  /// For example, if the entire video is 4 minutes long and the range is from
  /// 1:00-2:00, this should be a `Duration` of two minutes.
  final Duration end;

  /// Assumes that [duration] is the total length of the video that this
  /// DurationRange is a segment form. It returns the percentage that [start] is
  /// through the entire video.
  ///
  /// For example, assume that the entire video is 4 minutes long. If [start] has
  /// a duration of one minute, this will return `0.25` since the DurationRange
  /// starts 25% of the way through the video's total length.
  double startFraction(Duration duration) {
    return start.inMilliseconds / duration.inMilliseconds;
  }

  /// Assumes that [duration] is the total length of the video that this
  /// DurationRange is a segment form. It returns the percentage that [start] is
  /// through the entire video.
  ///
  /// For example, assume that the entire video is 4 minutes long. If [end] has a
  /// duration of two minutes, this will return `0.5` since the DurationRange
  /// ends 50% of the way through the video's total length.
  double endFraction(Duration duration) {
    return end.inMilliseconds / duration.inMilliseconds;
  }

  @override
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType(start: $start, end: $end)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DurationRange && runtimeType == other.runtimeType && start == other.start && end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

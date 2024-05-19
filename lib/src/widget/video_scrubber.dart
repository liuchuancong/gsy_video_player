import 'package:flutter/material.dart';
import 'package:gsy_video_player/gsy_video_player.dart';

/// A scrubber to control [GsyVideoPlayerController]s
class VideoScrubber extends StatefulWidget {
  /// Create a [VideoScrubber] handler with the given [child].
  ///
  /// [controller] is the [GsyVideoPlayerController] that will be controlled by
  /// this scrubber.
  const VideoScrubber({
    super.key,
    required this.child,
    required this.controller,
  });

  /// The widget that will be displayed inside the gesture detector.
  final Widget child;

  /// The [GsyVideoPlayerController] that will be controlled by this scrubber.
  final GsyVideoPlayerController controller;

  @override
  State<VideoScrubber> createState() => _VideoScrubberState();
}

class _VideoScrubberState extends State<VideoScrubber> {
  bool _controllerWasPlaying = false;

  GsyVideoPlayerController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    void seekToRelativePosition(Offset globalPosition) {
      final RenderBox box = context.findRenderObject()! as RenderBox;
      final Offset tapPos = box.globalToLocal(globalPosition);
      final double relative = tapPos.dx / box.size.width;
      final Duration position = controller.value.duration * relative;
      controller.seekTo(position);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: widget.child,
      onHorizontalDragStart: (DragStartDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        _controllerWasPlaying = controller.value.isPlaying;
        if (_controllerWasPlaying) {
          controller.pause();
        }
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (_controllerWasPlaying && controller.value.position != controller.value.duration) {
          controller.onResume();
        }
      },
      onTapDown: (TapDownDetails details) {
        if (!controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
    );
  }
}

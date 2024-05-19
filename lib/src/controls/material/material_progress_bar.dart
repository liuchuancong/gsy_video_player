import 'package:flutter/material.dart';
import 'package:gsy_video_player/gsy_video_player.dart';
import 'package:gsy_video_player/src/controls/progress_bar.dart';
import 'package:gsy_video_player/src/controls/chewie_progress_colors.dart';

class MaterialVideoProgressBar extends StatelessWidget {
  MaterialVideoProgressBar(
    this.controller, {
    this.height = kToolbarHeight,
    ChewieProgressColors? colors,
    this.onDragEnd,
    this.onDragStart,
    this.onDragUpdate,
    super.key,
  }) : colors = colors ?? ChewieProgressColors();

  final double height;
  final GsyVideoPlayerController controller;
  final ChewieProgressColors colors;
  final Function()? onDragStart;
  final Function()? onDragEnd;
  final Function()? onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return VideoProgressBar(
      controller,
      barHeight: 10,
      handleHeight: 6,
      drawShadow: true,
      colors: colors,
      onDragEnd: onDragEnd,
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
    );
  }
}

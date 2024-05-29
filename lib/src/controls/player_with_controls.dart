import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gsy_video_player/gsy_video_player.dart';
import 'package:gsy_video_player/src/controls/notifiers/index.dart';
import 'package:gsy_video_player/src/controls/helpers/adaptive_controls.dart';

class PlayerWithControls extends StatefulWidget {
  const PlayerWithControls({super.key});

  @override
  State<PlayerWithControls> createState() => _PlayerWithControlsState();
}

class _PlayerWithControlsState extends State<PlayerWithControls> {
  bool _initialized = false;

  Future<void> listener(VideoEventType event) async {
    if (event == VideoEventType.onVideoPlayerInitialized ||
        event == VideoEventType.changeBoxFit ||
        event == VideoEventType.onVideoSizeChanged ||
        event == VideoEventType.changeAspectRatio ||
        event == VideoEventType.onRotateChanged) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    final ChewieController chewieController = ChewieController.of(context);
    chewieController.videoPlayerController.removeEventsListener(listener);
    _initialized = false;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);
    if (!_initialized) {
      chewieController.videoPlayerController.addEventsListener(listener);
      _initialized = true;
    }

    double calculateAspectRatio(BuildContext context) {
      final size = MediaQuery.of(context).size;
      final width = size.width;
      final height = size.height;
      return width > height ? width / height : height / width;
    }

    Widget buildControls(
      BuildContext context,
      ChewieController chewieController,
    ) {
      return chewieController.showControls
          ? chewieController.customControls ?? const AdaptiveControls()
          : const SizedBox();
    }

    Widget buildPlayerWithControls(
      ChewieController chewieController,
      BuildContext context,
    ) {
      return Stack(
        children: <Widget>[
          if (chewieController.placeholder != null) chewieController.placeholder!,
          SizedBox.expand(
            child: FittedBox(
              fit: chewieController.videoPlayerController.value.fit,
              child: SizedBox(
                width: chewieController.videoPlayerController.value.size.width,
                height: chewieController.videoPlayerController.value.size.height,
                child: InteractiveViewer(
                  transformationController: chewieController.transformationController,
                  maxScale: chewieController.maxScale,
                  panEnabled: chewieController.zoomAndPan,
                  scaleEnabled: chewieController.zoomAndPan,
                  child: Center(
                    child: GsyVideoPlayer(
                      controller: chewieController.videoPlayerController,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (chewieController.overlay != null) chewieController.overlay!,
          if (Theme.of(context).platform != TargetPlatform.iOS)
            Consumer<PlayerNotifier>(
              builder: (
                BuildContext context,
                PlayerNotifier notifier,
                Widget? widget,
              ) =>
                  Visibility(
                visible: !notifier.hideStuff,
                child: AnimatedOpacity(
                  opacity: notifier.hideStuff ? 0.0 : 0.8,
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black54),
                    child: SizedBox.expand(),
                  ),
                ),
              ),
            ),
          if (!chewieController.videoPlayerController.value.isFullScreen)
            buildControls(context, chewieController)
          else
            SafeArea(
              bottom: false,
              child: buildControls(context, chewieController),
            ),
        ],
      );
    }

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Center(
        child: SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: AspectRatio(
            aspectRatio: calculateAspectRatio(context),
            child: buildPlayerWithControls(chewieController, context),
          ),
        ),
      );
    });
  }
}

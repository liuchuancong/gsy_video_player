import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gsy_video_player/gsy_video_player.dart';
import 'package:gsy_video_player/src/controls/notifiers/index.dart';
import 'package:gsy_video_player/src/controls/helpers/adaptive_controls.dart';

class PlayerWithControls extends StatelessWidget {
  const PlayerWithControls({super.key});

  @override
  Widget build(BuildContext context) {
    final ChewieController chewieController = ChewieController.of(context);

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
          InteractiveViewer(
            transformationController: chewieController.transformationController,
            maxScale: chewieController.maxScale,
            panEnabled: chewieController.zoomAndPan,
            scaleEnabled: chewieController.zoomAndPan,
            child: CroppedVideo(
              controller: chewieController.videoPlayerController,
              cropAspectRatio: chewieController.aspectRatio ?? chewieController.videoPlayerController.value.aspectRatio,
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
          if (!chewieController.isFullScreen)
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

class CroppedVideo extends StatefulWidget {
  const CroppedVideo({super.key, required this.controller, required this.cropAspectRatio});

  final GsyVideoPlayerController controller;
  final double cropAspectRatio;

  @override
  CroppedVideoState createState() => CroppedVideoState();
}

class CroppedVideoState extends State<CroppedVideo> {
  GsyVideoPlayerController get controller => widget.controller;

  double get cropAspectRatio => widget.cropAspectRatio;
  bool initialized = false;

  BoxFit fit = BoxFit.contain;

  @override
  void initState() {
    super.initState();
    _waitForInitialized();
  }

  @override
  void didUpdateWidget(CroppedVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != controller) {
      oldWidget.controller.removeEventsListener(eventListener);
      initialized = false;
      fit = BoxFit.contain;
      _waitForInitialized();
    }
  }

  void _waitForInitialized() {
    controller.addEventsListener(eventListener);
  }

  void eventListener(VideoEventType event) {
    if (VideoEventType.changeBoxFit == event || initialized == false && controller.value.videoPlayerInitialized) {
      setState(() {
        fit = controller.value.fit;
        initialized = controller.value.videoPlayerInitialized;
      });
    }
  }

  @override
  void dispose() {
    controller.removeEventsListener(eventListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: cropAspectRatio,
        child: FittedBox(
          fit: controller.value.fit,
          child: SizedBox(
            width: controller.value.size?.width ?? 0,
            height: controller.value.size?.height ?? 0,
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: GsyVideoPlayer(controller: controller),
            ),
          ),
        ),
      ),
    );
  }
}

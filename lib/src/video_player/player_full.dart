import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gsy_video_player/gsy_video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GsyPlayerVideoFullScreen extends StatefulWidget {
  const GsyPlayerVideoFullScreen(
      {super.key, required this.controller, required this.routePageBuilder, required this.playerView});

  final GsyVideoPlayerController controller;

  final GsyPlayerVideoFullScreenRoutePageBuilder routePageBuilder;

  final Widget playerView;
  @override
  State<GsyPlayerVideoFullScreen> createState() => _GsyPlayerVideoFullScreenState();
}

class _GsyPlayerVideoFullScreenState extends State<GsyPlayerVideoFullScreen> with WidgetsBindingObserver {
  ///Flag which determines if widget has initialized
  bool _initialized = false;
  @override
  void initState() {
    super.initState();
    widget.controller.addEventsListener(onControllerEvent);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    if (!_initialized) {
      _initialized = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPlayer();
  }

  void onControllerEvent(VideoEventType videoEventType) {
    if (videoEventType == VideoEventType.onFullButtonClick) {
      onFullScreenChanged();
    }
  }

  Future<dynamic> _pushFullScreenWidget(BuildContext context) async {
    final TransitionRoute<void> route = PageRouteBuilder<void>(
      settings: const RouteSettings(),
      pageBuilder: _fullScreenRoutePageBuilder,
    );
    Navigator.of(context, rootNavigator: true)
        .push(route)
        .then((value) => {widget.controller.setIfCurrentIsFullscreen(true)});
  }

  // ignore: avoid_void_async
  Future<void> onFullScreenChanged() async {
    final controller = widget.controller;
    if (controller.value.isFullScreen) {
      await _pushFullScreenWidget(context);
    } else {
      widget.controller.setIfCurrentIsFullscreen(false);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Widget _fullScreenRoutePageBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final controllerProvider = GsyPlayerVideoFullScreenProvider(controller: widget.controller, child: _buildPlayer());

    final routePageBuilder = widget.routePageBuilder;

    return routePageBuilder(context, animation, secondaryAnimation, controllerProvider);
  }

  Widget _buildPlayer() {
    return VisibilityDetector(
      key: Key("${widget.controller.hashCode}_key"),
      onVisibilityChanged: (VisibilityInfo visibilityInfo) {},
      child: widget.playerView,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    VisibilityDetectorController.instance.forget(Key("${widget.controller.hashCode}_key"));
    super.dispose();
  }
}

class GsyPlayerVideoFullScreenProvider extends InheritedWidget {
  const GsyPlayerVideoFullScreenProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  final GsyVideoPlayerController controller;

  @override
  bool updateShouldNotify(GsyPlayerVideoFullScreenProvider oldWidget) => controller != oldWidget.controller;
}

typedef GsyPlayerVideoFullScreenRoutePageBuilder = Widget Function(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, GsyPlayerVideoFullScreenProvider controllerProvider);

class GsyEnterFullScreen extends StatefulWidget {
  const GsyEnterFullScreen({
    super.key,
    required this.controller,
    required this.controllerProvider,
  });

  final GsyVideoPlayerController controller;
  final Widget controllerProvider;

  @override
  State<GsyEnterFullScreen> createState() => _GsyEnterFullScreenState();
}

class _GsyEnterFullScreenState extends State<GsyEnterFullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            widget.controllerProvider,
          ],
        ),
      ),
    );
  }
}

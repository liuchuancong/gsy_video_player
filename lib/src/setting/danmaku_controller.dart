import 'package:gsy_video_player/gsy_video_player.dart';

class DanmakuController {
  // 是否显示弹幕
  bool _isDanmakuShow = false;
  bool get danmakuShow => _isDanmakuShow;
  DanmakuSettings get settings => _controller.danmakuSettings;
  late GsyVideoPlayerController _controller;
  DanmakuController(GsyVideoPlayerController controller) {
    _controller = controller;
  }
  // 初始化弹幕
  Future<void> initDanmaku() async {
    _controller.initDanmaku(settings: settings);
  }

  // 显示弹幕
  Future<void> showDanmaku() async {
    _controller.showDanmaku();
    _isDanmakuShow = false;
  }

  Future<bool> getDanmakuShow() async {
    return await _controller.getDanmakuShow();
  }

  // 隐藏弹幕
  Future<void> hideDanmaku() async {
    _controller.hideDanmaku();
    _isDanmakuShow = false;
  }

  Future<void> setDanmakuStyle(
    DanmakuStyle danmakuStyle, {
    double danmuStyleShadow = 0.0,
    double danmuStyleStroked = 0.0,
    double danmuStyleProjectionOffsetX = 0.0,
    double danmuStyleProjectionOffsetY = 0.0,
    double danmuStyleProjectionAlpha = 255.0,
  }) async {
    _controller.setDanmakuStyle(
      danmakuStyle,
      danmuStyleShadow: danmuStyleShadow,
      danmuStyleStroked: danmuStyleStroked,
      danmuStyleProjectionOffsetX: danmuStyleProjectionOffsetX,
      danmuStyleProjectionOffsetY: danmuStyleProjectionOffsetY,
      danmuStyleProjectionAlpha: danmuStyleProjectionAlpha,
    );
  }

  Future<void> setDanmakuBold(bool bold) async {
    _controller.setDanmakuBold(bold);
  }

  Future<void> setScrollSpeedFactor(double speedFactor) async {
    _controller.setScrollSpeedFactor(speedFactor);
  }

  Future<void> setDuplicateMergingEnabled(bool enabled) async {
    _controller.setDuplicateMergingEnabled(enabled);
  }

  Future<void> setMaximumLines(Map<DanmakuTypeScroll, int> maxLinesPair) async {
    _controller.setMaximumLines(maxLinesPair);
  }

  Future<void> preventOverlapping(Map<DanmakuTypeScroll, bool> preventPair) async {
    _controller.preventOverlapping(preventPair);
  }

  Future<void> setMarginTop(double marginTop) async {
    _controller.setMarginTop(marginTop);
  }

  Future<void> setDanmakuTransparency(double transparency) async {
    _controller.setDanmakuTransparency(transparency);
  }

  Future<void> setDanmakuMargin(double margin) async {
    _controller.setDanmakuMargin(margin);
  }

  Future<void> setScaleTextSize(double scale) async {
    _controller.setScaleTextSize(scale);
  }

  Future<void> setMaximumVisibleSizeInScreen(MaximumVisibleSizeInScreen maximumVisibleSizeInScreen) async {
    _controller.setMaximumVisibleSizeInScreen(maximumVisibleSizeInScreen);
  }

  Future<void> addDanmaku(BaseDanmaku danmaku) async {
    _controller.addDanmaku(danmaku);
  }

  Future<void> startDanmaku() async {
    _controller.startDanmaku();
  }

  Future<void> pauseDanmaku() async {
    _controller.pauseDanmaku();
  }

  Future<void> resumeDanmaku() async {
    _controller.resumeDanmaku();
  }

  Future<void> stopDanmaku() async {
    _controller.stopDanmaku();
  }

  Future<void> seekToDanmaku(Duration msec) async {
    _controller.seekToDanmaku(msec);
  }

  Future<Map<String, dynamic>> getDanmakuStatus() async {
    return _controller.getDanmakuStatus();
  }
}

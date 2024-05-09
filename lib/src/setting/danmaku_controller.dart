import 'package:gsy_video_player/gsy_video_player.dart';

class DanmakuController {
  // 是否显示弹幕
  bool _isDanmakuShow = false;
  bool get danmakuShow => _isDanmakuShow;
  DanmakuSettings get settings => _settings;
  late GsyVideoPlayerController _controller;
  late DanmakuSettings _settings;
  DanmakuController(GsyVideoPlayerController controller) {
    _controller = controller;
  }
  // 初始化弹幕
  Future<void> initDanmaku({required DanmakuSettings settings}) async {
    _settings = settings;
  }

  // 显示弹幕
  Future<void> showDanmaku(bool show) async {
    _controller.showDanmaku(show);
    _isDanmakuShow = show;
  }

  Future<bool> getDanmakuShow() async {
    return await _controller.getDanmakuShow();
  }

  // 隐藏弹幕
  Future<void> hideDanmaku(bool show) async {}

  Future<void> setDanmakuStyle(
    DanmakuStyle danmakuStyle, {
    double danmuStyleShadow = 0.0,
    double danmuStyleStroked = 0.0,
    double danmuStyleProjectionOffsetX = 0.0,
    double danmuStyleProjectionOffsetY = 0.0,
    double danmuStyleProjectionAlpha = 255.0,
  }) async {}

  Future<void> setDanmakuBold(bool bold) async {}

  Future<void> setScrollSpeedFactor(double speedFactor) async {}

  Future<void> setDuplicateMergingEnabled(bool enabled) async {}

  Future<void> setMaximumLines(Map<DanmakuTypeScroll, int> maxLinesPair) async {}

  Future<void> preventOverlapping(Map<DanmakuTypeScroll, bool> preventPair) async {}

  Future<void> setMarginTop(double marginTop) async {}

  Future<void> setDanmakuTransparency(double transparency) async {}

  Future<void> setDanmakuMargin(double margin) async {}

  Future<void> setScaleTextSize(double scale) async {}

  Future<void> setMaximumVisibleSizeInScreen(MaximumVisibleSizeInScreen maximumVisibleSizeInScreen) async {}

  Future<void> addDanmaku(BaseDanmaku danmaku) async {}
}

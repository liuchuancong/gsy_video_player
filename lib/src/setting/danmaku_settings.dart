import 'package:flutter/material.dart';
import 'package:gsy_video_player/src/constants/maximum_visible_size_in_screen.dart';

enum DanmakuStyle {
  //无
  danmuStyleNone,
  //阴影
  danmuStyleShadow,
  //描边
  danmuStyleStroked,
  // 投影
  danmuStyleProjection,
}

DanmakuStyle danmakuStyleFromInt(int style) {
  switch (style) {
    case 0:
      return DanmakuStyle.danmuStyleNone;
    case 1:
      return DanmakuStyle.danmuStyleShadow;
    case 2:
      return DanmakuStyle.danmuStyleStroked;
    case 3:
      return DanmakuStyle.danmuStyleProjection;
    default:
      return DanmakuStyle.danmuStyleNone;
  }
}

int danmakuStyleToInt(DanmakuStyle style) {
  switch (style) {
    case DanmakuStyle.danmuStyleNone:
      return 0;
    case DanmakuStyle.danmuStyleShadow:
      return 1;
    case DanmakuStyle.danmuStyleStroked:
      return 2;
    case DanmakuStyle.danmuStyleProjection:
      return 3;
    default:
      return 0;
  }
}

enum DanmakuTypeScroll {
  // 滚动弹幕
  scrollRL,
  // 滚动弹幕
  scrollLR,
  // 固定顶部弹幕
  fixTop,
  // 固定底部弹幕
  fixBottom,
  // 特殊弹幕
  special,
}

DanmakuTypeScroll danmakuTypeScrollFromInt(int type) {
  switch (type) {
    case 1:
      return DanmakuTypeScroll.scrollRL;
    case 6:
      return DanmakuTypeScroll.scrollLR;
    case 5:
      return DanmakuTypeScroll.fixTop;
    case 4:
      return DanmakuTypeScroll.fixBottom;
    case 7:
      return DanmakuTypeScroll.special;
    default:
      return DanmakuTypeScroll.scrollRL;
  }
}

int danmakuTypeScrollToInt(DanmakuTypeScroll type) {
  switch (type) {
    case DanmakuTypeScroll.scrollRL:
      return 1;
    case DanmakuTypeScroll.scrollLR:
      return 6;
    case DanmakuTypeScroll.fixTop:
      return 5;
    case DanmakuTypeScroll.fixBottom:
      return 4;
    case DanmakuTypeScroll.special:
      return 7;
    default:
      return 1;
  }
}

class DanmakuSettings {
  final String? url;

  final bool? showDanmaku;

  final bool? isLinkFile;

  final DanmakuStyle? danmakuStyle;
  //danmuStyleShadow 阴影模式下，values传入阴影半径
  final double? shadowRadius;
  //danmuStyleStroked 阴影模式下，values传入描边宽度
  final double? strokenWidth;
  //danmuStyleProjection 投影模式下，values传入offsetX, offsetY, alpha
  final double? projectionOffsetX;

  final double? projectionOffsetY;

  final double? projectionAlpha;

  final bool? isBold;

  final bool? pauseWhenVideoPaused;

  final DanmakuTypeScroll? danmakuTypeScroll;
  //设置弹幕滚动速度系数,只对滚动弹幕有效
  final double? scrollSpeedFactor;
  //是否开启重复弹幕合并
  final bool? duplicateMergingEnabled;
  // 设置是否禁止重叠弹幕
  final Map<DanmakuTypeScroll, bool>? overlappingEnablePair;

  //设置最大显示行数
  final Map<DanmakuTypeScroll, int>? maxLinesPair;
  //弹幕透明度[0-255]
  final int? opacity;
  //弹幕缩放系数
  final double? scaleTextSize;
  //弹幕间距
  final int? margin;

  //弹幕顶部间距
  final int? marginTop;

  final MaximumVisibleSizeInScreen? maximumVisibleSizeInScreen;

  final bool? enableDanmakuDrawingCache;

  static const defaultOverlappingEnablePair = {DanmakuTypeScroll.scrollRL: true};

  const DanmakuSettings({
    this.danmakuStyle = DanmakuStyle.danmuStyleNone,
    this.url = '',
    this.showDanmaku = false,
    this.isLinkFile = false,
    this.shadowRadius = 0.0,
    this.strokenWidth = 0.0,
    this.projectionOffsetX = 0.0,
    this.projectionOffsetY = 0.0,
    this.projectionAlpha = 255.0,
    this.isBold = false,
    this.danmakuTypeScroll = DanmakuTypeScroll.scrollRL,
    this.scrollSpeedFactor = 1.0,
    this.duplicateMergingEnabled = true,
    this.overlappingEnablePair = defaultOverlappingEnablePair,
    this.maxLinesPair,
    this.opacity = 255,
    this.scaleTextSize = 1.0,
    this.margin = 0,
    this.marginTop = 0,
    this.maximumVisibleSizeInScreen = MaximumVisibleSizeInScreen.auto,
    this.pauseWhenVideoPaused = false,
    this.enableDanmakuDrawingCache = true,
  });

  Map<String, dynamic> toJson() {
    return {
      "danmakuStyle": danmakuStyleToInt(danmakuStyle!),
      "url": url,
      "showDanmaku": showDanmaku,
      "isLinkFile": isLinkFile,
      "shadowRadius": shadowRadius,
      "strokenWidth": strokenWidth,
      "projectionOffsetX": projectionOffsetX,
      "projectionOffsetY": projectionOffsetY,
      "projectionAlpha": projectionAlpha!.clamp(0, 255),
      "isBold": isBold,
      "danmakuTypeScroll": danmakuTypeScrollToInt(danmakuTypeScroll!),
      "scrollSpeedFactor": scrollSpeedFactor,
      "duplicateMergingEnabled": duplicateMergingEnabled,
      "overlappingEnablePair": overlappingEnablePair!.map((key, value) => MapEntry(danmakuTypeScrollToInt(key), value)),
      "maxLinesPair": maxLinesPair?.map((key, value) => MapEntry(danmakuTypeScrollToInt(key), value)),
      "opacity": opacity!.clamp(0, 255),
      "scaleTextSize": scaleTextSize,
      "margin": margin,
      "marginTop": marginTop,
      "maximumVisibleSizeInScreen": getIntFromMaximumVisibleSizeInScreen(maximumVisibleSizeInScreen!),
      "pauseWhenVideoPaused": pauseWhenVideoPaused,
      "enableDanmakuDrawingCache": enableDanmakuDrawingCache,
    };
  }
}

class BaseDanmaku {
  DanmakuTypeScroll? type;
  //显示时间(毫秒)
  int? time;
  //偏移时间
  int? timeOffset;
  //文本
  String? text;
  //多行文本: 如果有包含换行符需事先拆分到lines
  List<String>? lines;
  //保存一些数据的引用(库内部使用, 外部使用请用tag)
  //文本颜色
  Color? textColor;
  //Z轴角度
  double? rotationZ;
  //Y轴角度
  double? rotationY;
  //阴影/描边颜色
  Color? textShadowColor;
  //下划线颜色,0表示无下划线
  Color? underlineColor;
  //字体大小
  double? textSize;
  //框的颜色,0表示无框
  Color? borderColor;
  //内边距(像素)
  int? padding;
  //弹幕优先级,0为低优先级,>0为高优先级不会被过滤器过滤
  int? priority;
  //占位宽度
  double? paintWidth;
  //占位高度
  double? paintHeight;
  //存活时间(毫秒)
  Duration? duration;
  //索引/编号
  int? index;
  //是否可见
  bool? visibility;
  //是否是直播弹幕
  bool? isLive;
  //临时, 是否在同线程创建缓存
  bool? forceBuildCacheInSameThread;
  //弹幕发布者id, 0表示游客
  int? userId;
  //弹幕发布者id
  String? userHash;
  //是否游客
  bool? isGuest;
  //计时
  //透明度[0-255]
  int? alpha;

  BaseDanmaku({
    this.type = DanmakuTypeScroll.scrollRL,
    this.time,
    this.timeOffset,
    this.text,
    this.lines,
    this.textColor = Colors.black,
    this.rotationZ,
    this.rotationY,
    this.textShadowColor,
    this.underlineColor,
    this.textSize = 14,
    this.borderColor,
    this.padding = 0,
    this.priority = 10,
    this.paintWidth = -1,
    this.paintHeight = -1,
    this.duration,
    this.index,
    this.visibility = true,
    this.isLive = true,
    this.forceBuildCacheInSameThread = true,
    this.userId,
    this.userHash,
    this.isGuest = true,
    this.alpha = 255,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": danmakuTypeScrollToInt(type!),
      "time": time,
      "timeOffset": timeOffset,
      "text": text,
      "lines": lines,
      "textColor": textColor?.value,
      "rotationZ": rotationZ,
      "rotationY": rotationY,
      "textShadowColor": textShadowColor?.value,
      "underlineColor": underlineColor?.value,
      "textSize": textSize,
      "borderColor": borderColor?.value,
      "padding": padding,
      "priority": priority,
      "paintWidth": paintWidth,
      "paintHeight": paintHeight,
      "duration": duration?.inMilliseconds,
      "index": index,
      "visibility": visibility,
      "isLive": isLive,
      "forceBuildCacheInSameThread": forceBuildCacheInSameThread,
      "userId": userId,
      "userHash": userHash,
      "isGuest": isGuest,
      "alpha": alpha!.clamp(0.0, 255.0),
    };
  }
}

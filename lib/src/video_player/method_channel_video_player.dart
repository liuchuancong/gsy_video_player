import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:gsy_video_player/gsy_video_player.dart';

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
const _channel = MethodChannel('gsy_video_player_channel/platform_view_methods');

/// An implementation of [VideoPlayerPlatform] that uses method channels.
class MethodChannelVideoPlayer extends VideoPlayerPlatform {
  String viewType = 'gsy_video_player_channel/platform_view';
  // Pass parameters to the platform side.
  Map<String, dynamic> creationParams = <String, dynamic>{};
  Timer? _timer;
  int? textureId;
  MethodChannelVideoPlayer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) async {
      try {
        late final Map<String, dynamic>? response;
        response = await _channel.invokeMapMethod<String, dynamic>('create');
        textureId = response?['textureId'];
        initialized.complete(textureId);
        _timer?.cancel();
        // ignore: empty_catches
      } catch (e) {}
    });
  }
  @override
  Future<int?> create() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMapMethod<String, dynamic>('create');
    textureId = response?['textureId'];
    return textureId;
  }

  @override
  Future<void> dispose() async {
    await initialized.future;
    await _channel.invokeMethod<void>('dispose');
  }

  @override
  Future<void> setVideoOptionBuilder(VideoOptionBuilder builder) async {
    await initialized.future;
    Map<String, dynamic>? builderParams = builder.toJson();
    await _channel.invokeMethod<void>(
      'setVideoOptionBuilder',
      <String, dynamic>{
        'builderParams': builderParams,
      },
    );
  }

  @override
  Future<int> getLayoutId() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>('getLayoutId');
    return response!["layoutId"];
  }

  @override
  Future<void> startPlayLogic() async {
    await initialized.future;
    await _channel.invokeMethod<void>('startPlayLogic');
  }

  @override
  Future<void> setUp(String url, bool cacheWithPlay, String cachePath, String title) async {
    await initialized.future;
    await _channel.invokeMethod<void>(
      'setUp',
      <String, dynamic>{
        'setUpOptions': {
          'url': url,
          'cacheWithPlay': cacheWithPlay,
          'cachePath': cachePath,
          'title': title,
        },
      },
    );
  }

  @override
  Future<void> onVideoPause() async {
    await initialized.future;
    await _channel.invokeMethod<void>("onVideoPause");
  }

  @override
  Future<void> onVideoResume() async {
    await initialized.future;
    await _channel.invokeMethod<void>("onVideoResume");
  }

  @override
  Future<void> clearCurrentCache() async {
    await initialized.future;
    await _channel.invokeMethod<void>("clearCurrentCache");
  }

  @override
  Future<int> getCurrentPositionWhenPlaying() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>('getCurrentPositionWhenPlaying');
    return response!["currentPosition"];
  }

  @override
  Future<void> releaseAllVideos() async {
    await initialized.future;
    await _channel.invokeMethod<void>("releaseAllVideos");
  }

  @override
  Future<VideoPlayState> getCurrentState() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getCurrentState");
    return getVideoPlayStateName(response!["currentState"]);
  }

  @override
  Future<void> setPlayTag(String tag) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setPlayTag", <String, dynamic>{
      "playTag": tag,
    });
  }

  @override
  Future<void> setPlayPosition(int position) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setPlayPosition", <String, dynamic>{
      "playPosition": position,
    });
  }

  @override
  Future<void> backFromWindowFull() async {
    await initialized.future;
    await _channel.invokeMethod<void>("backFromWindowFull");
  }

  @override
  Future<int> getNetSpeed() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getNetSpeed");
    return response!["netSpeed"];
  }

  @override
  Future<String> getNetSpeedText() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getNetSpeedText");
    return response!["getNetSpeedText"];
  }

  @override
  Future<void> setSeekOnStart(int msec) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setSeekOnStart", <String, dynamic>{
      "location": msec,
    });
  }

  @override
  Future<int> getBuffterPoint() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getBuffterPoint");
    return response!["buffterPoint"];
  }

  @override
  Future<GsyVideoPlayerType> setCurrentPlayer(GsyVideoPlayerType playerType) async {
    await initialized.future;
    await _channel.invokeMethod<void>(
      'setCurrentPlayer',
      <String, dynamic>{
        'playerOptions': {'currentPlayer': playerType},
      },
    );
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getPlayManager");
    return getVideoPlayerType(response!["currentPlayer"]);
  }

  @override
  Future<GsyVideoPlayerType> getPlayManager() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getPlayManager");
    return getVideoPlayerType(response!["currentPlayer"]);
  }

  @override
  Future<void> setExoCacheManager() async {
    await initialized.future;
    await _channel.invokeMethod<void>("setExoCacheManager");
  }

  @override
  Future<void> setProxyCacheManager() async {
    await initialized.future;
    await _channel.invokeMethod<void>("setProxyCacheManager");
  }

  @override
  Future<void> clearAllDefaultCache() async {
    await initialized.future;
    await _channel.invokeMethod<void>("clearAllDefaultCache");
  }

  @override
  Future<void> clearDefaultCache(String cacheDir, String url) async {
    await initialized.future;
    await _channel.invokeMethod<void>(
      "clearDefaultCache",
      <String, dynamic>{
        'playOptions': {
          'cacheDir': cacheDir,
          'url': url,
        },
      },
    );
  }

  @override
  Future<void> releaseMediaPlayer() async {
    await initialized.future;
    await _channel.invokeMethod<void>("releaseMediaPlayer");
  }

  @override
  Future<void> onPause() async {
    await initialized.future;
    await _channel.invokeMethod<void>("onPause");
  }

  @override
  Future<void> onResume() async {
    await initialized.future;
    await _channel.invokeMethod<void>("onResume");
  }

  @override
  Future<String> getPlayTag() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getPlayTag");
    return response!["playTag"];
  }

  @override
  Future<int> getPlayPosition() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getPlayPosition");
    return response!["playPosition"];
  }

  @override
  Future<List<IjkOption>> getOptionModelList() async {
    List<IjkOption> optionModelList = [];
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getOptionModelList");

    if (response != null) {
      List<dynamic> optionList = response['ijkOptions'];
      for (dynamic option in optionList) {
        optionModelList.add(IjkOption(
          name: option['name'],
          value: option['value'],
          category: getIjkCategory(option['category']),
        ));
      }
    }
    return optionModelList;
  }

  @override
  Future<void> setOptionModelList(List<IjkOption> optionModelList) async {
    List<dynamic> optionList = [];
    for (IjkOption option in optionModelList) {
      optionList.add({
        'name': option.name,
        'valueInt': option.value,
        'category': option.category.index,
      });
    }
    await _channel.invokeMethod<void>(
      'setOptionModelList',
      <String, dynamic>{
        'ijkOptions': optionList,
      },
    );
  }

  @override
  Future<bool> isNeedMute() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isNeedMute");
    return response!["isNeedMute"];
  }

  @override
  Future<void> setNeedMute(bool needMute) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setNeedMute", <String, dynamic>{
      "isNeedMute": needMute,
    });
  }

  @override
  Future<int> getTimeOut() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getTimeOut");
    return response!["timeOut"];
  }

  @override
  Future<bool> isNeedTimeOutOther() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isNeedTimeOutOther");
    return response!["isNeedTimeOutOther"];
  }

  @override
  Future<void> setTimeOut(int timeOut, {bool needTimeOutOther = false}) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setNeedMute", <String, dynamic>{
      "timeOutOptions": {
        "timeOut": timeOut,
        "needTimeOutOther": needTimeOutOther,
      },
    });
  }

  @override
  Future<void> setLogLevel(LogLevel level) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setLogLevel", <String, dynamic>{
      "logLevel": level.index,
    });
  }

  @override
  Future<bool> isMediaCodec() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isMediaCodec");
    return response!["isMediaCodec"];
  }

  @override
  Future<double> getScreenScaleRatio() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getScreenScaleRatio");
    return response!["screenScaleRatio"] as double;
  }

  @override
  Future<void> setScreenScaleRatio(double ratio) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setScreenScaleRatio", <String, dynamic>{
      "screenScaleRatio": ratio,
    });
  }

  @override
  Future<bool> isMediaCodecTexture() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isMediaCodecTexture");
    return response!["isMediaCodecTexture"];
  }

  @override
  Future<PlayerVideoShowType> getShowType() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getShowType");
    return getPlayerVideoShowType(response!["type"]);
  }

  @override
  Future<void> setShowType(PlayerVideoShowType showType, {double screenScaleRatio = 0.0}) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setShowType", <String, dynamic>{
      "showTypeOptions": {
        "showType": showType,
        "screenScaleRatio": screenScaleRatio,
      },
    });
  }

  @override
  Future<GsyVideoPlayerRenderType> getRenderType() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getRenderType");
    return getGsyVideoPlayerRenderType(response!["renderType"]);
  }

  @override
  Future<void> setRenderType(GsyVideoPlayerRenderType renderType) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setRenderType", <String, dynamic>{
      "renderType": renderType.index,
    });
  }

  @override
  Future<void> setMediaCodec(bool mediaCodec) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setMediaCodec", <String, dynamic>{
      "enableCodec": mediaCodec,
    });
  }

  @override
  Future<void> setMediaCodecTexture(bool mediaCodecTexture) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setMediaCodecTexture", <String, dynamic>{
      "enableCodecTexture": mediaCodecTexture,
    });
  }

  @override
  Future<void> startWindowFullscreen(bool showActionBar, bool showStatusBar) async {
    await initialized.future;
    _channel.invokeMethod<void>("startWindowFullscreen", <String, dynamic>{
      "startWindowFullscreenOptions": {
        "actionBar": showActionBar,
        "statusBar": showStatusBar,
      }
    });
  }

  @override
  Future<void> showSmallVideo(Size size, bool showActionBar, bool showStatusBar) async {
    await initialized.future;
    _channel.invokeMethod<void>("showSmallVideo", <String, dynamic>{
      "showSmallVideoOptions": {
        "actionBar": showActionBar,
        "statusBar": showStatusBar,
        "size": {
          "width": size.width.toInt(),
          "height": size.height.toInt(),
        }
      }
    });
  }

  @override
  Future<void> hideSmallVideo() async {
    await initialized.future;
    _channel.invokeMethod<void>("hideSmallVideo");
  }

  @override
  Future<bool> isShowFullAnimation() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isShowFullAnimation");
    return response!["isShowFullAnimation"];
  }

  @override
  Future<void> setShowFullAnimation(bool showFullAnimation) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setShowFullAnimation", <String, dynamic>{
      "isShowFullAnimation": showFullAnimation,
    });
  }

  @override
  Future<bool> isRotateViewAuto() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isRotateViewAuto");
    return response!["isRotateViewAuto"];
  }

  @override
  Future<void> setRotateViewAuto(bool rotateViewAuto) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setRotateViewAuto", <String, dynamic>{
      "isRotateViewAuto": rotateViewAuto,
    });
  }

  @override
  Future<bool> isLockLand() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isLockLand");
    return response!["isLockLand"];
  }

  @override
  Future<void> setLockLand(bool lockLand) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setLockLand", <String, dynamic>{
      "isLockLand": lockLand,
    });
  }

  @override
  Future<bool> isRotateWithSystem() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isRotateWithSystem");
    return response!["isRotateWithSystem"];
  }

  @override
  Future<void> setRotateWithSystem(bool rotateWithSystem) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setRotateWithSystem", <String, dynamic>{
      "isRotateWithSystem": rotateWithSystem,
    });
  }

  @override
  Future<void> initUIState() async {
    await initialized.future;
    await _channel.invokeMethod<void>("initUIState");
  }

  @override
  Future<int> getEnlargeImageRes() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getEnlargeImageRes");
    return response!["enlargeImageRes"];
  }

  @override
  Future<void> setEnlargeImageRes(int res) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setEnlargeImageRes", <String, dynamic>{
      "enlargeImageRes": res,
    });
  }

  @override
  Future<int> getShrinkImageRes() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getShrinkImageRes");
    return response!["shrinkImageRes"];
  }

  @override
  Future<void> setShrinkImageRes(int res) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setShrinkImageRes", <String, dynamic>{
      "shrinkImageRes": res,
    });
  }

  @override
  Future<bool> getIsTouchWigetFull() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getIsTouchWigetFull");
    return response!["isTouchWigetFull"];
  }

  @override
  Future<void> setIsTouchWigetFull(bool isTouchWigetFull) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setIsTouchWigetFull", <String, dynamic>{
      "isTouchWigetFull": isTouchWigetFull,
    });
  }

  @override
  Future<void> setThumbPlay(bool thumbPlay) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setThumbPlay", <String, dynamic>{
      "thumbPlay": thumbPlay,
    });
  }

  @override
  Future<bool> isHideKeyBoard() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isHideKeyBoard");
    return response!["isHideKeyBoard"];
  }

  @override
  Future<void> setHideKeyBoard(bool hideKeyBoard) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setHideKeyBoard", <String, dynamic>{
      "isHideKeyBoard": hideKeyBoard,
    });
  }

  @override
  Future<bool> isNeedShowWifiTip() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isNeedShowWifiTip");
    return response!["isNeedShowWifiTip"];
  }

  @override
  Future<void> setNeedShowWifiTip(bool needShowWifiTip) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setNeedShowWifiTip", <String, dynamic>{
      "isNeedShowWifiTip": needShowWifiTip,
    });
  }

  @override
  Future<bool> isTouchWiget() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isTouchWiget");
    return response!["isTouchWiget"];
  }

  @override
  Future<void> setTouchWiget(bool touchWiget) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setTouchWiget", <String, dynamic>{
      "isTouchWiget": touchWiget,
    });
  }

  @override
  Future<double> getSeekRatio() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getSeekRatio");
    return response!["seekRatio"] as double;
  }

  @override
  Future<void> setSeekRatio(double seekRatio) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setSeekRatio", <String, dynamic>{
      "seekRatio": seekRatio,
    });
  }

  @override
  Future<bool> isNeedLockFull() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isNeedLockFull");
    return response!["isNeedLockFull"];
  }

  @override
  Future<void> setNeedLockFull(bool needLockFull) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setNeedLockFull", <String, dynamic>{
      "isNeedLockFull": needLockFull,
    });
  }

  @override
  Future<int> getDismissControlTime() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getDismissControlTime");
    return response!["isNeedLockFull"];
  }

  @override
  Future<void> setDismissControlTime(int time) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setDismissControlTime", <String, dynamic>{
      "dismissControlTime": time,
    });
  }

  @override
  Future<int> getSeekOnStart() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getSeekOnStart");
    return response!["seekOnStart"];
  }

  @override
  Future<bool> isIfCurrentIsFullscreen() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isIfCurrentIsFullscreen");
    return response!["isIfCurrentIsFullscreen"];
  }

  @override
  Future<void> setIfCurrentIsFullscreen(bool ifCurrentIsFullscreen) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setIfCurrentIsFullscreen", <String, dynamic>{
      "isIfCurrentIsFullscreen": ifCurrentIsFullscreen,
    });
  }

  @override
  Future<bool> isLooping() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isLooping");
    return response!["isLooping"];
  }

  @override
  Future<void> setLooping(bool looping) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setLooping", <String, dynamic>{
      "isLooping": looping,
    });
  }

  @override
  Future<double> getSpeed() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getSpeed");
    return response!["speed"] as double;
  }

  @override
  Future<void> setSpeed(double speed, {bool soundTouch = true}) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setSpeed", <String, dynamic>{
      "speedOptions": {"speed": 1.0, "soundTouch": soundTouch},
    });
  }

  @override
  Future<void> setSpeedPlaying(double speed, {bool soundTouch = true}) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setSpeedPlaying", <String, dynamic>{
      "speedPlayingOptions": {"speed": 1.0, "soundTouch": soundTouch},
    });
  }

  @override
  Future<bool> isShowPauseCover() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isShowPauseCover");
    return response!["isShowPauseCover"];
  }

  @override
  Future<void> setShowPauseCover(bool showPauseCover) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setShowPauseCover", <String, dynamic>{
      "isShowPauseCover": showPauseCover,
    });
  }

  @override
  Future<void> seekTo(int msec) async {
    await initialized.future;
    await _channel.invokeMethod<void>("seekTo", <String, dynamic>{
      "position": msec,
    });
  }

  @override
  Future<void> setMatrixGL(List<double> matrix) async {
    await initialized.future;
    await _channel.invokeMethod<void>("seekTo", <String, dynamic>{
      "matrix": matrix,
    });
  }

  @override
  Future<void> releaseWhenLossAudio() async {
    await initialized.future;
    await _channel.invokeMethod<void>("releaseWhenLossAudio");
  }

  @override
  Future<void> setAutoFullWithSize(bool releaseWhenLossAudio) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setAutoFullWithSize", <String, dynamic>{
      "autoFullWithSize": releaseWhenLossAudio,
    });
  }

  @override
  Future<bool> getAutoFullWithSize() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("autoFullWithSize");
    return response!["autoFullWithSize"];
  }

  @override
  Future<void> setVolume(double volume) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setVolume", <String, dynamic>{
      "volume": volume,
    });
  }

  @override
  Future<void> initDanmaku({required DanmakuSettings settings}) async {
    await initialized.future;
    print(settings.toJson());
    await _channel.invokeMethod<void>("initDanmaku", <String, dynamic>{
      "danmakuSettings": settings.toJson(),
    });
  }

  @override
  Future<void> showDanmaku() async {
    await initialized.future;
    await _channel.invokeMethod<void>("showDanmaku");
  }

  @override
  Future<bool> getDanmakuShow() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getDanmakuShow");
    return response!["showDanmaku"];
  }

  @override
  Future<void> hideDanmaku() async {
    await initialized.future;
    await _channel.invokeMethod<void>("hideDanmaku");
  }

  @override
  Future<void> setDanmakuStyle(DanmakuStyle danmakuStyle,
      {double danmuStyleShadow = 0.0,
      double danmuStyleStroked = 0.0,
      double danmuStyleProjectionOffsetX = 0.0,
      double danmuStyleProjectionOffsetY = 0.0,
      double danmuStyleProjectionAlpha = 255.0}) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setDanmakuStyle", <String, dynamic>{
      "danmakuStyle": danmakuStyleToInt(danmakuStyle),
      "danmuStyleShadow": danmuStyleShadow,
      "danmuStyleStroked": danmuStyleStroked,
      "danmuStyleProjectionOffsetX": danmuStyleProjectionOffsetX,
      "danmuStyleProjectionOffsetY": danmuStyleProjectionOffsetY,
      "danmuStyleProjectionAlpha": danmuStyleProjectionAlpha,
    });
  }

  @override
  Future<void> setDanmakuBold(bool bold) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setDanmakuBold", <String, dynamic>{
      "isBold": bold,
    });
  }

  @override
  Future<void> setScrollSpeedFactor(double speedFactor) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setScrollSpeedFactor", <String, dynamic>{
      "speedFactor": speedFactor,
    });
  }

  @override
  Future<void> setDuplicateMergingEnabled(bool enabled) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setDuplicateMergingEnabled", <String, dynamic>{
      "enabled": enabled,
    });
  }

  @override
  Future<void> setMaximumLines(Map<DanmakuTypeScroll, int> maxLinesPair) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setMaximumLines", <String, dynamic>{
      "maxLinesPair": maxLinesPair.map((key, value) => MapEntry(danmakuTypeScrollToInt(key), value)),
    });
  }

  @override
  Future<void> preventOverlapping(Map<DanmakuTypeScroll, bool> preventPair) async {
    await initialized.future;
    await _channel.invokeMethod<void>("preventOverlapping", <String, dynamic>{
      "preventPair": preventPair.map((key, value) => MapEntry(danmakuTypeScrollToInt(key), value)),
    });
  }

  @override
  Future<void> setMarginTop(double marginTop) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setMarginTop", <String, dynamic>{
      "marginTop": marginTop,
    });
  }

  @override
  Future<void> setDanmakuTransparency(double transparency) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setDanmakuTransparency", <String, dynamic>{
      "transparency": transparency,
    });
  }

  @override
  Future<void> setDanmakuMargin(double margin) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setDanmakuMargin", <String, dynamic>{
      "margin": margin,
    });
  }

  @override
  Future<void> setScaleTextSize(double scale) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setScaleTextSize", <String, dynamic>{
      "scale": scale,
    });
  }

  @override
  Future<void> setMaximumVisibleSizeInScreen(MaximumVisibleSizeInScreen maximumVisibleSizeInScreen) async {
    await initialized.future;
    await _channel.invokeMethod<void>("setMaximumVisibleSizeInScreen", <String, dynamic>{
      "maximumVisibleSizeInScreen": getIntFromMaximumVisibleSizeInScreen(maximumVisibleSizeInScreen),
    });
  }

  @override
  Future<void> addDanmaku(BaseDanmaku danmaku) async {
    await initialized.future;
    print(danmaku.toJson());
    await _channel.invokeMethod<void>("addDanmaku", <String, dynamic>{
      "danmaku": danmaku.toJson(),
    });
  }

  @override
  Stream<VideoEvent> videoEventsFor() {
    return eventChannelFor().receiveBroadcastStream().map((dynamic event) {
      late Map<dynamic, dynamic> map;
      if (event is Map) {
        map = event;
      }
      final String? eventType = map["event"] as String?;
      final Map<dynamic, dynamic>? reply = map["reply"];
      switch (eventType) {
        case 'initialized':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          final bool isPlaying = reply["isPlaying"];
          final int width = reply["width"];
          final int height = reply["height"];
          final int videoSarDen = reply["videoSarDen"];
          final int videoSarNum = reply["videoSarNum"];
          return VideoEvent(
            eventType: VideoEventType.initialized,
            isPlaying: isPlaying,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
            size: Size(width.toDouble(), height.toDouble()),
            videoSarDen: videoSarDen,
            videoSarNum: videoSarNum,
          );
        case 'onEventStartPrepared':
          return VideoEvent(eventType: VideoEventType.onEventStartPrepared);
        case 'onEventPrepared':
          return VideoEvent(eventType: VideoEventType.onEventPrepared);
        case 'onEventClickStartIcon':
          return VideoEvent(eventType: VideoEventType.onEventClickStartIcon);
        case 'onEventClickStartError':
          return VideoEvent(eventType: VideoEventType.onEventClickStartError);
        case 'onEventClickStop':
          return VideoEvent(eventType: VideoEventType.onEventClickStop);
        case 'onEventClickStopFullscreen':
          return VideoEvent(eventType: VideoEventType.onEventClickStopFullscreen);
        case 'onEventClickResume':
          return VideoEvent(eventType: VideoEventType.onEventClickResume);
        case 'onEventClickResumeFullscreen':
          return VideoEvent(eventType: VideoEventType.onEventClickResumeFullscreen);
        case 'onEventClickSeekbar':
          return VideoEvent(eventType: VideoEventType.onEventClickSeekbar);
        case 'onEventClickSeekbarFullscreen':
          return VideoEvent(eventType: VideoEventType.onEventClickSeekbarFullscreen);
        case 'onEventAutoComplete':
          return VideoEvent(eventType: VideoEventType.onEventAutoComplete);
        case 'onEventEnterFullscreen':
          return VideoEvent(eventType: VideoEventType.onEventEnterFullscreen);
        case 'onEventQuitFullscreen':
          return VideoEvent(eventType: VideoEventType.onEventQuitFullscreen);
        case 'onEventQuitSmallWidget':
          return VideoEvent(eventType: VideoEventType.onEventQuitSmallWidget);
        case 'onEventEnterSmallWidget':
          return VideoEvent(eventType: VideoEventType.onEventEnterSmallWidget);
        case 'onEventTouchScreenSeekVolume':
          return VideoEvent(eventType: VideoEventType.onEventTouchScreenSeekVolume);
        case 'onEventTouchScreenSeekPosition':
          return VideoEvent(eventType: VideoEventType.onEventTouchScreenSeekPosition);
        case 'onEventTouchScreenSeekLight':
          return VideoEvent(eventType: VideoEventType.onEventTouchScreenSeekLight);
        case 'onEventPlayError':
          return VideoEvent(eventType: VideoEventType.onEventPlayError);
        case 'onEventClickStartThumb':
          return VideoEvent(eventType: VideoEventType.onEventClickStartThumb);
        case 'onEventClickBlank':
          return VideoEvent(eventType: VideoEventType.onEventClickBlank);
        case 'onEventClickBlankFullscreen':
          return VideoEvent(eventType: VideoEventType.onEventClickBlankFullscreen);
        case 'onEventComplete':
          return VideoEvent(eventType: VideoEventType.onEventComplete);
        case 'onEventProgress':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          final bool isPlaying = reply["isPlaying"];

          return VideoEvent(
            eventType: VideoEventType.onEventProgress,
            isPlaying: isPlaying,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerConfigurationChanged':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onListenerConfigurationChanged,
            position: Duration(milliseconds: position),
            isPlaying: isPlaying,
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerPrepared':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onListenerPrepared,
            position: Duration(milliseconds: position),
            isPlaying: isPlaying,
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerAutoCompletion':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          final bool isPlaying = reply["isPlaying"];
          return VideoEvent(
            eventType: VideoEventType.onListenerAutoCompletion,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerCompletion':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];

          final bool isPlaying = reply["isPlaying"];
          return VideoEvent(
            eventType: VideoEventType.onListenerCompletion,
            position: Duration(milliseconds: position),
            isPlaying: isPlaying,
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerBufferingUpdate':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          final int percent = reply["percent"];
          final List<dynamic> values = reply['values'] as List;
          return VideoEvent(
            eventType: VideoEventType.onListenerBufferingUpdate,
            position: Duration(milliseconds: position),
            isPlaying: isPlaying,
            duration: Duration(milliseconds: duration),
            buffered: values.map<DurationRange>(_toDurationRange).toList(),
            playState: getVideoPlayStateName(currentState),
            percent: percent,
          );
        case 'onListenerSeekComplete':
          final int position = reply!["position"];
          final bool isPlaying = reply["isPlaying"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onListenerSeekComplete,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerError':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          final int what = reply["what"];
          final int extra = reply["extra"];
          return VideoEvent(
            eventType: VideoEventType.onListenerError,
            position: Duration(milliseconds: position),
            isPlaying: isPlaying,
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
            what: what,
            extra: extra,
          );
        case 'onListenerInfo':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          final int what = reply["what"];
          final int extra = reply["extra"];
          return VideoEvent(
            eventType: VideoEventType.onListenerInfo,
            position: Duration(milliseconds: position),
            isPlaying: isPlaying,
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
            what: what,
            extra: extra,
          );
        case 'onListenerVideoSizeChanged':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          final bool isPlaying = reply["isPlaying"];
          return VideoEvent(
            eventType: VideoEventType.onListenerVideoSizeChanged,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerBackFullscreen':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          final bool isPlaying = reply["isPlaying"];
          return VideoEvent(
            eventType: VideoEventType.onListenerBackFullscreen,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerVideoPause':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          final bool isPlaying = reply["isPlaying"];
          return VideoEvent(
            eventType: VideoEventType.onListenerVideoPause,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerVideoResume':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onListenerVideoResume,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerVideoResumeWithSeek':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          final bool seek = reply["seek"];
          return VideoEvent(
            eventType: VideoEventType.onListenerVideoResumeWithSeek,
            seek: seek,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerInitDanmakuSuccess':
          return VideoEvent(eventType: VideoEventType.onListenerInitDanmakuSuccess);
        default:
          return VideoEvent(
            eventType: VideoEventType.unknown,
          );
      }
    });
  }
  // flutter有bug 在第一次打开的时候会出现PlatformView被创建已经创建成功但是methodChannel 出现MissingPluginException(No implementation found for method
  // 此处添加轮询进行获取是否初始化完成

  @override
  Widget buildView() {
    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }

  EventChannel eventChannelFor() {
    return EventChannel('gsy_video_player_channel/platform_view_events$textureId');
  }

  DurationRange _toDurationRange(dynamic value) {
    final List<dynamic> pair = value as List;
    return DurationRange(
      Duration(milliseconds: pair[0]),
      Duration(milliseconds: pair[1]),
    );
  }
}

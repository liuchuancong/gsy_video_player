import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:gsy_video_player/gsy_video_player.dart';

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
const _channel = MethodChannel('gsy_video_player_channel/platform_view_methods');

/// An implementation of [VideoPlayerPlatform] that uses method channels.
class MethodChannelVideoPlayer extends VideoPlayerPlatform {
  // Pass parameters to the platform side.

  int? textureId;

  @override
  Future<int?> create() async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMapMethod<String, dynamic>('create');
    textureId = response?['textureId'];
    return textureId;
  }

  @override
  Future<void> init() {
    return _channel.invokeMethod<void>('init');
  }

  @override
  Future<void> dispose(int? textureId) async {
    await _channel.invokeMethod<void>(
      'dispose',
      <String, dynamic>{
        'textureId': textureId,
      },
    );
  }

  @override
  Future<void> setVideoOptionBuilder(int? textureId, VideoOptionBuilder builder) async {
    Map<String, dynamic>? builderParams = builder.toJson();
    await _channel.invokeMethod<void>(
      'setVideoOptionBuilder',
      <String, dynamic>{'textureId': textureId, 'builderParams': builderParams},
    );
  }

  @override
  Future<int> getLayoutId(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>('getLayoutId', <String, dynamic>{
      'textureId': textureId,
    });
    return response!["layoutId"];
  }

  @override
  Future<void> startPlayLogic(int? textureId) async {
    await _channel.invokeMethod<void>('startPlayLogic', <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> setUp(int? textureId, String url, bool cacheWithPlay, String cachePath, String title) async {
    await _channel.invokeMethod<void>(
      'setUp',
      <String, dynamic>{
        'textureId': textureId,
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
  Future<void> onVideoPause(int? textureId) async {
    await _channel.invokeMethod<void>("onVideoPause", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> onVideoResume(int? textureId) async {
    await _channel.invokeMethod<void>("onVideoResume", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> clearCurrentCache(int? textureId) async {
    await _channel.invokeMethod<void>("clearCurrentCache", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<int> getCurrentPositionWhenPlaying(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>('getCurrentPositionWhenPlaying', <String, dynamic>{
      'textureId': textureId,
    });
    return response!["currentPosition"];
  }

  @override
  Future<void> releaseAllVideos(int? textureId) async {
    await _channel.invokeMethod<void>("releaseAllVideos", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<VideoPlayState> getCurrentState(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getCurrentState", <String, dynamic>{
      'textureId': textureId,
    });
    return getVideoPlayStateName(response!["currentState"]);
  }

  @override
  Future<void> setPlayTag(int? textureId, String tag) async {
    await _channel.invokeMethod<void>("setPlayTag", <String, dynamic>{
      'textureId': textureId,
      "playTag": tag,
    });
  }

  @override
  Future<void> setPlayPosition(int? textureId, int position) async {
    await _channel.invokeMethod<void>("setPlayPosition", <String, dynamic>{
      'textureId': textureId,
      "playPosition": position,
    });
  }

  @override
  Future<void> backFromWindowFull(int? textureId) async {
    await _channel.invokeMethod<void>("backFromWindowFull", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<int> getNetSpeed(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getNetSpeed", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["netSpeed"];
  }

  @override
  Future<String> getNetSpeedText(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getNetSpeedText", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["getNetSpeedText"];
  }

  @override
  Future<void> setSeekOnStart(int? textureId, int msec) async {
    await _channel.invokeMethod<void>("setSeekOnStart", <String, dynamic>{
      'textureId': textureId,
      "location": msec,
    });
  }

  @override
  Future<int> getBuffterPoint(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getBuffterPoint", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["buffterPoint"];
  }

  @override
  Future<GsyVideoPlayerType> setCurrentPlayer(int? textureId, GsyVideoPlayerType playerType) async {
    await _channel.invokeMethod<void>(
      'setCurrentPlayer',
      <String, dynamic>{
        'textureId': textureId,
        'playerOptions': {'currentPlayer': getGsyVideoPlayerType(playerType)},
      },
    );
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getPlayManager", <String, dynamic>{
      'textureId': textureId,
    });
    return getVideoPlayerType(response!["currentPlayer"]);
  }

  @override
  Future<GsyVideoPlayerType> getPlayManager(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getPlayManager", <String, dynamic>{
      'textureId': textureId,
    });
    return getVideoPlayerType(response!["currentPlayer"]);
  }

  @override
  Future<void> setExoCacheManager(int? textureId) async {
    await _channel.invokeMethod<void>("setExoCacheManager", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> setProxyCacheManager(int? textureId) async {
    await _channel.invokeMethod<void>("setProxyCacheManager", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> clearAllDefaultCache(int? textureId) async {
    await _channel.invokeMethod<void>("clearAllDefaultCache", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> clearDefaultCache(int? textureId, String cacheDir, String url) async {
    await _channel.invokeMethod<void>(
      "clearDefaultCache",
      <String, dynamic>{
        'textureId': textureId,
        'playOptions': {
          'cacheDir': cacheDir,
          'url': url,
        },
      },
    );
  }

  @override
  Future<void> releaseMediaPlayer(int? textureId) async {
    await _channel.invokeMethod<void>("releaseMediaPlayer", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> onPause(int? textureId) async {
    await _channel.invokeMethod<void>("onPause", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> onResume(int? textureId) async {
    await _channel.invokeMethod<void>("onResume", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<String> getPlayTag(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getPlayTag", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["playTag"];
  }

  @override
  Future<int> getPlayPosition(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getPlayPosition", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["playPosition"];
  }

  @override
  Future<List<IjkOption>> getOptionModelList(int? textureId) async {
    List<IjkOption> optionModelList = [];

    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getOptionModelList", <String, dynamic>{
      'textureId': textureId,
    });

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
  Future<void> setOptionModelList(int? textureId, List<IjkOption> optionModelList) async {
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
        'textureId': textureId,
        'ijkOptions': optionList,
      },
    );
  }

  @override
  Future<bool> isNeedMute(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isNeedMute", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isNeedMute"];
  }

  @override
  Future<void> setNeedMute(int? textureId, bool needMute) async {
    await _channel.invokeMethod<void>("setNeedMute", <String, dynamic>{
      'textureId': textureId,
      "isNeedMute": needMute,
    });
  }

  @override
  Future<int> getTimeOut(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getTimeOut", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["timeOut"];
  }

  @override
  Future<bool> isNeedTimeOutOther(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isNeedTimeOutOther", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isNeedTimeOutOther"];
  }

  @override
  Future<void> setTimeOut(int? textureId, int timeOut, {bool needTimeOutOther = false}) async {
    await _channel.invokeMethod<void>("setNeedMute", <String, dynamic>{
      'textureId': textureId,
      "timeOutOptions": {
        "timeOut": timeOut,
        "needTimeOutOther": needTimeOutOther,
      },
    });
  }

  @override
  Future<void> setLogLevel(int? textureId, LogLevel level) async {
    await _channel.invokeMethod<void>("setLogLevel", <String, dynamic>{
      'textureId': textureId,
      "logLevel": level.index,
    });
  }

  @override
  Future<bool> isMediaCodec(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isMediaCodec", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isMediaCodec"];
  }

  @override
  Future<double> getScreenScaleRatio(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getScreenScaleRatio", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["screenScaleRatio"] as double;
  }

  @override
  Future<void> setScreenScaleRatio(int? textureId, double ratio) async {
    await _channel.invokeMethod<void>("setScreenScaleRatio", <String, dynamic>{
      'textureId': textureId,
      "screenScaleRatio": ratio,
    });
  }

  @override
  Future<bool> isMediaCodecTexture(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isMediaCodecTexture", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isMediaCodecTexture"];
  }

  @override
  Future<PlayerVideoShowType> getShowType(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getShowType", <String, dynamic>{
      'textureId': textureId,
    });
    return getPlayerVideoShowType(response!["type"]);
  }

  @override
  Future<void> setShowType(int? textureId, PlayerVideoShowType showType, {double screenScaleRatio = 0.0}) async {
    await _channel.invokeMethod<void>("setShowType", <String, dynamic>{
      'textureId': textureId,
      "showTypeOptions": {
        "showType": getPlayerVideoShowTypeIntValue(showType),
        "screenScaleRatio": screenScaleRatio,
      },
    });
  }

  @override
  Future<GsyVideoPlayerRenderType> getRenderType(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getRenderType", <String, dynamic>{
      'textureId': textureId,
    });
    return getGsyVideoPlayerRenderType(response!["renderType"]);
  }

  @override
  Future<void> setRenderType(int? textureId, GsyVideoPlayerRenderType renderType) async {
    await _channel.invokeMethod<void>("setRenderType", <String, dynamic>{
      'textureId': textureId,
      "renderType": renderType.index,
    });
  }

  @override
  Future<void> setMediaCodec(int? textureId, bool mediaCodec) async {
    await _channel.invokeMethod<void>("setMediaCodec", <String, dynamic>{
      'textureId': textureId,
      "enableCodec": mediaCodec,
    });
  }

  @override
  Future<void> setMediaCodecTexture(int? textureId, bool mediaCodecTexture) async {
    await _channel.invokeMethod<void>("setMediaCodecTexture", <String, dynamic>{
      'textureId': textureId,
      "enableCodecTexture": mediaCodecTexture,
    });
  }

  @override
  Future<void> startWindowFullscreen(int? textureId) async {
    _channel.invokeMethod<void>("startWindowFullscreen", <String, dynamic>{'textureId': textureId});
  }

  @override
  Future<void> exitWindowFullscreen(int? textureId) async {
    _channel.invokeMethod<void>("exitWindowFullscreen", <String, dynamic>{'textureId': textureId});
  }

  @override
  Future<void> resolveByClick(int? textureId) async {
    await _channel.invokeMethod<void>("resolveByClick", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> backToProtVideo(int? textureId) async {
    await _channel.invokeMethod<void>("backToProtVideo", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<bool> isOrientationRotateEnable(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isOrientationRotateEnable", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isEnable"];
  }

  @override
  Future<void> setOrientationRotateEnable(int? textureId, bool enable) async {
    await _channel.invokeMethod<void>("setOrientationRotateEnable", <String, dynamic>{
      'textureId': textureId,
      "enable": enable,
    });
  }

  @override
  Future<bool> getOrientationRotateIsLand(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getOrientationRotateIsLand", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isLand"];
  }

  @override
  Future<void> setOrientationRotateLand(int? textureId, bool isLand) async {
    await _channel.invokeMethod<void>("setOrientationRotateLand", <String, dynamic>{
      'textureId': textureId,
      "land": isLand,
    });
  }

  @override
  Future<OrientationScreenType> getOrientationRotateScreenType(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getOrientationRotateScreenType", <String, dynamic>{
      'textureId': textureId,
    });
    return getOrientationScreenType(response!["screenType"]);
  }

  @override
  Future<void> setOrientationRotateScreenType(int? textureId, OrientationScreenType screenType) async {
    await _channel.invokeMethod<void>("setOrientationRotateScreenType",
        <String, dynamic>{'textureId': textureId, "screenType": getOrientationScreenTypeIntValue(screenType)});
  }

  @override
  Future<bool> isOrientationRotateClick(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isOrientationRotateClick", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isClick"];
  }

  @override
  Future<void> setOrientationRotateIsClick(int? textureId, bool isClick) async {
    await _channel.invokeMethod<void>("setOrientationRotateIsClick", <String, dynamic>{
      'textureId': textureId,
      "isClick": isClick,
    });
  }

  @override
  Future<bool> isOrientationRotateClickLand(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isOrientationRotateClickLand", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isClickLand"];
  }

  @override
  Future<void> setOrientationRotateIsClickLand(int? textureId, bool isClickLand) async {
    await _channel.invokeMethod<void>("setOrientationRotateIsClickLand", <String, dynamic>{
      'textureId': textureId,
      "isClickLand": isClickLand,
    });
  }

  @override
  Future<bool> isOrientationRotateClickPort(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isOrientationRotateClickPort", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isClickPort"];
  }

  @override
  Future<void> setOrientationRotateIslickPort(int? textureId, bool islickPort) async {
    await _channel.invokeMethod<void>("setOrientationRotateIslickPort", <String, dynamic>{
      'textureId': textureId,
      "islickPort": islickPort,
    });
  }

  @override
  Future<bool> isOrientationRotatePause(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isOrientationRotatePause", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isPause"];
  }

  @override
  Future<void> setOrientationRotateIsPause(int? textureId, bool isPause) async {
    await _channel.invokeMethod<void>("setOrientationRotateIsPause", <String, dynamic>{
      'textureId': textureId,
      "isPause": isPause,
    });
  }

  @override
  Future<bool> isOrientationRotateOnlyRotateLand(int? textureId) async {
    late final Map<String, dynamic>? response;
    response =
        await _channel.invokeMethod<Map<String, dynamic>?>("isOrientationRotateOnlyRotateLand", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isOnlyRotateLand"];
  }

  @override
  Future<void> setOrientationRotateIsOnlyRotateLand(int? textureId, bool isOnlyRotateLand) async {
    await _channel.invokeMethod<void>("setOrientationRotateIsOnlyRotateLand", <String, dynamic>{
      'textureId': textureId,
      "isOnlyRotateLand": isOnlyRotateLand,
    });
  }

  @override
  Future<bool> isOrientationRotateWithSystem(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isOrientationRotateWithSystem", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["rotateWithSystem"];
  }

  @override
  Future<void> setOrientationRotateWithSystem(int? textureId, bool isRotateWithSystem) async {
    await _channel.invokeMethod<void>("setOrientationRotateWithSystem", <String, dynamic>{
      'textureId': textureId,
      "rotateWithSystem": isRotateWithSystem,
    });
  }

  @override
  Future<void> releaseOrientationListener(int? textureId) async {
    await _channel.invokeMethod<void>("releaseOrientationListener", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> showSmallVideo(int? textureId, Size size, bool showActionBar, bool showStatusBar) async {
    _channel.invokeMethod<void>("showSmallVideo", <String, dynamic>{
      'textureId': textureId,
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
  Future<void> hideSmallVideo(int? textureId) async {
    _channel.invokeMethod<void>("hideSmallVideo", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<bool> isShowFullAnimation(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isShowFullAnimation", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isShowFullAnimation"];
  }

  @override
  Future<void> setShowFullAnimation(int? textureId, bool showFullAnimation) async {
    await _channel.invokeMethod<void>("setShowFullAnimation", <String, dynamic>{
      'textureId': textureId,
      "isShowFullAnimation": showFullAnimation,
    });
  }

  @override
  Future<bool> isRotateViewAuto(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isRotateViewAuto", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isRotateViewAuto"];
  }

  @override
  Future<void> setRotateViewAuto(int? textureId, bool rotateViewAuto) async {
    await _channel.invokeMethod<void>("setRotateViewAuto", <String, dynamic>{
      'textureId': textureId,
      "isRotateViewAuto": rotateViewAuto,
    });
  }

  @override
  Future<bool> isLockLand(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isLockLand", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isLockLand"];
  }

  @override
  Future<void> setLockLand(int? textureId, bool lockLand) async {
    await _channel.invokeMethod<void>("setLockLand", <String, dynamic>{
      'textureId': textureId,
      "isLockLand": lockLand,
    });
  }

  @override
  Future<bool> isRotateWithSystem(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isRotateWithSystem", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isRotateWithSystem"];
  }

  @override
  Future<void> setRotateWithSystem(int? textureId, bool rotateWithSystem) async {
    await _channel.invokeMethod<void>("setRotateWithSystem", <String, dynamic>{
      'textureId': textureId,
      "isRotateWithSystem": rotateWithSystem,
    });
  }

  @override
  Future<void> initUIState(int? textureId) async {
    await _channel.invokeMethod<void>("initUIState", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<int> getEnlargeImageRes(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getEnlargeImageRes", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["enlargeImageRes"];
  }

  @override
  Future<void> setEnlargeImageRes(int? textureId, int res) async {
    await _channel.invokeMethod<void>("setEnlargeImageRes", <String, dynamic>{
      'textureId': textureId,
      "enlargeImageRes": res,
    });
  }

  @override
  Future<int> getShrinkImageRes(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getShrinkImageRes", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["shrinkImageRes"];
  }

  @override
  Future<void> setShrinkImageRes(int? textureId, int res) async {
    await _channel.invokeMethod<void>("setShrinkImageRes", <String, dynamic>{
      'textureId': textureId,
      "shrinkImageRes": res,
    });
  }

  @override
  Future<bool> getIsTouchWigetFull(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getIsTouchWigetFull", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isTouchWigetFull"];
  }

  @override
  Future<void> setIsTouchWigetFull(int? textureId, bool isTouchWigetFull) async {
    await _channel.invokeMethod<void>("setIsTouchWigetFull", <String, dynamic>{
      'textureId': textureId,
      "isTouchWigetFull": isTouchWigetFull,
    });
  }

  @override
  Future<void> setThumbPlay(int? textureId, bool thumbPlay) async {
    await _channel.invokeMethod<void>("setThumbPlay", <String, dynamic>{
      'textureId': textureId,
      "thumbPlay": thumbPlay,
    });
  }

  @override
  Future<bool> isHideKeyBoard(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isHideKeyBoard", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isHideKeyBoard"];
  }

  @override
  Future<void> setHideKeyBoard(int? textureId, bool hideKeyBoard) async {
    await _channel.invokeMethod<void>("setHideKeyBoard", <String, dynamic>{
      'textureId': textureId,
      "isHideKeyBoard": hideKeyBoard,
    });
  }

  @override
  Future<bool> isNeedShowWifiTip(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isNeedShowWifiTip", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isNeedShowWifiTip"];
  }

  @override
  Future<void> setNeedShowWifiTip(int? textureId, bool needShowWifiTip) async {
    await _channel.invokeMethod<void>("setNeedShowWifiTip", <String, dynamic>{
      'textureId': textureId,
      "isNeedShowWifiTip": needShowWifiTip,
    });
  }

  @override
  Future<bool> isTouchWiget(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isTouchWiget", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isTouchWiget"];
  }

  @override
  Future<void> setTouchWiget(int? textureId, bool touchWiget) async {
    await _channel.invokeMethod<void>("setTouchWiget", <String, dynamic>{
      'textureId': textureId,
      "isTouchWiget": touchWiget,
    });
  }

  @override
  Future<double> getSeekRatio(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getSeekRatio", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["seekRatio"] as double;
  }

  @override
  Future<void> setSeekRatio(int? textureId, double seekRatio) async {
    await _channel.invokeMethod<void>("setSeekRatio", <String, dynamic>{
      'textureId': textureId,
      "seekRatio": seekRatio,
    });
  }

  @override
  Future<bool> isNeedLockFull(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isNeedLockFull", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isNeedLockFull"];
  }

  @override
  Future<void> setNeedLockFull(int? textureId, bool needLockFull) async {
    await _channel.invokeMethod<void>("setNeedLockFull", <String, dynamic>{
      'textureId': textureId,
      "isNeedLockFull": needLockFull,
    });
  }

  @override
  Future<int> getDismissControlTime(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getDismissControlTime", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isNeedLockFull"];
  }

  @override
  Future<void> setDismissControlTime(int? textureId, int time) async {
    await _channel.invokeMethod<void>("setDismissControlTime", <String, dynamic>{
      'textureId': textureId,
      "dismissControlTime": time,
    });
  }

  @override
  Future<int> getSeekOnStart(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getSeekOnStart", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["seekOnStart"];
  }

  @override
  Future<bool> isIfCurrentIsFullscreen(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isIfCurrentIsFullscreen", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isIfCurrentIsFullscreen"];
  }

  @override
  Future<void> setIfCurrentIsFullscreen(int? textureId, bool ifCurrentIsFullscreen) async {
    await _channel.invokeMethod<void>("setIfCurrentIsFullscreen", <String, dynamic>{
      'textureId': textureId,
      "isIfCurrentIsFullscreen": ifCurrentIsFullscreen,
    });
  }

  @override
  Future<bool> isLooping(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isLooping", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isLooping"];
  }

  @override
  Future<void> setLooping(int? textureId, bool looping) async {
    await _channel.invokeMethod<void>("setLooping", <String, dynamic>{
      'textureId': textureId,
      "isLooping": looping,
    });
  }

  @override
  Future<double> getSpeed(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getSpeed", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["speed"] as double;
  }

  @override
  Future<void> setSpeed(int? textureId, double speed, {bool soundTouch = true}) async {
    await _channel.invokeMethod<void>("setSpeed", <String, dynamic>{
      'textureId': textureId,
      "speedOptions": {"speed": 1.0, "soundTouch": soundTouch},
    });
  }

  @override
  Future<void> setSpeedPlaying(int? textureId, double speed, {bool soundTouch = true}) async {
    await _channel.invokeMethod<void>("setSpeedPlaying", <String, dynamic>{
      'textureId': textureId,
      "speedPlayingOptions": {"speed": 1.0, "soundTouch": soundTouch},
    });
  }

  @override
  Future<bool> isShowPauseCover(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isShowPauseCover", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isShowPauseCover"];
  }

  @override
  Future<void> setShowPauseCover(int? textureId, bool showPauseCover) async {
    await _channel.invokeMethod<void>("setShowPauseCover", <String, dynamic>{
      'textureId': textureId,
      "isShowPauseCover": showPauseCover,
    });
  }

  @override
  Future<void> seekTo(int? textureId, int msec) async {
    await _channel.invokeMethod<void>("seekTo", <String, dynamic>{
      'textureId': textureId,
      "position": msec,
    });
  }

  @override
  Future<void> setMatrixGL(int? textureId, List<double> matrix) async {
    await _channel.invokeMethod<void>("seekTo", <String, dynamic>{
      'textureId': textureId,
      "matrix": matrix,
    });
  }

  @override
  Future<void> releaseWhenLossAudio(int? textureId) async {
    await _channel.invokeMethod<void>("releaseWhenLossAudio", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> setAutoFullWithSize(int? textureId, bool releaseWhenLossAudio) async {
    await _channel.invokeMethod<void>("setAutoFullWithSize", <String, dynamic>{
      'textureId': textureId,
      "autoFullWithSize": releaseWhenLossAudio,
    });
  }

  @override
  Future<bool> getAutoFullWithSize(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("autoFullWithSize", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["autoFullWithSize"];
  }

  @override
  Future<void> setVolume(int? textureId, double volume) async {
    await _channel.invokeMethod<void>("setVolume", <String, dynamic>{
      'textureId': textureId,
      "volume": volume,
    });
  }

  @override
  Future<void> initDanmaku(int? textureId, {required DanmakuSettings settings}) async {
    await _channel.invokeMethod<void>("initDanmaku", <String, dynamic>{
      'textureId': textureId,
      "danmakuSettings": settings.toJson(),
    });
  }

  @override
  Future<void> showDanmaku(int? textureId) async {
    await _channel.invokeMethod<void>("showDanmaku", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<bool> getDanmakuShow(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getDanmakuShow", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["showDanmaku"];
  }

  @override
  Future<void> hideDanmaku(int? textureId) async {
    await _channel.invokeMethod<void>("hideDanmaku", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> setDanmakuStyle(int? textureId, DanmakuStyle danmakuStyle,
      {double danmuStyleShadow = 0.0,
      double danmuStyleStroked = 0.0,
      double danmuStyleProjectionOffsetX = 0.0,
      double danmuStyleProjectionOffsetY = 0.0,
      double danmuStyleProjectionAlpha = 255.0}) async {
    await _channel.invokeMethod<void>("setDanmakuStyle", <String, dynamic>{
      'textureId': textureId,
      "danmakuStyle": danmakuStyleToInt(danmakuStyle),
      "danmuStyleShadow": danmuStyleShadow,
      "danmuStyleStroked": danmuStyleStroked,
      "danmuStyleProjectionOffsetX": danmuStyleProjectionOffsetX,
      "danmuStyleProjectionOffsetY": danmuStyleProjectionOffsetY,
      "danmuStyleProjectionAlpha": danmuStyleProjectionAlpha,
    });
  }

  @override
  Future<void> setDanmakuBold(int? textureId, bool bold) async {
    await _channel.invokeMethod<void>("setDanmakuBold", <String, dynamic>{
      'textureId': textureId,
      "isBold": bold,
    });
  }

  @override
  Future<void> setScrollSpeedFactor(int? textureId, double speedFactor) async {
    await _channel.invokeMethod<void>("setScrollSpeedFactor", <String, dynamic>{
      'textureId': textureId,
      "speedFactor": speedFactor,
    });
  }

  @override
  Future<void> setDuplicateMergingEnabled(int? textureId, bool enabled) async {
    await _channel.invokeMethod<void>("setDuplicateMergingEnabled", <String, dynamic>{
      'textureId': textureId,
      "enabled": enabled,
    });
  }

  @override
  Future<void> setMaximumLines(int? textureId, Map<DanmakuTypeScroll, int> maxLinesPair) async {
    await _channel.invokeMethod<void>("setMaximumLines", <String, dynamic>{
      'textureId': textureId,
      "maxLinesPair": maxLinesPair.map((key, value) => MapEntry(danmakuTypeScrollToInt(key), value)),
    });
  }

  @override
  Future<void> preventOverlapping(int? textureId, Map<DanmakuTypeScroll, bool> preventPair) async {
    await _channel.invokeMethod<void>("preventOverlapping", <String, dynamic>{
      'textureId': textureId,
      "preventPair": preventPair.map((key, value) => MapEntry(danmakuTypeScrollToInt(key), value)),
    });
  }

  @override
  Future<void> setMarginTop(int? textureId, double marginTop) async {
    await _channel.invokeMethod<void>("setMarginTop", <String, dynamic>{
      'textureId': textureId,
      "marginTop": marginTop,
    });
  }

  @override
  Future<void> setDanmakuTransparency(int? textureId, double transparency) async {
    await _channel.invokeMethod<void>("setDanmakuTransparency", <String, dynamic>{
      'textureId': textureId,
      "transparency": transparency,
    });
  }

  @override
  Future<void> setDanmakuMargin(int? textureId, double margin) async {
    await _channel.invokeMethod<void>("setDanmakuMargin", <String, dynamic>{
      'textureId': textureId,
      "margin": margin,
    });
  }

  @override
  Future<void> setScaleTextSize(int? textureId, double scale) async {
    await _channel.invokeMethod<void>("setScaleTextSize", <String, dynamic>{
      'textureId': textureId,
      "scale": scale,
    });
  }

  @override
  Future<void> setMaximumVisibleSizeInScreen(
      int? textureId, MaximumVisibleSizeInScreen maximumVisibleSizeInScreen) async {
    await _channel.invokeMethod<void>("setMaximumVisibleSizeInScreen", <String, dynamic>{
      'textureId': textureId,
      "maximumVisibleSizeInScreen": getIntFromMaximumVisibleSizeInScreen(maximumVisibleSizeInScreen),
    });
  }

  @override
  Future<void> addDanmaku(int? textureId, BaseDanmaku danmaku) async {
    await _channel.invokeMethod<void>("addDanmaku", <String, dynamic>{
      'textureId': textureId,
      "danmaku": danmaku.toJson(),
    });
  }

  @override
  Future<void> startDanmaku(int? textureId) async {
    await _channel.invokeMethod<void>("startDanmaku", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> pauseDanmaku(int? textureId) async {
    await _channel.invokeMethod<void>("pauseDanmaku", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> resumeDanmaku(int? textureId) async {
    await _channel.invokeMethod<void>("resumeDanmaku", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> stopDanmaku(int? textureId) async {
    await _channel.invokeMethod<void>("stopDanmaku", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> seekToDanmaku(int? textureId, Duration msec) async {
    await _channel.invokeMethod<void>("seekToDanmaku", <String, dynamic>{
      'textureId': textureId,
      "ms": msec.inMilliseconds,
    });
  }

  @override
  Future<Map<String, dynamic>> getDanmakuStatus(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getDanmakuStatus", <String, dynamic>{
      'textureId': textureId,
    });
    return response!;
  }

  @override
  Future<void> enablePictureInPicture(int? textureId, double? top, double? left, double? width, double? height) async {
    return _channel.invokeMethod<void>(
      'enablePictureInPicture',
      <String, dynamic>{
        'textureId': textureId,
        'top': top,
        'left': left,
        'width': width,
        'height': height,
      },
    );
  }

  @override
  Future<bool?> isPictureInPictureEnabled(int? textureId) {
    return _channel.invokeMethod<bool>(
      'isPictureInPictureSupported',
      <String, dynamic>{
        'textureId': textureId,
      },
    );
  }

  @override
  Future<void> disablePictureInPicture(int? textureId) {
    return _channel.invokeMethod<bool>(
      'disablePictureInPicture',
      <String, dynamic>{
        'textureId': textureId,
      },
    );
  }

  @override
  Stream<VideoEvent> videoEventsFor(int? textureId) {
    return eventChannelFor().receiveBroadcastStream().map((dynamic event) {
      late Map<dynamic, dynamic> map;
      if (event is Map) {
        map = event;
      }
      final String? eventType = map["event"] as String?;
      final Map<dynamic, dynamic>? reply = map["reply"];
      switch (eventType) {
        case 'initialized':
          return VideoEvent(
            eventType: VideoEventType.initialized,
          );
        case 'videoPlayerInitialized':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          final bool isPlaying = reply["isPlaying"];
          final int width = reply["width"];
          final int height = reply["height"];
          final int videoSarDen = reply["videoSarDen"];
          final int videoSarNum = reply["videoSarNum"];
          return VideoEvent(
            eventType: VideoEventType.videoPlayerInitialized,
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
          return VideoEvent(
            eventType: VideoEventType.onListenerCompletion,
            position: Duration(milliseconds: position),
            isPlaying: false,
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
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onListenerSeekComplete,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: false,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerError':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          final int what = reply["what"];
          final int extra = reply["extra"];
          return VideoEvent(
            eventType: VideoEventType.onListenerError,
            position: Duration(milliseconds: position),
            isPlaying: false,
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
          return VideoEvent(
            eventType: VideoEventType.onListenerVideoPause,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: false,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerVideoResume':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onListenerVideoResume,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: true,
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
        case 'onFullButtonClick':
          final int position = reply!["position"];
          final int duration = reply["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onFullButtonClick,
            position: Duration(milliseconds: position),
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onListenerInitDanmakuSuccess':
          return VideoEvent(eventType: VideoEventType.onListenerInitDanmakuSuccess);
        case 'pipStart':
          return VideoEvent(
            eventType: VideoEventType.pipStart,
          );
        case 'pipStop':
          return VideoEvent(
            eventType: VideoEventType.pipStop,
          );

        case "startWindowFullscreen":
          return VideoEvent(
            eventType: VideoEventType.startWindowFullscreen,
          );
        case "exitWindowFullscreen":
          return VideoEvent(
            eventType: VideoEventType.exitWindowFullscreen,
          );
        default:
          return VideoEvent(
            eventType: VideoEventType.unknown,
          );
      }
    });
  }

  @override
  Widget buildView(textureId, {void Function(int)? onViewReady}) {
    return Texture(textureId: textureId);
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

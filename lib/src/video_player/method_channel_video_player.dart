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
  Future<int?> create({double? width, double? height}) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMapMethod<String, dynamic>('create', <String, dynamic>{
      'width': width,
      'height': height,
    });
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
  Future<GsyVideoPlayerType> setPlayerFactory(int? textureId, GsyVideoPlayerType playerType) async {
    await _channel.invokeMethod<void>(
      'setPlayerFactory',
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
  Future<GsyVideoPlayerType> getPlayFactory(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("getPlayFactory", <String, dynamic>{
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
  Future<void> pause(int? textureId) async {
    await _channel.invokeMethod<void>("pause", <String, dynamic>{
      'textureId': textureId,
    });
  }

  @override
  Future<void> resume(int? textureId) async {
    await _channel.invokeMethod<void>("resume", <String, dynamic>{
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
  Future<Duration> getPlayPosition(int? textureId) async {
    late Map<dynamic, dynamic> map;
    map = await _channel.invokeMethod("getPlayPosition", <String, dynamic>{
      'textureId': textureId,
    });
    return Duration(milliseconds: map["playPosition"] ?? 0);
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
        'valueInt': option.valueInt,
        'value': option.value,
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
  Future<void> releaseOrientation(int? textureId) async {
    await _channel.invokeMethod<void>("releaseOrientation", <String, dynamic>{
      'textureId': textureId,
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
      "speedOptions": {"speed": speed, "soundTouch": soundTouch},
    });
  }

  @override
  Future<void> setSpeedPlaying(int? textureId, double speed, {bool soundTouch = true}) async {
    await _channel.invokeMethod<void>("setSpeedPlaying", <String, dynamic>{
      'textureId': textureId,
      "speedPlayingOptions": {"speed": speed, "soundTouch": soundTouch},
    });
  }

  Future<bool> isShowPauseCover(int? textureId) async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMethod<Map<String, dynamic>?>("isShowPauseCover", <String, dynamic>{
      'textureId': textureId,
    });
    return response!["isShowPauseCover"];
  }

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

  Future<void> setAutoFullWithSize(int? textureId, bool releaseWhenLossAudio) async {
    await _channel.invokeMethod<void>("setAutoFullWithSize", <String, dynamic>{
      'textureId': textureId,
      "autoFullWithSize": releaseWhenLossAudio,
    });
  }

  @override
  Future<void> setVolume(int? textureId, double volume) async {
    await _channel.invokeMethod<void>("setVolume", <String, dynamic>{
      'textureId': textureId,
      "volume": volume,
    });
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
      final bool isBuffering = reply == null ? false : reply["isBuffering"] ?? false;
      switch (eventType) {
        case 'initialized':
          return VideoEvent(
            eventType: VideoEventType.initialized,
          );
        case 'onVideoPlayerInitialized':
          final int duration = reply!["duration"];
          final int currentState = reply["currentState"];
          final bool isPlaying = reply["isPlaying"];
          final int width = reply["width"];
          final int height = reply["height"];
          final int videoSarDen = reply["videoSarDen"];
          final int videoSarNum = reply["videoSarNum"];
          return VideoEvent(
            eventType: VideoEventType.onVideoPlayerInitialized,
            isPlaying: isPlaying,
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
            size: Size(width.toDouble(), height.toDouble()),
            isBuffering: isBuffering,
            videoSarDen: videoSarDen,
            videoSarNum: videoSarNum,
          );
        case 'onConfigurationChanged':
          final int duration = reply!["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onConfigurationChanged,
            isPlaying: isPlaying,
            isBuffering: isBuffering,
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
          );
        case 'onPrepared':
          final int duration = reply!["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onPrepared,
            isPlaying: isPlaying,
            duration: Duration(milliseconds: duration),
            isBuffering: isBuffering,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onAutoCompletion':
          final int duration = reply!["duration"];
          final int currentState = reply["currentState"];
          final bool isPlaying = reply["isPlaying"];
          return VideoEvent(
            eventType: VideoEventType.onAutoCompletion,
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onCompletion':
          final int duration = reply!["duration"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onCompletion,
            isPlaying: false,
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
          );
        case 'onBufferingUpdate':
          final int duration = reply!["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          final int bufferPercent = reply["bufferPercent"];
          final List<dynamic> values = [
            [0, (duration * bufferPercent / 100).ceil()]
          ];
          return VideoEvent(
            eventType: VideoEventType.onBufferingUpdate,
            isPlaying: isPlaying,
            duration: Duration(milliseconds: duration),
            buffered: values.map<DurationRange>(_toDurationRange).toList(),
            playState: getVideoPlayStateName(currentState),
            isBuffering: isBuffering,
            bufferPercent: bufferPercent,
          );
        case 'onBufferingEnd':
          final int duration = reply!["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onBufferingEnd,
            isPlaying: isPlaying,
            duration: Duration(milliseconds: duration),
            isBuffering: isBuffering,
            bufferPercent: 100,
            buffered: [0, duration].map<DurationRange>(_toDurationRange).toList(),
            playState: getVideoPlayStateName(currentState),
          );

        case 'onSeekComplete':
          final int duration = reply!["duration"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onSeekComplete,
            duration: Duration(milliseconds: duration),
            isPlaying: false,
            isBuffering: isBuffering,
            playState: getVideoPlayStateName(currentState),
          );

        case 'onError':
          final int duration = reply!["duration"];
          final int currentState = reply["currentState"];
          final int what = reply["what"];
          final int extra = reply["extra"];
          return VideoEvent(
            eventType: VideoEventType.onError,
            isPlaying: false,
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
            what: what,
            extra: extra,
          );
        case 'onInfo':
          final int duration = reply!["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          final int what = reply["what"];
          final int extra = reply["extra"];
          return VideoEvent(
            eventType: VideoEventType.onInfo,
            isPlaying: isPlaying,
            isBuffering: isBuffering,
            duration: Duration(milliseconds: duration),
            playState: getVideoPlayStateName(currentState),
            what: what,
            extra: extra,
          );
        case 'onVideoSizeChanged':
          final int duration = reply!["duration"];
          final int currentState = reply["currentState"];
          final bool isPlaying = reply["isPlaying"];
          final int width = reply["width"];
          final int height = reply["height"];
          return VideoEvent(
            eventType: VideoEventType.onVideoSizeChanged,
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            isBuffering: isBuffering,
            size: Size(width.toDouble(), height.toDouble()),
            playState: getVideoPlayStateName(currentState),
          );
        case 'onVideoPause':
          final int duration = reply!["duration"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onVideoPause,
            duration: Duration(milliseconds: duration),
            isPlaying: false,
            isBuffering: isBuffering,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onVideoResume':
          final int duration = reply!["duration"];
          final int currentState = reply["currentState"];
          return VideoEvent(
            eventType: VideoEventType.onVideoResume,
            duration: Duration(milliseconds: duration),
            isPlaying: true,
            isBuffering: isBuffering,
            playState: getVideoPlayStateName(currentState),
          );
        case 'onVideoResumeWithSeek':
          final int duration = reply!["duration"];
          final bool isPlaying = reply["isPlaying"];
          final int currentState = reply["currentState"];
          final bool seek = reply["seek"];
          return VideoEvent(
            eventType: VideoEventType.onVideoResumeWithSeek,
            seek: seek,
            duration: Duration(milliseconds: duration),
            isPlaying: isPlaying,
            isBuffering: isBuffering,
            playState: getVideoPlayStateName(currentState),
          );
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

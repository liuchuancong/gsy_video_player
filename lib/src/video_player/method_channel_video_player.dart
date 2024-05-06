import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'video_player_platform_interface.dart';
import 'package:gsy_video_player/src/builder/video_option_builder.dart';
import 'package:gsy_video_player/src/configuration/player_video_type.dart';
import 'package:gsy_video_player/src/configuration/player_video_show_type.dart';
import 'package:gsy_video_player/src/configuration/player_video_render_type.dart';

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
        textureId = response?['textureId'] as int?;
        initialized.complete(textureId);
        _timer?.cancel();
        // ignore: empty_catches
      } catch (e) {}
    });
  }

  @override
  Future<void> setMediaCodec(bool enableCodec) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'enableCodec',
      <String, dynamic>{"enableCodec": enableCodec},
    );
  }

  @override
  Future<void> setMediaCodecTexture(bool enableCodecTexture) {
    return _channel.invokeMethod<void>(
      'enableCodecTexture',
      <String, dynamic>{"enableCodecTexture": enableCodecTexture},
    );
  }

  @override
  Future<void> init(
      {GsyVideoPlayerType playerType = GsyVideoPlayerType.exo,
      GsyVideoPlayerRenderType renderType = GsyVideoPlayerRenderType.textureView}) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'init',
      <String, dynamic>{
        "playerOptions": {
          'playerType': playerType.index,
          'renderType': renderType.index,
        }
      },
    );
  }

  /// 设置显示比例,注意，这是全局生效的 画面比例 宽高比 PlayerVideoShowType.screenTypeCustom screenScaleRatio 为必传参数 否则为默认
  @override
  Future<void> setShowType(PlayerVideoShowType showType, {double? screenScaleRatio}) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'setShowType',
      <String, dynamic>{
        "showTypeOptions": {"showType": showType.index, "screenScaleRatio": screenScaleRatio}
      },
    );
  }

  @override
  Future<void> dispose() async {
    await initialized.future;
    return _channel.invokeMethod<void>('dispose');
  }

  @override
  Future<int?> create() async {
    await initialized.future;
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMapMethod<String, dynamic>('create');
    textureId = response?['textureId'] as int?;
    return textureId;
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
    return;
  }

  @override
  Future<void> setLooping(bool looping) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'setLooping',
      <String, dynamic>{
        'isLooping': looping,
      },
    );
  }

  @override
  Future<void> play() async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'play',
    );
  }

  @override
  Future<void> pause() async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'pause',
    );
  }

  @override
  Future<void> resume() async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'resume',
    );
  }

  @override
  Future<void> setVolume(double volume) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'setVolume',
      <String, dynamic>{
        'volume': volume,
      },
    );
  }

  @override
  Future<void> setSpeed(double speed) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'setSpeed',
      <String, dynamic>{
        'speed': speed,
      },
    );
  }

  @override
  Future<void> setTrackParameters(int? width, int? height, int? bitrate) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'setTrackParameters',
      <String, dynamic>{
        'width': width,
        'height': height,
        'bitrate': bitrate,
      },
    );
  }

  @override
  Future<void> seekTo(Duration? position) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'seekTo',
      <String, dynamic>{
        'location': position!.inMilliseconds,
      },
    );
  }

  @override
  Future<Duration> getPosition() async {
    await initialized.future;
    return Duration(
        milliseconds: await _channel.invokeMethod<int>(
              'position',
            ) ??
            0);
  }

  @override
  Future<DateTime?> getAbsolutePosition() async {
    await initialized.future;
    final int milliseconds = await _channel.invokeMethod<int>(
          'absolutePosition',
        ) ??
        0;
    if (milliseconds > 8640000000000000 || milliseconds < -8640000000000000) return null;
    if (milliseconds <= 0) return null;

    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  @override
  Future<void> enablePictureInPicture(double? top, double? left, double? width, double? height) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'enablePictureInPicture',
      <String, dynamic>{
        'top': top,
        'left': left,
        'width': width,
        'height': height,
      },
    );
  }

  @override
  Future<bool?> isPictureInPictureEnabled() async {
    await initialized.future;
    return _channel.invokeMethod<bool>(
      'isPictureInPictureSupported',
      <String, dynamic>{},
    );
  }

  @override
  Future<bool?> disablePictureInPicture() async {
    await initialized.future;
    return _channel.invokeMethod<bool>(
      'disablePictureInPicture',
      <String, dynamic>{},
    );
  }

  @override
  Future<void> setAudioTrack(String? name, int? index) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'setAudioTrack',
      <String, dynamic>{
        'name': name,
        'index': index,
      },
    );
  }

  @override
  Future<void> setMixWithOthers(bool mixWithOthers) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'setMixWithOthers',
      <String, dynamic>{
        'mixWithOthers': mixWithOthers,
      },
    );
  }

  @override
  Future<void> clearCache() async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'clearCache',
      <String, dynamic>{},
    );
  }

  Future<void> stopPreCache(String url, String? cacheKey) async {
    await initialized.future;
    return _channel.invokeMethod<void>(
      'stopPreCache',
      <String, dynamic>{'url': url, 'cacheKey': cacheKey},
    );
  }

  @override
  Stream<VideoEvent> videoEventsFor() {
    return eventChannelFor().receiveBroadcastStream().map((dynamic event) {
      print(event.toString());
      late Map<dynamic, dynamic> map;
      if (event is Map) {
        map = event;
      }
      final String? eventType = map["event"] as String?;
      final String? key = map["key"] as String?;
      switch (eventType) {
        case 'initialized':
          double width = 0;
          double height = 0;

          try {
            if (map.containsKey("width")) {
              final num widthNum = map["width"] as num;
              width = widthNum.toDouble();
            }
            if (map.containsKey("height")) {
              final num heightNum = map["height"] as num;
              height = heightNum.toDouble();
            }
          } catch (exception) {
            debugPrint(exception.toString());
          }

          final Size size = Size(width, height);

          return VideoEvent(
            eventType: VideoEventType.initialized,
            key: key,
            duration: Duration(milliseconds: map['duration'] as int),
            size: size,
          );
        case 'completed':
          return VideoEvent(
            eventType: VideoEventType.completed,
            key: key,
          );
        case 'bufferingUpdate':
          final List<dynamic> values = map['values'] as List;

          return VideoEvent(
            eventType: VideoEventType.bufferingUpdate,
            key: key,
            buffered: values.map<DurationRange>(_toDurationRange).toList(),
          );
        case 'bufferingStart':
          return VideoEvent(
            eventType: VideoEventType.bufferingStart,
            key: key,
          );
        case 'bufferingEnd':
          return VideoEvent(
            eventType: VideoEventType.bufferingEnd,
            key: key,
          );

        case 'play':
          return VideoEvent(
            eventType: VideoEventType.play,
            key: key,
          );

        case 'pause':
          return VideoEvent(
            eventType: VideoEventType.pause,
            key: key,
          );

        case 'seek':
          return VideoEvent(
            eventType: VideoEventType.seek,
            key: key,
            position: Duration(milliseconds: map['position'] as int),
          );

        case 'pipStart':
          return VideoEvent(
            eventType: VideoEventType.pipStart,
            key: key,
          );

        case 'pipStop':
          return VideoEvent(
            eventType: VideoEventType.pipStop,
            key: key,
          );

        default:
          return VideoEvent(
            eventType: VideoEventType.unknown,
            key: key,
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
      Duration(milliseconds: pair[0] as int),
      Duration(milliseconds: pair[1] as int),
    );
  }
}

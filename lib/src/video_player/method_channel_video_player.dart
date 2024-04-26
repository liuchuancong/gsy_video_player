import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'video_player_platform_interface.dart';
import 'package:gsy_video_player/src/builder/video_option_builder.dart';

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
const _channel = MethodChannel('gsy_video_player_channel/platform_view_methods');

/// An implementation of [VideoPlayerPlatform] that uses method channels.
class MethodChannelVideoPlayer extends VideoPlayerPlatform {
  String viewType = 'gsy_video_player_channel/platform_view';
  // Pass parameters to the platform side.
  Map<String, dynamic> creationParams = <String, dynamic>{};

  @override
  Future<void> init() {
    return _channel.invokeMethod<void>('init');
  }

  @override
  Future<void> dispose() {
    return _channel.invokeMethod<void>('dispose');
  }

  @override
  Future<int?> create() async {
    late final Map<String, dynamic>? response;
    response = await _channel.invokeMapMethod<String, dynamic>('create');
    print(response.toString());
    return response?['textureId'] as int?;
  }

  @override
  Future<void> setVideoOptionBuilder(VideoOptionBuilder builder) async {
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
  Future<void> setLooping(bool looping) {
    return _channel.invokeMethod<void>(
      'setLooping',
      <String, dynamic>{
        'looping': looping,
      },
    );
  }

  @override
  Future<void> play() {
    return _channel.invokeMethod<void>(
      'play',
    );
  }

  @override
  Future<void> pause() {
    return _channel.invokeMethod<void>(
      'pause',
    );
  }

  @override
  Future<void> setVolume(double volume) {
    return _channel.invokeMethod<void>(
      'setVolume',
      <String, dynamic>{
        'volume': volume,
      },
    );
  }

  @override
  Future<void> setSpeed(double speed) {
    return _channel.invokeMethod<void>(
      'setSpeed',
      <String, dynamic>{
        'speed': speed,
      },
    );
  }

  @override
  Future<void> setTrackParameters(int? width, int? height, int? bitrate) {
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
  Future<void> seekTo(Duration? position) {
    return _channel.invokeMethod<void>(
      'seekTo',
      <String, dynamic>{
        'location': position!.inMilliseconds,
      },
    );
  }

  @override
  Future<Duration> getPosition() async {
    return Duration(
        milliseconds: await _channel.invokeMethod<int>(
              'position',
            ) ??
            0);
  }

  @override
  Future<DateTime?> getAbsolutePosition() async {
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
  Future<bool?> isPictureInPictureEnabled() {
    return _channel.invokeMethod<bool>(
      'isPictureInPictureSupported',
      <String, dynamic>{},
    );
  }

  @override
  Future<void> disablePictureInPicture() {
    return _channel.invokeMethod<bool>(
      'disablePictureInPicture',
      <String, dynamic>{},
    );
  }

  @override
  Future<void> setAudioTrack(String? name, int? index) {
    return _channel.invokeMethod<void>(
      'setAudioTrack',
      <String, dynamic>{
        'name': name,
        'index': index,
      },
    );
  }

  @override
  Future<void> setMixWithOthers(bool mixWithOthers) {
    return _channel.invokeMethod<void>(
      'setMixWithOthers',
      <String, dynamic>{
        'mixWithOthers': mixWithOthers,
      },
    );
  }

  @override
  Future<void> clearCache() {
    return _channel.invokeMethod<void>(
      'clearCache',
      <String, dynamic>{},
    );
  }

  Future<void> stopPreCache(String url, String? cacheKey) {
    return _channel.invokeMethod<void>(
      'stopPreCache',
      <String, dynamic>{'url': url, 'cacheKey': cacheKey},
    );
  }

  @override
  Stream<VideoEvent> videoEventsFor() {
    return eventChannelFor().receiveBroadcastStream().map((dynamic event) {
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
    return const EventChannel('gsy_video_player_channel/platform_view_methods');
  }

  DurationRange _toDurationRange(dynamic value) {
    final List<dynamic> pair = value as List;
    return DurationRange(
      Duration(milliseconds: pair[0] as int),
      Duration(milliseconds: pair[1] as int),
    );
  }
}

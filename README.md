# gsy_video_player

视频播放器（IJKplayer、ExoPlayer、MediaPlayer），HTTPS，支持弹幕，外挂字幕，支持滤镜、水印、gif截图，片头广告、中间广告，多个同时播放，支持基本的拖动，声音、亮度调节，支持边播边缓存，支持视频自带rotation的旋转（90,270之类），重力旋转与手动旋转的同步支持，支持列表播放 ，列表全屏动画，视频加载速度，列表小窗口支持拖动，动画效果，调整比例，多分辨率切换，支持切换播放器，进度条小窗口预览，列表切换详情页面无缝播放，rtsp、concat、mpeg。

## Getting Started

https://github.com/CarGuo/GSYVideoPlayer/wiki


## Usage

To use this plugin, add `gsy_video_player` as a dependency in your pubspec.yaml file.

```yaml
dependencies:
  gsy_video_player: ^0.0.2+1
```


## Example

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gsy_video_player/gsy_video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GsyVideoPlayerController gsyVideoPlayerController = GsyVideoPlayerController();

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlayer() async {
    gsyVideoPlayerController.setLogLevel(LogLevel.logError);
    gsyVideoPlayerController
        .setNetWorkBuilder('https://cloud.video.taobao.com//play/u/27349687/p/1/e/6/t/1/239880949246.mp4');
    gsyVideoPlayerController.addEventsListener((VideoEventType event) {
      if (gsyVideoPlayerController.value.initialized) {
        if (event == VideoEventType.onListenerError) {
          print('gsyVideoPlayerController: ${gsyVideoPlayerController.value.toString()}');
          print('gsyVideoPlayerController: ${gsyVideoPlayerController.value.what}');
          print('gsyVideoPlayerController: ${gsyVideoPlayerController.value.extra}');
          print(mediaErrorCategoryForInt(gsyVideoPlayerController.value.what!));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 300,
              child: Container(
                color: Colors.blue,
                child: GsyVideoPlayer(
                  controller: gsyVideoPlayerController,
                ),
              ),
            ),
            Wrap(
              children: [
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.startPlayLogic();
                    },
                    child: const Text('play')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.resume();
                    },
                    child: const Text('resume')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.pause();
                    },
                    child: const Text('pause')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.setLogLevel(LogLevel.logSilent);
                    },
                    child: const Text('LogLevel')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.seekTo(const Duration(seconds: 11));
                    },
                    child: const Text('seekTo 10s')),
              ],
            )
          ],
        ),
      ),
    );
  }
}


```

## 灵感
https://github.com/CarGuo/GSYVideoPlayer

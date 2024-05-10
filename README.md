# gsy_video_player

视频播放器（IJKplayer、ExoPlayer、MediaPlayer），HTTPS，支持弹幕，外挂字幕，支持滤镜、水印、gif截图，片头广告、中间广告，多个同时播放，支持基本的拖动，声音、亮度调节，支持边播边缓存，支持视频自带rotation的旋转（90,270之类），重力旋转与手动旋转的同步支持，支持列表播放 ，列表全屏动画，视频加载速度，列表小窗口支持拖动，动画效果，调整比例，多分辨率切换，支持切换播放器，进度条小窗口预览，列表切换详情页面无缝播放，rtsp、concat、mpeg。

## Getting Started

https://github.com/CarGuo/GSYVideoPlayer/wiki


## Usage

To use this plugin, add `gsy_video_player` as a dependency in your pubspec.yaml file.

```yaml
dependencies:
  gsy_video_player: ^0.0.3
```


## Example

```dart
import 'dart:math';
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
  GsyVideoPlayerController gsyVideoPlayerController = GsyVideoPlayerController(
    danmakuSettings: const DanmakuSettings(
      danmakuStyle: DanmakuStyle.danmuStyleStroked,
      opacity: 1,
      strokenWidth: 5.0,
      showDanmaku: true,
      enableDanmakuDrawingCache: false,
      maxLinesPair: {
        DanmakuTypeScroll.scrollRL: 10,
      },
    ),
  );

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlayer() async {
    gsyVideoPlayerController.setLogLevel(LogLevel.logError);
    gsyVideoPlayerController.setNetWorkBuilder(
        'https://cloud.video.taobao.com//play/u/27349687/p/1/e/6/t/1/239880949246.mp4',
        autoPlay: false);
    gsyVideoPlayerController.addEventsListener((VideoEventType event) {
      if (gsyVideoPlayerController.value.initialized) {}
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
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.danmakuController.showDanmaku();
                    },
                    child: const Text('showDanmaku')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.danmakuController.hideDanmaku();
                    },
                    child: const Text('hideDanmaku')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.danmakuController.addDanmaku(BaseDanmaku(
                        text: [
                          'I love Flutter',
                          'I like Flutter',
                          'I use Flutter',
                          'Flutter is awesome',
                          'Flutter is amazing',
                          'Flutter is so cool',
                          'Flutter is so beautiful',
                          'Flutter is so powerful',
                          'Flutter is so amazing',
                          'Flutter is so perfect',
                          'Flutter is so beautiful',
                          'Flutter is so powerful',
                          'Flutter is so amazing',
                          'Flutter is so great',
                        ][Random().nextInt(10)],
                        textColor: [
                          Colors.green,
                          Colors.red,
                          Colors.black,
                          Colors.white,
                          Colors.blue,
                          Colors.yellow,
                          Colors.purple,
                          Colors.orange,
                          Colors.brown,
                          Colors.pink,
                          Colors.indigo,
                        ][Random().nextInt(10)],
                        textSize: 35,
                        time: 500,
                        priority: 8,
                        type: DanmakuTypeScroll.scrollRL,
                      ));
                    },
                    child: const Text('sendDanmaku')),
                ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xFFF44336))),
                    onPressed: () {
                      gsyVideoPlayerController.danmakuController.setDanmakuBold(true);
                    },
                    child: const Text('setDanmakuBold')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.danmakuController.setDanmakuMargin(20);
                    },
                    child: const Text('setDanmakuMargin')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.danmakuController.setMarginTop(20);
                    },
                    child: const Text('setMarginTop')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.danmakuController
                          .setDanmakuStyle(DanmakuStyle.danmuStyleShadow, danmuStyleShadow: 5.0);
                    },
                    child: const Text('setDanmakuStyle')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.danmakuController.setDanmakuTransparency(0.9);
                    },
                    child: const Text('setDanmakuTransparency')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.danmakuController.setMaximumLines({
                        DanmakuTypeScroll.scrollRL: 10,
                        DanmakuTypeScroll.fixTop: 10,
                      });
                    },
                    child: const Text('setMaximumLines')),
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

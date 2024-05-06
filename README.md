# gsy_video_player[developing]

A new Flutter plugin project.

## Getting Started

this is a new flutter plugin project. gsy_video_player is a video player plugin for flutter.

## Usage

To use this plugin, add `gsy_video_player` as a dependency in your pubspec.yaml file.

```yaml
dependencies:
  gsy_video_player: ^0.0.1
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
    gsyVideoPlayerController.setNetWorkBuilder(
        'https://cloud.video.taobao.com//play/u/57349687/p/1/e/6/t/1/239880949246.mp4',
        autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: Container(
            color: Colors.blue,
            child: GsyVideoPlayer(
              controller: gsyVideoPlayerController,
            ),
          ),
        ),
      ),
    );
  }
}

```

## 灵感
(GSYVideoPlayer)[https://github.com/CarGuo/GSYVideoPlayer]

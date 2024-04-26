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
  late GsyVideoPlayerController gsyVideoPlayerController;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlayer() async {
    gsyVideoPlayerController = GsyVideoPlayerController();
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

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Stack(
        children: [
          GsyVideoPlayer(
            controller: gsyVideoPlayerController,
          )
        ],
      )),
    );
  }
}

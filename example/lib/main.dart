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
          print('11111111111111111111111111111: ${gsyVideoPlayerController.value.toString()}');
          print('11111111111111111111111111111: ${gsyVideoPlayerController.value.what}');
          print('11111111111111111111111111111: ${gsyVideoPlayerController.value.extra}');
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

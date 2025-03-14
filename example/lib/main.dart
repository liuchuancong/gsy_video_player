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
  GsyVideoPlayerController gsyVideoPlayerController = GsyVideoPlayerController(player: GsyVideoPlayerType.ijk);
  late ChewieController chewieController;
  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    chewieController.dispose();
    gsyVideoPlayerController.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlayer() async {
    chewieController = ChewieController(
      videoPlayerController: gsyVideoPlayerController,
      looping: false,
      rotateWithSystem: true,
    );
    gsyVideoPlayerController.setLogLevel(LogLevel.logError);
    gsyVideoPlayerController.setNetWorkBuilder(
      'https://cloud.video.taobao.com//play/u/27349687/p/1/e/6/t/1/239880949246.mp4',
      autoPlay: true,
      cacheWithPlay: true,
      releaseWhenLossAudio: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 300,
              child: Chewie(
                controller: chewieController,
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
                    onPressed: () async {
                      gsyVideoPlayerController.setBoxFit(BoxFit.fitWidth);
                      // await gsyVideoPlayerController.setIfCurrentIsFullscreen(true);
                    },
                    child: const Text('fitWidth')),
                ElevatedButton(
                    onPressed: () async {
                      chewieController.disableRotation();
                      // await gsyVideoPlayerController.setIfCurrentIsFullscreen(false);
                    },
                    child: const Text('disableRotation')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.setBoxFit(BoxFit.fill);
                    },
                    child: const Text('showSmallVideo')),
              ],
            )
          ],
        ),
      ),
    );
  }
}

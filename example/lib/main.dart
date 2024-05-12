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
      autoPlay: true,
      showFullAnimation: true,
      showPauseCover: true,
      rotateWithSystem: true,
      isTouchWigetFull: true,
    );
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
        body: ListView(
          children: [
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 300,
              child: Container(
                color: Colors.blue,
                child: GsyVideoPlayer(
                  onViewReady: (int id) {
                    print('onViewReady $id');
                  },
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
                ElevatedButton(
                    onPressed: () async {
                      // gsyVideoPlayerController.onEnterFullScreen();
                      await gsyVideoPlayerController.setIfCurrentIsFullscreen(true);
                    },
                    child: const Text('FullScreen')),
                ElevatedButton(
                    onPressed: () async {
                      // gsyVideoPlayerController.onEnterFullScreen();
                      await gsyVideoPlayerController.setIfCurrentIsFullscreen(false);
                    },
                    child: const Text('normalScreen')),
                ElevatedButton(
                    onPressed: () {
                      gsyVideoPlayerController.showSmallVideo(const Size(500, 500), true, true);
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

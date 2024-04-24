import 'package:flutter_test/flutter_test.dart';
import 'package:gsy_video_player/gsy_video_player.dart';
import 'package:gsy_video_player/gsy_video_player_platform_interface.dart';
import 'package:gsy_video_player/gsy_video_player_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGsyVideoPlayerPlatform
    with MockPlatformInterfaceMixin
    implements GsyVideoPlayerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GsyVideoPlayerPlatform initialPlatform = GsyVideoPlayerPlatform.instance;

  test('$MethodChannelGsyVideoPlayer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGsyVideoPlayer>());
  });

  test('getPlatformVersion', () async {
    GsyVideoPlayer gsyVideoPlayerPlugin = GsyVideoPlayer();
    MockGsyVideoPlayerPlatform fakePlatform = MockGsyVideoPlayerPlatform();
    GsyVideoPlayerPlatform.instance = fakePlatform;

    expect(await gsyVideoPlayerPlugin.getPlatformVersion(), '42');
  });
}

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gsy_video_player_platform_interface.dart';

/// An implementation of [GsyVideoPlayerPlatform] that uses method channels.
class MethodChannelGsyVideoPlayer extends GsyVideoPlayerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gsy_video_player');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

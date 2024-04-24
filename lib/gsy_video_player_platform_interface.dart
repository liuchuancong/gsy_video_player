import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gsy_video_player_method_channel.dart';

abstract class GsyVideoPlayerPlatform extends PlatformInterface {
  /// Constructs a GsyVideoPlayerPlatform.
  GsyVideoPlayerPlatform() : super(token: _token);

  static final Object _token = Object();

  static GsyVideoPlayerPlatform _instance = MethodChannelGsyVideoPlayer();

  /// The default instance of [GsyVideoPlayerPlatform] to use.
  ///
  /// Defaults to [MethodChannelGsyVideoPlayer].
  static GsyVideoPlayerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GsyVideoPlayerPlatform] when
  /// they register themselves.
  static set instance(GsyVideoPlayerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

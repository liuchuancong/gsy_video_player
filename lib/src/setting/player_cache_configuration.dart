import 'package:gsy_video_player/src/configuration/player_video_cache.dart';

///Cache configuration for GSYVideoPlayer.
class GsyVideoPlayerCacheConfiguration {
  ///Enable cache for network data source
  final bool useCache;

  final PlayerVideoCache playerVideoCache;

  final String? key;

  const GsyVideoPlayerCacheConfiguration({
    this.useCache = false,
    this.playerVideoCache = PlayerVideoCache.proxyCache,
    this.key,
  });
}

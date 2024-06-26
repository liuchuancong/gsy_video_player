import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:gsy_video_player/gsy_video_player.dart';

// Copyright 2017 The Chromium Authors. All rights reserved.
/// The interface that implementations of video_player must implement.
///
/// Platform implementations should extend this class rather than implement it as `video_player`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [VideoPlayerPlatform] methods.
abstract class VideoPlayerPlatform {
  static VideoPlayerPlatform _instance = MethodChannelVideoPlayer();

  /// The default instance of [VideoPlayerPlatform] to use.
  ///
  /// Platform-specific plugins should override this with their own
  /// platform-specific class that extends [VideoPlayerPlatform] when they
  /// register themselves.
  ///
  /// Defaults to [MethodChannelVideoPlayer].
  static VideoPlayerPlatform get instance => _instance;

  // https://github.com/flutter/flutter/issues/43368
  static set instance(VideoPlayerPlatform instance) {
    try {
      instance._verifyProvidesDefaultImplementations();
    } catch (_) {
      throw AssertionError(
          'Platform interfaces must not be implemented with `implements`');
    }
    _instance = instance;
  }

  /// Initializes the platform interface and disposes all existing players.
  ///
  /// This method is called when the plugin is first initialized
  /// and on every full restart.
  Future<void> init() async {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// Returns a widget displaying the video with a given textureID.
  Future<int?> create({double? width, double? height}) async {
    throw UnimplementedError('create() has not been implemented.');
  }

  Future<void> dispose(int? textureId) {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  /// Sets the [VideoOptionBuilder] for the video.
  Future<void> setVideoOptionBuilder(
      int? textureId, VideoOptionBuilder builder) {
    throw UnimplementedError(
        'setVideoOptionBuilder() has not been implemented.');
  }

  Future<void> startPlayLogic(int? textureId) async {
    throw UnimplementedError('startPlayLogic() has not been implemented.');
  }

  /// Initializes the video player.
  Future<void> setUp(int? textureId, String url, bool cacheWithPlay,
      String cachePath, String title) {
    throw UnimplementedError('setUp() has not been implemented.');
  }

  /// Pauses the video.
  Future<void> pause(int? textureId) async {
    throw UnimplementedError('pause() has not been implemented.');
  }

  /// Resumes the video.
  Future<void> resume(int? textureId) async {
    throw UnimplementedError('resume() has not been implemented.');
  }

  /// Clears the current cache.
  Future<void> clearCurrentCache(int? textureId) async {
    throw UnimplementedError('clearCurrentCache() has not been implemented.');
  }

  /// Returns the current position of the video when it is playing.
  Future<int> getCurrentPositionWhenPlaying(int? textureId) async {
    throw UnimplementedError(
        'getCurrentPositionWhenPlaying() has not been implemented.');
  }

  /// Releases all videos.
  Future<void> releaseAllVideos(int? textureId) async {
    throw UnimplementedError('releaseAllVideos() has not been implemented.');
  }

  /// Returns the current state of the video.
  Future<VideoPlayState> getCurrentState(int? textureId) async {
    throw UnimplementedError('getCurrentState() has not been implemented.');
  }

  /// Sets the play tag of the video.
  Future<void> setPlayTag(int? textureId, String tag) {
    throw UnimplementedError('setPlayTag() has not been implemented.');
  }

  /// Sets the play position of the video.
  Future<void> setPlayPosition(int? textureId, int position) {
    throw UnimplementedError('setPlayPosition() has not been implemented.');
  }

  /// Returns the net speed of the video.
  Future<int> getNetSpeed(int? textureId) async {
    throw UnimplementedError('getNetSpeed() has not been implemented.');
  }

  /// Returns the net speed text of the video.
  Future<String> getNetSpeedText(int? textureId) async {
    throw UnimplementedError('getNetSpeedText() has not been implemented.');
  }

  /// Sets the seek on start of the video.
  Future<void> setSeekOnStart(int? textureId, int msec) {
    throw UnimplementedError('setSeekOnStart() has not been implemented.');
  }

  /// Returns the buffer point of the video.
  Future<int> getBuffterPoint(int? textureId) async {
    throw UnimplementedError('getBuffterPoint() has not been implemented.');
  }

  /// Sets the current player.
  Future<GsyVideoPlayerType> setPlayerFactory(
      int? textureId, GsyVideoPlayerType playerType) {
    throw UnimplementedError('setPlayerFactory() has not been implemented.');
  }

  /// Returns the play manager.
  Future<void> getPlayFactory(int? textureId) async {
    throw UnimplementedError('getPlayFactory() has not been implemented.');
  }

  /// Sets the exo cache manager.
  Future<void> setExoCacheManager(int? textureId) async {
    throw UnimplementedError('setExoCacheManager() has not been implemented.');
  }

  /// Sets the proxy cache manager.
  Future<void> setProxyCacheManager(int? textureId) async {
    throw UnimplementedError(
        'setProxyCacheManager() has not been implemented.');
  }

  /// Clears all default cache.
  Future<void> clearAllDefaultCache(int? textureId) async {
    throw UnimplementedError(
        'clearAllDefaultCache() has not been implemented.');
  }

  /// Clears the default cache.
  Future<void> clearDefaultCache(int? textureId, String cacheDir, String url) {
    throw UnimplementedError('clearDefaultCache() has not been implemented.');
  }

  /// Releases the media player.
  Future<void> releaseMediaPlayer(int? textureId) async {
    throw UnimplementedError('releaseMediaPlayer() has not been implemented.');
  }

  /// Returns the play tag of the video.
  Future<String> getPlayTag(int? textureId) async {
    throw UnimplementedError('getPlayTag() has not been implemented.');
  }

  /// Returns the play position of the video.
  Future<Duration> getPlayPosition(int? textureId) async {
    throw UnimplementedError('getPlayPosition() has not been implemented.');
  }

  /// Returns the option model list of the video.
  Future<List<IjkOption>> getOptionModelList(int? textureId) async {
    throw UnimplementedError('getOptionModelList() has not been implemented.');
  }

  /// Sets the option model list of the video.
  Future<void> setOptionModelList(
      int? textureId, List<IjkOption> optionModelList) {
    throw UnimplementedError('setOptionModelList() has not been implemented.');
  }

  /// Returns whether the video needs to mute.
  Future<bool> isNeedMute(int? textureId) async {
    throw UnimplementedError('isNeedMute() has not been implemented.');
  }

  /// Sets whether the video needs to mute.
  Future<void> setNeedMute(int? textureId, bool needMute) {
    throw UnimplementedError('setNeedMute() has not been implemented.');
  }

  /// Returns the timeout of the video.
  Future<int> getTimeOut(int? textureId) async {
    throw UnimplementedError('getTimeOut() has not been implemented.');
  }

  /// Returns whether the video needs to timeout other.
  Future<bool> isNeedTimeOutOther(int? textureId) async {
    throw UnimplementedError('isNeedTimeOutOther() has not been implemented.');
  }

  /// Sets the timeout of the video.
  Future<void> setTimeOut(int? textureId, int timeOut,
      {bool needTimeOutOther = false}) {
    throw UnimplementedError('setTimeOut() has not been implemented.');
  }

  /// Sets the log level of the video.
  Future<void> setLogLevel(int? textureId, LogLevel level) {
    throw UnimplementedError('setLogLevel() has not been implemented.');
  }

  Future<void> setVolume(int? textureId, double volume) {
    throw UnimplementedError('setVolume() has not been implemented.');
  }

  /// Returns whether the video is using media codec.
  Future<bool> isMediaCodec(int? textureId) async {
    throw UnimplementedError('isMediaCodec() has not been implemented.');
  }

  /// Returns the screen scale ratio of the video.
  Future<double> getScreenScaleRatio(int? textureId) async {
    throw UnimplementedError('getScreenScaleRatio() has not been implemented.');
  }

  /// Sets the screen scale ratio of the video.
  Future<void> setScreenScaleRatio(int? textureId, double ratio) {
    throw UnimplementedError('setScreenScaleRatio() has not been implemented.');
  }

  /// Returns whether the video is using media codec texture.
  Future<bool> isMediaCodecTexture(int? textureId) async {
    throw UnimplementedError('isMediaCodecTexture() has not been implemented.');
  }

  /// Returns the render type of the video.
  Future<GsyVideoPlayerRenderType> getRenderType(int? textureId) async {
    throw UnimplementedError('getRenderType() has not been implemented.');
  }

  /// Sets the render type of the video.
  Future<void> setRenderType(
      int? textureId, GsyVideoPlayerRenderType renderType) {
    throw UnimplementedError('setRenderType() has not been implemented.');
  }

  /// Sets the media codec of the video.
  Future<void> setMediaCodec(int? textureId, bool mediaCodec) {
    throw UnimplementedError('setMediaCodec() has not been implemented.');
  }

  /// Sets the media codec texture of the video.
  Future<void> setMediaCodecTexture(int? textureId, bool mediaCodecTexture) {
    throw UnimplementedError(
        'setMediaCodecTexture() has not been implemented.');
  }

  Future<void> resolveByClick(int? textureId) async {
    throw UnimplementedError('resolveByClick() has not been implemented.');
  }

  Future<void> backToProtVideo(int? textureId) async {
    throw UnimplementedError('backToProtVideo() has not been implemented.');
  }

  Future<bool> isOrientationRotateEnable(int? textureId) async {
    throw UnimplementedError(
        'isOrientationRotateEnable() has not been implemented.');
  }

  Future<void> setOrientationRotateEnable(int? textureId, bool enable) async {
    throw UnimplementedError(
        'setOrientationRotateEnable() has not been implemented.');
  }

  Future<bool> getOrientationRotateIsLand(int? textureId) async {
    throw UnimplementedError(
        'getOrientationRotateIsLand() has not been implemented.');
  }

  Future<void> setOrientationRotateLand(int? textureId, bool isLand) async {
    throw UnimplementedError(
        'setOrientationRotateLand() has not been implemented.');
  }

  Future<OrientationScreenType> getOrientationRotateScreenType(
      int? textureId) async {
    throw UnimplementedError(
        'getOrientationRotateScreenType() has not been implemented.');
  }

  Future<void> setOrientationRotateScreenType(
      int? textureId, OrientationScreenType screenType) async {
    throw UnimplementedError(
        'setOrientationRotateScreenType() has not been implemented.');
  }

  Future<bool> isOrientationRotateClick(int? textureId) async {
    throw UnimplementedError(
        'isOrientationRotateClick() has not been implemented.');
  }

  Future<void> setOrientationRotateIsClick(int? textureId, bool isClick) async {
    throw UnimplementedError(
        'setOrientationRotateIsClick() has not been implemented.');
  }

  Future<bool> isOrientationRotateClickLand(int? textureId) async {
    throw UnimplementedError(
        'isOrientationRotateClickLand() has not been implemented.');
  }

  Future<void> setOrientationRotateIsClickLand(
      int? textureId, bool isClickLand) async {
    throw UnimplementedError(
        'setOrientationRotateIsClickLand() has not been implemented.');
  }

  Future<bool> isOrientationRotateClickPort(int? textureId) async {
    throw UnimplementedError(
        'isOrientationRotateClickPort() has not been implemented.');
  }

  Future<void> setOrientationRotateIslickPort(
      int? textureId, bool islickPort) async {
    throw UnimplementedError(
        'setOrientationRotateIslickPort() has not been implemented.');
  }

  Future<bool> isOrientationRotatePause(int? textureId) async {
    throw UnimplementedError(
        'isOrientationRotatePause() has not been implemented.');
  }

  Future<void> setOrientationRotateIsPause(int? textureId, bool isPause) async {
    throw UnimplementedError(
        'setOrientationRotateIsPause() has not been implemented.');
  }

  Future<bool> isOrientationRotateOnlyRotateLand(int? textureId) async {
    throw UnimplementedError(
        'isOrientationRotateOnlyRotateLand() has not been implemented.');
  }

  Future<void> setOrientationRotateIsOnlyRotateLand(
      int? textureId, bool isOnlyRotateLand) async {
    throw UnimplementedError(
        'setOrientationRotateIsOnlyRotateLand() has not been implemented.');
  }

  Future<bool> isOrientationRotateWithSystem(int? textureId) async {
    throw UnimplementedError(
        'isOrientationRotateWithSystem() has not been implemented.');
  }

  Future<void> setOrientationRotateWithSystem(
      int? textureId, bool isRotateWithSystem) async {
    throw UnimplementedError(
        'setOrientationRotateWithSystem() has not been implemented.');
  }

  Future<void> releaseOrientation(int? textureId) async {
    throw UnimplementedError('releaseOrientation() has not been implemented.');
  }

  ///Enables PiP mode.
  Future<void> enablePictureInPicture(int? textureId, double? top, double? left,
      double? width, double? height) {
    throw UnimplementedError(
        'enablePictureInPicture() has not been implemented.');
  }

  ///Disables PiP mode.
  Future<void> disablePictureInPicture(int? textureId) {
    throw UnimplementedError(
        'disablePictureInPicture() has not been implemented.');
  }

  Future<bool?> isPictureInPictureEnabled(int? textureId) {
    throw UnimplementedError(
        'isPictureInPictureEnabled() has not been implemented.');
  }

  /// Returns the dismiss control time of the video. The dismiss control time is the time in milliseconds
  /// after which the video controls will be hidden.
  Future<int> getSeekOnStart(int? textureId) async {
    throw UnimplementedError('getSeekOnStart() has not been implemented.');
  }

  /// Sets the looping of the video.
  Future<void> setLooping(int? textureId, bool looping) {
    throw UnimplementedError('setLooping() has not been implemented.');
  }

  /// Returns the looping of the video.
  Future<bool> isLooping(int? textureId) async {
    throw UnimplementedError('isLooping() has not been implemented.');
  }

  /// Sets the speed of the video.
  Future<void> setSpeed(int? textureId, double speed,
      {bool soundTouch = true}) {
    throw UnimplementedError('setSpeed() has not been implemented.');
  }

  /// Returns the speed of the video.
  Future<double> getSpeed(int? textureId) async {
    throw UnimplementedError('getSpeed() has not been implemented.');
  }

  /// Sets the speed playing of the video.
  Future<void> setSpeedPlaying(int? textureId, double speed,
      {bool soundTouch = true}) {
    throw UnimplementedError('setSpeedPlaying() has not been implemented.');
  }

  /// Sets the show loading cover of the video.
  Future<void> seekTo(int? textureId, int msec) {
    throw UnimplementedError('seekTo() has not been implemented.');
  }

  /// Returns the show loading cover of the video.

  Future<void> setMatrixGL(int? textureId, List<double> matrix) {
    throw UnimplementedError('setMatrixGL() has not been implemented.');
  }

  Future<void> releaseWhenLossAudio(int? textureId) async {
    throw UnimplementedError(
        'releaseWhenLossAudio() has not been implemented.');
  }

  Future<void> setReleaseWhenLossAudio(
      int? textureId, bool releaseWhenLossAudio) {
    throw UnimplementedError(
        'setReleaseWhenLossAudio() has not been implemented.');
  }

  Stream<VideoEvent> videoEventsFor(int? textureId) {
    throw UnimplementedError('videoEventsFor() has not been implemented.');
  }

  /// Returns the current player.
  Widget buildView(int textureId, {void Function(int)? onViewReady}) {
    throw UnimplementedError('buildView() has not been implemented.');
  }

  // This method makes sure that VideoPlayer isn't implemented with `implements`.
  //
  // See class docs for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter, which fails if the class is
  // implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}
}

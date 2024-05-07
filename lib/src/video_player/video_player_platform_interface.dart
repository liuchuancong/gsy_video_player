import 'dart:async';
import 'package:flutter/widgets.dart';
import 'method_channel_video_player.dart';
import 'package:gsy_video_player/src/constants/log_level.dart';
import 'package:gsy_video_player/src/constants/ijk_option.dart';
import 'package:gsy_video_player/src/video_player/video_event.dart';
import 'package:gsy_video_player/src/constants/video_play_state.dart';
import 'package:gsy_video_player/src/builder/video_option_builder.dart';
import 'package:gsy_video_player/src/configuration/player_video_type.dart';
import 'package:gsy_video_player/src/configuration/player_video_show_type.dart';
import 'package:gsy_video_player/src/configuration/player_video_render_type.dart';

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

  final Completer<int> initialized = Completer<int>();
  // https://github.com/flutter/flutter/issues/43368
  static set instance(VideoPlayerPlatform instance) {
    instance._verifyProvidesDefaultImplementations();
    _instance = instance;
  }

  /// Returns a widget displaying the video with a given textureID.
  Future<void> create() {
    throw UnimplementedError('create() has not been implemented.');
  }

  Future<void> dispose() {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  /// Sets the [VideoOptionBuilder] for the video.
  Future<void> setVideoOptionBuilder(VideoOptionBuilder builder) {
    throw UnimplementedError('setVideoOptionBuilder() has not been implemented.');
  }

  /// Returns the layout ID of the video.
  Future<int> getLayoutId() {
    throw UnimplementedError('getLayoutId() has not been implemented.');
  }

  Future<void> startPlayLogic() {
    throw UnimplementedError('startPlayLogic() has not been implemented.');
  }

  /// Initializes the video player.
  Future<void> setUp(String url, bool cacheWithPlay, String cachePath, String title) {
    throw UnimplementedError('setUp() has not been implemented.');
  }

  /// Pauses the video.
  Future<void> onVideoPause() {
    throw UnimplementedError('onVideoPause() has not been implemented.');
  }

  /// Resumes the video.
  Future<void> onVideoResume() {
    throw UnimplementedError('onVideoResume() has not been implemented.');
  }

  /// Clears the current cache.
  Future<void> clearCurrentCache() {
    throw UnimplementedError('clearCurrentCache() has not been implemented.');
  }

  /// Returns the current position of the video when it is playing.
  Future<int> getCurrentPositionWhenPlaying() {
    throw UnimplementedError('getCurrentPositionWhenPlaying() has not been implemented.');
  }

  /// Releases all videos.
  Future<void> releaseAllVideos() {
    throw UnimplementedError('releaseAllVideos() has not been implemented.');
  }

  /// Returns the current state of the video.
  Future<VideoPlayState> getCurrentState() {
    throw UnimplementedError('getCurrentState() has not been implemented.');
  }

  /// Sets the play tag of the video.
  Future<void> setPlayTag(String tag) {
    throw UnimplementedError('setPlayTag() has not been implemented.');
  }

  /// Sets the play position of the video.
  Future<void> setPlayPosition(int position) {
    throw UnimplementedError('setPlayPosition() has not been implemented.');
  }

  /// Backs from window full.
  Future<void> backFromWindowFull() {
    throw UnimplementedError('backFromWindowFull() has not been implemented.');
  }

  /// Returns the net speed of the video.
  Future<int> getNetSpeed() {
    throw UnimplementedError('getNetSpeed() has not been implemented.');
  }

  /// Returns the net speed text of the video.
  Future<String> getNetSpeedText() {
    throw UnimplementedError('getNetSpeedText() has not been implemented.');
  }

  /// Sets the seek on start of the video.
  Future<void> setSeekOnStart(int msec) {
    throw UnimplementedError('setSeekOnStart() has not been implemented.');
  }

  /// Returns the buffer point of the video.
  Future<int> getBuffterPoint() {
    throw UnimplementedError('getBuffterPoint() has not been implemented.');
  }

  /// Sets the current player.
  Future<GsyVideoPlayerType> setCurrentPlayer(GsyVideoPlayerType playerType) {
    throw UnimplementedError('setCurrentPlayer() has not been implemented.');
  }

  /// Returns the play manager.
  Future<void> getPlayManager() {
    throw UnimplementedError('getPlayManager() has not been implemented.');
  }

  /// Sets the exo cache manager.
  Future<void> setExoCacheManager() {
    throw UnimplementedError('setExoCacheManager() has not been implemented.');
  }

  /// Sets the proxy cache manager.
  Future<void> setProxyCacheManager() {
    throw UnimplementedError('setProxyCacheManager() has not been implemented.');
  }

  /// Clears all default cache.
  Future<void> clearAllDefaultCache() {
    throw UnimplementedError('clearAllDefaultCache() has not been implemented.');
  }

  /// Clears the default cache.
  Future<void> clearDefaultCache(String cacheDir, String url) {
    throw UnimplementedError('clearDefaultCache() has not been implemented.');
  }

  /// Releases the media player.
  Future<void> releaseMediaPlayer() {
    throw UnimplementedError('releaseMediaPlayer() has not been implemented.');
  }

  Future<void> onPause() {
    throw UnimplementedError('onPause() has not been implemented.');
  }

  Future<void> onResume() {
    throw UnimplementedError('onResume() has not been implemented.');
  }

  /// Returns the play tag of the video.
  Future<String> getPlayTag() {
    throw UnimplementedError('getPlayTag() has not been implemented.');
  }

  /// Returns the play position of the video.
  Future<int> getPlayPosition() {
    throw UnimplementedError('getPlayPosition() has not been implemented.');
  }

  /// Returns the option model list of the video.
  Future<List<IjkOption>> getOptionModelList() {
    throw UnimplementedError('getOptionModelList() has not been implemented.');
  }

  /// Sets the option model list of the video.
  Future<void> setOptionModelList(List<IjkOption> optionModelList) {
    throw UnimplementedError('setOptionModelList() has not been implemented.');
  }

  /// Returns whether the video needs to mute.
  Future<bool> isNeedMute() {
    throw UnimplementedError('isNeedMute() has not been implemented.');
  }

  /// Sets whether the video needs to mute.
  Future<void> setNeedMute(bool needMute) {
    throw UnimplementedError('setNeedMute() has not been implemented.');
  }

  /// Returns the timeout of the video.
  Future<int> getTimeOut() {
    throw UnimplementedError('getTimeOut() has not been implemented.');
  }

  /// Returns whether the video needs to timeout other.
  Future<bool> isNeedTimeOutOther() {
    throw UnimplementedError('isNeedTimeOutOther() has not been implemented.');
  }

  /// Sets the timeout of the video.
  Future<void> setTimeOut(int timeOut, {bool needTimeOutOther = false}) {
    throw UnimplementedError('setTimeOut() has not been implemented.');
  }

  /// Sets the log level of the video.
  Future<void> setLogLevel(LogLevel level) {
    throw UnimplementedError('setLogLevel() has not been implemented.');
  }

  /// Returns whether the video is using media codec.
  Future<bool> isMediaCodec() {
    throw UnimplementedError('isMediaCodec() has not been implemented.');
  }

  /// Returns the screen scale ratio of the video.
  Future<double> getScreenScaleRatio() {
    throw UnimplementedError('getScreenScaleRatio() has not been implemented.');
  }

  /// Sets the screen scale ratio of the video.
  Future<void> setScreenScaleRatio(double ratio) {
    throw UnimplementedError('setScreenScaleRatio() has not been implemented.');
  }

  /// Returns whether the video is using media codec texture.
  Future<bool> isMediaCodecTexture() {
    throw UnimplementedError('isMediaCodecTexture() has not been implemented.');
  }

  /// Returns the show type of the video.
  Future<PlayerVideoShowType> getShowType() {
    throw UnimplementedError('getShowType() has not been implemented.');
  }

  /// Sets the show type of the video.
  Future<void> setShowType(PlayerVideoShowType showType, {double screenScaleRatio = 0.0}) {
    throw UnimplementedError('setShowType() has not been implemented.');
  }

  /// Returns the render type of the video.
  Future<GsyVideoPlayerRenderType> getRenderType() {
    throw UnimplementedError('getRenderType() has not been implemented.');
  }

  /// Sets the render type of the video.
  Future<void> setRenderType(GsyVideoPlayerRenderType renderType) {
    throw UnimplementedError('setRenderType() has not been implemented.');
  }

  /// Sets the media codec of the video.
  Future<void> setMediaCodec(bool mediaCodec) {
    throw UnimplementedError('setMediaCodec() has not been implemented.');
  }

  /// Sets the media codec texture of the video.
  Future<void> setMediaCodecTexture(bool mediaCodecTexture) {
    throw UnimplementedError('setMediaCodecTexture() has not been implemented.');
  }

  /// Start window full screen.
  Future<void> startWindowFullscreen(bool showActionBar, bool showStatusBar) {
    throw UnimplementedError('startWindowFullscreen() has not been implemented.');
  }

  /// Show small video.
  Future<void> showSmallVideo(Size size, bool showActionBar, bool showStatusBar) {
    throw UnimplementedError('showSmallVideo() has not been implemented.');
  }

  /// Hide small video.
  Future<void> hideSmallVideo() {
    throw UnimplementedError('hideSmallVideo() has not been implemented.');
  }

  /// Whether show full animation.
  Future<bool> isShowFullAnimation() {
    throw UnimplementedError('isShowFullAnimation() has not been implemented.');
  }

  /// Set show full animation.
  Future<void> setShowFullAnimation(bool showFullAnimation) {
    throw UnimplementedError('setShowFullAnimation() has not been implemented.');
  }

  /// Whether rotate view auto.
  /// Whether the video view should rotate automatically based on device orientation.
  Future<bool> isRotateViewAuto() {
    throw UnimplementedError('isRotateViewAuto() has not been implemented.');
  }

  /// Set rotate view auto.
  Future<void> setRotateViewAuto(bool rotateViewAuto) {
    throw UnimplementedError('setRotateViewAuto() has not been implemented.');
  }

  /// Whether lock land.
  Future<bool> isLockLand() {
    throw UnimplementedError('isLockLand() has not been implemented.');
  }

  /// Set lock land.
  Future<void> setLockLand(bool lockLand) {
    throw UnimplementedError('setLockLand() has not been implemented.');
  }

  /// Whether rotate with system.
  Future<bool> isRotateWithSystem() {
    throw UnimplementedError('isRotateWithSystem() has not been implemented.');
  }

  /// Set rotate with system.
  Future<void> setRotateWithSystem(bool rotateWithSystem) {
    throw UnimplementedError('setRotateWithSystem() has not been implemented.');
  }

  /// Initializes the UI state.
  Future<void> initUIState() {
    throw UnimplementedError('initUIState() has not been implemented.');
  }

  /// Returns the enlarge image resource.
  Future<int> getEnlargeImageRes() {
    throw UnimplementedError('getEnlargeImageRes() has not been implemented.');
  }

  /// Sets the enlarge image resource.
  Future<void> setEnlargeImageRes(int res) {
    throw UnimplementedError('setEnlargeImageRes() has not been implemented.');
  }

  /// Returns the shrink image resource.
  Future<int> getShrinkImageRes() {
    throw UnimplementedError('getShrinkImageRes() has not been implemented.');
  }

  /// Sets the shrink image resource.
  Future<void> setShrinkImageRes(int res) {
    throw UnimplementedError('setShrinkImageRes() has not been implemented.');
  }

  /// Sets whether the video is touch full screen.
  Future<void> setIsTouchWigetFull(bool isTouchWigetFull) {
    throw UnimplementedError('setIsTouchWigetFull() has not been implemented.');
  }

  /// Returns whether the video is touch full screen.
  Future<bool> getIsTouchWigetFull() {
    throw UnimplementedError('getIsTouchWigetFull() has not been implemented.');
  }

  /// Sets the thumb play of the video.
  Future<void> setThumbPlay(bool thumbPlay) {
    throw UnimplementedError('setThumbPlay() has not been implemented.');
  }

  Future<bool> isHideKeyBoard() {
    throw UnimplementedError('isHideKeyBoard() has not been implemented.');
  }

  Future<void> setHideKeyBoard(bool hideKeyBoard) {
    throw UnimplementedError('setHideKeyBoard() has not been implemented.');
  }

  Future<bool> isNeedShowWifiTip() {
    throw UnimplementedError('isNeedShowWifiTip() has not been implemented.');
  }

  Future<void> setNeedShowWifiTip(bool needShowWifiTip) {
    throw UnimplementedError('setNeedShowWifiTip() has not been implemented.');
  }

  Future<bool> isTouchWiget() {
    throw UnimplementedError('isTouchWiget() has not been implemented.');
  }

  Future<void> setTouchWiget(bool touchWiget) {
    throw UnimplementedError('setTouchWiget() has not been implemented.');
  }

  Future<void> setSeekRatio(double seekRatio) {
    throw UnimplementedError('setSeekRatio() has not been implemented.');
  }

  Future<double> getSeekRatio() {
    throw UnimplementedError('getSeekRatio() has not been implemented.');
  }

  Future<bool> isNeedLockFull() {
    throw UnimplementedError('isNeedLockFull() has not been implemented.');
  }

  Future<void> setNeedLockFull(bool needLockFull) {
    throw UnimplementedError('setNeedLockFull() has not been implemented.');
  }

  /// Sets the dismiss control time of the video. The dismiss control time is the time in milliseconds
  /// after which the video controls will be hidden.
  Future<void> setDismissControlTime(int time) {
    throw UnimplementedError('setDismissControlTime() has not been implemented.');
  }

  Future<int> getDismissControlTime() {
    throw UnimplementedError('getDismissControlTime() has not been implemented.');
  }

  /// Returns the dismiss control time of the video. The dismiss control time is the time in milliseconds
  /// after which the video controls will be hidden.
  Future<int> getSeekOnStart() {
    throw UnimplementedError('getSeekOnStart() has not been implemented.');
  }

  Future<bool> isIfCurrentIsFullscreen() {
    throw UnimplementedError('isIfCurrentIsFullscreen() has not been implemented.');
  }

  /// Returns the seek on start of the video.
  Future<void> setIfCurrentIsFullscreen(bool ifCurrentIsFullscreen) {
    throw UnimplementedError('setIfCurrentIsFullscreen() has not been implemented.');
  }

  /// Sets the looping of the video.
  Future<void> setLooping(bool looping) {
    throw UnimplementedError('setLooping() has not been implemented.');
  }

  /// Returns the looping of the video.
  Future<bool> isLooping() {
    throw UnimplementedError('isLooping() has not been implemented.');
  }

  /// Sets the speed of the video.
  Future<void> setSpeed(double speed, {bool soundTouch = true}) {
    throw UnimplementedError('setSpeed() has not been implemented.');
  }

  /// Returns the speed of the video.
  Future<double> getSpeed() {
    throw UnimplementedError('getSpeed() has not been implemented.');
  }

  /// Sets the speed playing of the video.
  Future<void> setSpeedPlaying(double speed, {bool soundTouch = true}) {
    throw UnimplementedError('setSpeedPlaying() has not been implemented.');
  }

  /// Sets the show pause cover of the video.
  Future<void> setShowPauseCover(bool showPauseCover) {
    throw UnimplementedError('setShowPauseCover() has not been implemented.');
  }

  /// Returns the show pause cover of the video.
  Future<bool> isShowPauseCover() {
    throw UnimplementedError('isShowPauseCover() has not been implemented.');
  }

  /// Sets the show loading cover of the video.
  Future<void> seekTo(double msec) {
    throw UnimplementedError('seekTo() has not been implemented.');
  }

  /// Returns the show loading cover of the video.

  Future<void> setMatrixGL(List<double> matrix) {
    throw UnimplementedError('setMatrixGL() has not been implemented.');
  }

  Future<void> releaseWhenLossAudio() {
    throw UnimplementedError('releaseWhenLossAudio() has not been implemented.');
  }

  Future<void> setReleaseWhenLossAudio(bool releaseWhenLossAudio) {
    throw UnimplementedError('setReleaseWhenLossAudio() has not been implemented.');
  }

  Future<void> setAutoFullWithSize(bool releaseWhenLossAudio) {
    throw UnimplementedError('setAutoFullWithSize() has not been implemented.');
  }

  Future<bool> getAutoFullWithSize() {
    throw UnimplementedError('getAutoFullWithSize() has not been implemented.');
  }

  Future<void> setVolume(double volume) {
    throw UnimplementedError('setVolume() has not been implemented.');
  }

  Stream<VideoEvent> videoEventsFor() {
    throw UnimplementedError('videoEventsFor() has not been implemented.');
  }

  /// Returns the current player.
  Widget buildView() {
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

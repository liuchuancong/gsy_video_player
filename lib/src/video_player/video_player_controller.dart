import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gsy_video_player/gsy_video_player.dart';

VideoPlayerPlatform? _lastVideoPlayerPlatform;

VideoPlayerPlatform get _videoPlayerPlatform {
  final VideoPlayerPlatform currentInstance = VideoPlayerPlatform.instance;
  if (_lastVideoPlayerPlatform != currentInstance) {
    // This will clear all open videos on the platform when a full restart is
    // performed.
    currentInstance.init();
    _lastVideoPlayerPlatform = currentInstance;
  }
  return currentInstance;
}

/// Controls a platform video player, and provides updates when the state is
/// changing.
///
/// Instances must be initialized with initialize.
///
/// The video is displayed in a Flutter app by creating a [GsyVideoPlayer] widget.
///
/// To reclaim the resources used by the player call [dispose].
///
/// After [dispose] all further calls are ignored.
class GsyVideoPlayerController extends ValueNotifier<VideoPlayerValue> {
  /// Constructs a [GsyVideoPlayerController] and creates video controller on platform side.
  GsyVideoPlayerController({bool allowBackgroundPlayback = true, GsyVideoPlayerType player = GsyVideoPlayerType.ijk})
      : super(VideoPlayerValue(duration: Duration.zero, isInitialized: false)) {
    _allowBackgroundPlayback = allowBackgroundPlayback;
    initialize();
    currentPlayer = player;
  }

  static const int kUninitializedTextureId = -1;
  int _textureId = kUninitializedTextureId;
  int get textureId => _textureId;

  bool _allowBackgroundPlayback = true;

  GsyVideoPlayerType currentPlayer = GsyVideoPlayerType.ijk;

  /// Initializes the video controller on platform side.

  final StreamController<VideoEvent> videoEventStreamController = StreamController.broadcast();

  ///StreamSubscription for VideoEvent listener
  StreamSubscription<VideoEvent>? _videoEventStreamSubscription;

  Completer<void>? _creatingCompleter;

  bool _isDisposed = false;

  Timer? _timer;

  Completer<void>? _initializingCompleter;

  StreamSubscription<dynamic>? _eventSubscription;

  _VideoAppLifeCycleObserver? _lifeCycleObserver;

  ///List of event listeners, which listen to events.
  final List<Function(VideoEventType)?> _eventListeners = [];

  ///Expose all active eventListeners
  List<Function(VideoEventType)?> get eventListeners => _eventListeners.sublist(1);

  late VideoOptionBuilder videoOptionBuilder;

  Future _initializeVideo() async {
    _videoEventStreamSubscription?.cancel();
    _videoEventStreamSubscription = null;
    _videoEventStreamSubscription = videoEventStreamController.stream.listen(_handleVideoEvent);
  }

  Future<void> initialize() async {
    final bool allowBackgroundPlayback = _allowBackgroundPlayback;
    value = value.copyWith(allowBackgroundPlayback: allowBackgroundPlayback);
    if (!allowBackgroundPlayback) {
      _lifeCycleObserver = _VideoAppLifeCycleObserver(this);
    }
    _lifeCycleObserver?.initialize();
    _creatingCompleter = Completer<void>();
    _textureId = (await _videoPlayerPlatform.create()) ?? kUninitializedTextureId;
    _initializingCompleter = Completer<void>();
    setEventListener();
    _creatingCompleter!.complete(null);
    await setPlayerFactory(currentPlayer);
  }

  ///Send player event. Shouldn't be used manually.
  void postEvent(VideoEventType eventType) {
    _postEvent(eventType);
  }

  ///Send player event to all listeners.
  void _postEvent(VideoEventType eventType) {
    for (final Function(VideoEventType)? eventListener in _eventListeners) {
      if (eventListener != null) {
        eventListener(eventType);
      }
    }
  }

  ///Add event listener which listens to player events.
  void addEventsListener(Function(VideoEventType) eventListener) {
    _eventListeners.add(eventListener);
  }

  ///Remove event listener. This method should be called once you're disposing
  ///Better Player.
  void removeEventsListener(Function(VideoEventType) eventListener) {
    _eventListeners.remove(eventListener);
  }

  ///Handle VideoEvent when remote controls notification / PiP is shown
  void _handleVideoEvent(VideoEvent event) async {
    /// The video has been initialized.
    switch (event.eventType) {
      case VideoEventType.initialized:
        _postEvent(VideoEventType.initialized);
        break;
      case VideoEventType.onVideoPlayerInitialized:
        _postEvent(VideoEventType.onVideoPlayerInitialized);
        break;
      case VideoEventType.changeBoxFit:
        _postEvent(VideoEventType.changeBoxFit);
        break;

      case VideoEventType.onPrepared:
        _postEvent(VideoEventType.onPrepared);
        break;

      case VideoEventType.onAutoCompletion:
        _postEvent(VideoEventType.onAutoCompletion);
        break;

      case VideoEventType.onCompletion:
        _postEvent(VideoEventType.onCompletion);
        break;

      case VideoEventType.onBufferingUpdate:
        _postEvent(VideoEventType.onBufferingUpdate);
        break;

      case VideoEventType.onBufferingEnd:
        _postEvent(VideoEventType.onBufferingEnd);
        break;

      case VideoEventType.onSeekComplete:
        _postEvent(VideoEventType.onSeekComplete);
        break;

      case VideoEventType.onError:
        _postEvent(VideoEventType.onError);
        break;

      case VideoEventType.onInfo:
        _postEvent(VideoEventType.onInfo);
        break;

      case VideoEventType.onVideoSizeChanged:
        _postEvent(VideoEventType.onVideoSizeChanged);
        break;

      case VideoEventType.onVideoPause:
        _postEvent(VideoEventType.onVideoPause);
        break;
      case VideoEventType.onVideoResume:
        _postEvent(VideoEventType.onVideoResume);
        break;
      case VideoEventType.onVideoResumeWithSeek:
        _postEvent(VideoEventType.onVideoResumeWithSeek);
        break;
      case VideoEventType.pipStart:
        _postEvent(VideoEventType.pipStart);
        break;
      case VideoEventType.pipStop:
        _postEvent(VideoEventType.pipStop);
        break;
      case VideoEventType.startWindowFullscreen:
        _postEvent(VideoEventType.startWindowFullscreen);
        break;

      case VideoEventType.exitWindowFullscreen:
        _postEvent(VideoEventType.exitWindowFullscreen);
        break;
      case VideoEventType.unknown:
        _postEvent(VideoEventType.unknown);
        break;
      default:
        _postEvent(VideoEventType.unknown);
        break;
    }
  }

  Future<void> setAssetBuilder(
    String url, {
    int? playPosition,
    int? seekOnStart,
    double? speed,
    bool? looping,
    bool? cacheWithPlay,
    bool? sounchTouch,
    bool? releaseWhenLossAudio,
    String? playTag,
    String? overrideExtension,
    bool? isUseCustomCachePath,
    String? cachePath,
    Map<String, String>? mapHeadData,
    bool? needOrientationUtils,
    PlayVideoDataSourceType? playVideoDataSourceType,
    bool? autoPlay,
    bool? useDefaultIjkOptions,
  }) {
    return _setDataSource(
      VideoOptionBuilder(
        url: url,
        autoPlay: autoPlay ?? VideoOptionBuilder.mAutoPlay,
        playPosition: playPosition ?? VideoOptionBuilder.mPlayPosition,
        seekOnStart: seekOnStart ?? VideoOptionBuilder.mSeekOnStart,
        speed: speed ?? VideoOptionBuilder.mSpeed,
        looping: looping ?? VideoOptionBuilder.mLooping,
        cacheWithPlay: cacheWithPlay ?? VideoOptionBuilder.mCacheWithPlay,
        sounchTouch: sounchTouch ?? VideoOptionBuilder.mSounchTouch,
        releaseWhenLossAudio: releaseWhenLossAudio ?? VideoOptionBuilder.mReleaseWhenLossAudio,
        playTag: playTag ?? VideoOptionBuilder.mPlayTag,
        overrideExtension: overrideExtension ?? VideoOptionBuilder.mOverrideExtension,
        isUseCustomCachePath: isUseCustomCachePath ?? VideoOptionBuilder.mIsUseCustomCachePath,
        cachePath: cachePath ?? VideoOptionBuilder.mCachePath,
        mapHeadData: mapHeadData ?? VideoOptionBuilder.mMapHeadData,
        needOrientationUtils: needOrientationUtils ?? VideoOptionBuilder.mNeedOrientationUtils,
        playVideoDataSourceType: PlayVideoDataSourceType.asset,
        useDefaultIjkOptions: useDefaultIjkOptions ?? false,
      ),
    );
  }

  Future<void> setNetWorkBuilder(
    String url, {
    bool? autoPlay,
    int? playPosition,
    int? seekOnStart,
    double? speed,
    bool? looping,
    bool? cacheWithPlay,
    bool? sounchTouch,
    bool? releaseWhenLossAudio,
    String? playTag,
    String? overrideExtension,
    bool? isUseCustomCachePath,
    String? cachePath,
    Map<String, String>? mapHeadData,
    bool? needOrientationUtils,
    PlayVideoDataSourceType? playVideoDataSourceType,
    bool? useDefaultIjkOptions,
  }) {
    return _setDataSource(
      VideoOptionBuilder(
        url: url,
        autoPlay: autoPlay ?? VideoOptionBuilder.mAutoPlay,
        playPosition: playPosition ?? VideoOptionBuilder.mPlayPosition,
        seekOnStart: seekOnStart ?? VideoOptionBuilder.mSeekOnStart,
        speed: speed ?? VideoOptionBuilder.mSpeed,
        looping: looping ?? VideoOptionBuilder.mLooping,
        cacheWithPlay: cacheWithPlay ?? VideoOptionBuilder.mCacheWithPlay,
        sounchTouch: sounchTouch ?? VideoOptionBuilder.mSounchTouch,
        releaseWhenLossAudio: releaseWhenLossAudio ?? VideoOptionBuilder.mReleaseWhenLossAudio,
        playTag: playTag ?? VideoOptionBuilder.mPlayTag,
        overrideExtension: overrideExtension ?? VideoOptionBuilder.mOverrideExtension,
        isUseCustomCachePath: isUseCustomCachePath ?? VideoOptionBuilder.mIsUseCustomCachePath,
        cachePath: cachePath ?? VideoOptionBuilder.mCachePath,
        mapHeadData: mapHeadData ?? VideoOptionBuilder.mMapHeadData,
        needOrientationUtils: needOrientationUtils ?? VideoOptionBuilder.mNeedOrientationUtils,
        playVideoDataSourceType: PlayVideoDataSourceType.network,
        useDefaultIjkOptions: useDefaultIjkOptions ?? false,
      ),
    );
  }

  Future<void> setFileBuilder(
    String url, {
    bool? autoPlay,
    int? playPosition,
    int? seekOnStart,
    double? speed,
    bool? looping,
    bool? cacheWithPlay,
    bool? sounchTouch,
    bool? releaseWhenLossAudio,
    String? playTag,
    String? overrideExtension,
    bool? isUseCustomCachePath,
    String? cachePath,
    Map<String, String>? mapHeadData,
    bool? needOrientationUtils,
    PlayVideoDataSourceType? playVideoDataSourceType,
    bool? useDefaultIjkOptions,
  }) {
    return _setDataSource(
      VideoOptionBuilder(
        url: url,
        autoPlay: autoPlay ?? VideoOptionBuilder.mAutoPlay,
        playPosition: playPosition ?? VideoOptionBuilder.mPlayPosition,
        seekOnStart: seekOnStart ?? VideoOptionBuilder.mSeekOnStart,
        speed: speed ?? VideoOptionBuilder.mSpeed,
        looping: looping ?? VideoOptionBuilder.mLooping,
        cacheWithPlay: cacheWithPlay ?? VideoOptionBuilder.mCacheWithPlay,
        sounchTouch: sounchTouch ?? VideoOptionBuilder.mSounchTouch,
        releaseWhenLossAudio: releaseWhenLossAudio ?? VideoOptionBuilder.mReleaseWhenLossAudio,
        playTag: playTag ?? VideoOptionBuilder.mPlayTag,
        overrideExtension: overrideExtension ?? VideoOptionBuilder.mOverrideExtension,
        isUseCustomCachePath: isUseCustomCachePath ?? VideoOptionBuilder.mIsUseCustomCachePath,
        cachePath: cachePath ?? VideoOptionBuilder.mCachePath,
        mapHeadData: mapHeadData ?? VideoOptionBuilder.mMapHeadData,
        needOrientationUtils: needOrientationUtils ?? VideoOptionBuilder.mNeedOrientationUtils,
        playVideoDataSourceType: PlayVideoDataSourceType.file,
        useDefaultIjkOptions: useDefaultIjkOptions ?? false,
      ),
    );
  }

  Future<void> setDataSourceBuilder(
    String url, {
    bool? autoPlay,
    int? playPosition,
    int? seekOnStart,
    double? speed,
    bool? looping,
    bool? cacheWithPlay,
    bool? sounchTouch,
    bool? releaseWhenLossAudio,
    String? playTag,
    String? overrideExtension,
    bool? isUseCustomCachePath,
    String? cachePath,
    Map<String, String>? mapHeadData,
    bool? needOrientationUtils,
    PlayVideoDataSourceType? playVideoDataSourceType,
    bool? useDefaultIjkOptions,
  }) {
    return _setDataSource(
      VideoOptionBuilder(
        url: url,
        autoPlay: autoPlay ?? VideoOptionBuilder.mAutoPlay,
        playPosition: playPosition ?? VideoOptionBuilder.mPlayPosition,
        seekOnStart: seekOnStart ?? VideoOptionBuilder.mSeekOnStart,
        speed: speed ?? VideoOptionBuilder.mSpeed,
        looping: looping ?? VideoOptionBuilder.mLooping,
        cacheWithPlay: cacheWithPlay ?? VideoOptionBuilder.mCacheWithPlay,
        sounchTouch: sounchTouch ?? VideoOptionBuilder.mSounchTouch,
        releaseWhenLossAudio: releaseWhenLossAudio ?? VideoOptionBuilder.mReleaseWhenLossAudio,
        playTag: playTag ?? VideoOptionBuilder.mPlayTag,
        overrideExtension: overrideExtension ?? VideoOptionBuilder.mOverrideExtension,
        isUseCustomCachePath: isUseCustomCachePath ?? VideoOptionBuilder.mIsUseCustomCachePath,
        cachePath: cachePath ?? VideoOptionBuilder.mCachePath,
        mapHeadData: mapHeadData ?? VideoOptionBuilder.mMapHeadData,
        needOrientationUtils: needOrientationUtils ?? VideoOptionBuilder.mNeedOrientationUtils,
        playVideoDataSourceType: playVideoDataSourceType ?? PlayVideoDataSourceType.network,
        useDefaultIjkOptions: useDefaultIjkOptions ?? false,
      ),
    );
  }

  void _positionLisener() {
    _timer?.cancel();
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (Timer timer) async {
        if (_isDisposed) {
          return;
        }
        final Duration? newPosition = await position;
        if (newPosition == null) {
          return;
        }
        _updatePosition(newPosition);
      },
    );
  }

  Future<void> setBuilder(VideoOptionBuilder builder) {
    return _setDataSource(builder);
  }

  void setEventListener() async {
    void eventListener(VideoEvent event) async {
      if (_isDisposed) {
        return;
      }
      videoEventStreamController.add(event);
      switch (event.eventType) {
        case VideoEventType.initialized:
          value = value.copyWith(
            duration: event.duration,
            rotationCorrection: event.rotationCorrection,
            isInitialized: true,
            isCompleted: false,
            isPlaying: false,
          );
          _initializingCompleter!.complete(null);
          break;
        case VideoEventType.pipStart:
          value = value.copyWith(isPip: true);
          break;
        case VideoEventType.pipStop:
          value = value.copyWith(isPip: false);
          break;

        case VideoEventType.onVideoPlayerInitialized:
          value = value.copyWith(
            onVideoPlayerInitialized: true,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            size: event.size,
            isBuffering: event.isBuffering,
            videoSarDen: event.videoSarDen,
            videoSarNum: event.videoSarNum,
          );
          _positionLisener();
          unawaited(_applyVolume());
          break;
        case VideoEventType.changeBoxFit:
          break;
        case VideoEventType.onConfigurationChanged:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onPrepared:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onAutoCompletion:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            isCompleted: true,
          );
          break;
        case VideoEventType.onCompletion:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onBufferingUpdate:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            buffered: event.buffered,
            isBuffering: event.isBuffering,
            bufferPercent: event.bufferPercent,
          );
          _positionLisener();
          break;
        case VideoEventType.onBufferingEnd:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            buffered: event.buffered,
            isBuffering: event.isBuffering,
          );
          break;

        case VideoEventType.onSeekComplete:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            isBuffering: event.isBuffering,
          );
          _positionLisener();
          break;
        case VideoEventType.onError:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            what: event.what,
            isBuffering: event.isBuffering,
            extra: event.extra,
          );
          break;
        case VideoEventType.onInfo:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            what: event.what,
            isBuffering: event.isBuffering,
            extra: event.extra,
          );
          _positionLisener();
          break;
        case VideoEventType.onVideoSizeChanged:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            size: event.size,
            isBuffering: event.isBuffering,
            videoSarDen: event.videoSarDen,
            videoSarNum: event.videoSarNum,
          );
          break;
        case VideoEventType.onVideoPause:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            isBuffering: event.isBuffering,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onVideoResume:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            isBuffering: event.isBuffering,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
          );
          break;
        case VideoEventType.onVideoResumeWithSeek:
          value = value.copyWith(
            isPlaying: event.isPlaying,
            duration: Duration(milliseconds: event.duration!.inMilliseconds),
            playState: event.playState,
            isBuffering: event.isBuffering,
            seek: value.seek,
          );
          break;
        case VideoEventType.startWindowFullscreen:
          value = value.copyWith(isFullScreen: true);
          break;
        case VideoEventType.changeAspectRatio:
          break;
        case VideoEventType.onRotateChanged:
          break;
        case VideoEventType.exitWindowFullscreen:
          value = value.copyWith(isFullScreen: false);
          break;
        case VideoEventType.unknown:
          break;
      }
    }

    void errorListener(Object object) {
      if (object is PlatformException) {
        final PlatformException e = object;
        value = value.copyWith(errorDescription: e.message);
      } else {
        value.copyWith(errorDescription: object.toString());
      }
      _timer?.cancel();
      if (!_initializingCompleter!.isCompleted) {
        _initializingCompleter!.completeError(object);
      }
    }

    _eventSubscription = _videoPlayerPlatform.videoEventsFor(_textureId).listen(eventListener, onError: errorListener);
    await _initializeVideo();
  }

  Future<void> _setDataSource(VideoOptionBuilder builder) async {
    await _creatingCompleter!.future;
    if (_isDisposed) {
      return;
    }
    videoOptionBuilder = builder;
    value = VideoPlayerValue(duration: Duration.zero, isLooping: value.isLooping, volume: value.volume);
    await VideoPlayerPlatform.instance.setVideoOptionBuilder(textureId, builder);
  }

  @override
  Future<void> dispose() async {
    await _creatingCompleter!.future;
    if (!_isDisposed) {
      _isDisposed = true;
      _timer?.cancel();
      value = VideoPlayerValue.uninitialized();
      await _eventSubscription?.cancel();
      await _videoPlayerPlatform.dispose(_textureId);
      videoEventStreamController.close();
      _videoEventStreamSubscription?.cancel();
      _eventListeners.clear();
    }
    _lifeCycleObserver?.dispose();
    _isDisposed = true;
    super.dispose();
  }

  Future<void> setVideoOptionBuilder(VideoOptionBuilder builder) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setVideoOptionBuilder(textureId, builder);
  }

  Future<void> startPlayLogic() async {
    await _creatingCompleter!.future;
    value = value.copyWith(isPlaying: true);
    await _videoPlayerPlatform.startPlayLogic(_textureId);
  }

  Future<void> setUp(
    String url,
    bool cacheWithPlay,
    String cachePath,
    String title,
  ) async {
    await _creatingCompleter!.future;
    value = value.copyWith(isPlaying: false);
    await _videoPlayerPlatform.setUp(_textureId, url, cacheWithPlay, cachePath, title);
  }

  Future<void> clearCurrentCache() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.clearCurrentCache(_textureId);
  }

  Future<int> getCurrentPositionWhenPlaying(bool looping) async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getCurrentPositionWhenPlaying(_textureId);
  }

  Future<void> releaseAllVideos() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.releaseAllVideos(_textureId);
  }

  Future<VideoPlayState> getCurrentState() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getCurrentState(_textureId);
  }

  Future<void> setPlayTag(String tag) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setPlayTag(_textureId, tag);
  }

  Future<void> setPlayPosition(Duration position) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setPlayPosition(_textureId, position.inMilliseconds);
  }

  Future<int> getNetSpeed() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getNetSpeed(_textureId);
  }

  Future<String> getNetSpeedText() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getNetSpeedText(_textureId);
  }

  Future<void> setSeekOnStart(int msec) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setSeekOnStart(_textureId, msec);
  }

  Future<int> getBuffterPoint() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getBuffterPoint(_textureId);
  }

  Future<GsyVideoPlayerType> setPlayerFactory(GsyVideoPlayerType playerType) async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.setPlayerFactory(_textureId, playerType);
  }

  Future<void> getPlayFactory() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.getPlayFactory(_textureId);
  }

  Future<void> setExoCacheManager() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setExoCacheManager(_textureId);
  }

  Future<void> setProxyCacheManager() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setProxyCacheManager(_textureId);
  }

  Future<void> clearAllDefaultCache() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.clearAllDefaultCache(_textureId);
  }

  Future<void> clearDefaultCache(String cacheDir, String url) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.clearDefaultCache(_textureId, cacheDir, url);
  }

  Future<void> releaseMediaPlayer() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.releaseMediaPlayer(_textureId);
  }

  Future<String> getPlayTag() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getPlayTag(_textureId);
  }

  Future<Duration> getPlayPosition() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getPlayPosition(_textureId);
  }

  Future<List<IjkOption>> getOptionModelList() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getOptionModelList(_textureId);
  }

  Future<void> setOptionModelList(List<IjkOption> optionModelList) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setOptionModelList(_textureId, optionModelList);
  }

  Future<bool> isNeedMute() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isNeedMute(_textureId);
  }

  void enterFullScreen() {
    value = value.copyWith(isFullScreen: true);
    _postEvent(VideoEventType.startWindowFullscreen);
  }

  void toggleFullScreen() {
    if (value.isFullScreen) {
      exitFullScreen();
    } else {
      enterFullScreen();
    }
  }

  void exitFullScreen() {
    value = value.copyWith(isFullScreen: false);
    _postEvent(VideoEventType.exitWindowFullscreen);
  }

  Future<void> setNeedMute(bool needMute) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setNeedMute(_textureId, needMute);
  }

  Future<int> getTimeOut() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getTimeOut(_textureId);
  }

  Future<bool> isNeedTimeOutOther() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isNeedTimeOutOther(_textureId);
  }

  Future<void> setTimeOut(int timeOut, {bool needTimeOutOther = false}) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setTimeOut(_textureId, timeOut, needTimeOutOther: needTimeOutOther);
  }

  Future<void> setLogLevel(LogLevel level) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setLogLevel(_textureId, level);
  }

  Future<bool> isMediaCodec() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isMediaCodec(_textureId);
  }

  Future<double> getScreenScaleRatio() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getScreenScaleRatio(_textureId);
  }

  Future<void> setScreenScaleRatio(double ratio) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setScreenScaleRatio(_textureId, ratio);
  }

  Future<bool> isMediaCodecTexture() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isMediaCodecTexture(_textureId);
  }

  Future<GsyVideoPlayerRenderType> getRenderType() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getRenderType(_textureId);
  }

  Future<void> setRenderType(GsyVideoPlayerRenderType renderType) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setRenderType(_textureId, renderType);
  }

  Future<void> setMediaCodec(bool mediaCodec) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setMediaCodec(_textureId, mediaCodec);
  }

  Future<void> setMediaCodecTexture(bool mediaCodecTexture) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setMediaCodecTexture(_textureId, mediaCodecTexture);
  }

  Future<int> getSeekOnStart() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getSeekOnStart(_textureId);
  }

  Future<bool> isLooping() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isLooping(_textureId);
  }

  Future<void> setLooping(bool looping) async {
    await _creatingCompleter!.future;
    value = value.copyWith(isLooping: looping);
    await _applyLooping();
  }

  Future<double> getSpeed() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getSpeed(_textureId);
  }

  Future<void> setSpeed(double speed) async {
    await _creatingCompleter!.future;
    value = value.copyWith(speed: speed);
    await _applySpeed();
  }

  Future<void> setSpeedPlaying(double speed, {bool soundTouch = true}) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setSpeedPlaying(_textureId, speed, soundTouch: soundTouch);
  }

  /// The position in the current video.
  Future<Duration?> get position async {
    if (_isDisposed) {
      return null;
    }
    return await _videoPlayerPlatform.getPlayPosition(_textureId);
  }

  Future<void> seekTo(Duration msec) async {
    await _creatingCompleter!.future;
    if (msec > value.duration) {
      msec = value.duration;
    } else if (msec < Duration.zero) {
      msec = Duration.zero;
    }

    await _videoPlayerPlatform.seekTo(_textureId, msec.inMilliseconds);
    _updatePosition(msec);
  }

  Future<void> setMatrixGL(List<double> matrix) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setMatrixGL(_textureId, matrix);
  }

  Future<void> releaseWhenLossAudio() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.releaseWhenLossAudio(_textureId);
  }

  Future<void> setReleaseWhenLossAudio(bool releaseWhenLossAudio) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setReleaseWhenLossAudio(_textureId, releaseWhenLossAudio);
  }

  /// Pauses the video.
  Future<void> pause() async {
    await _creatingCompleter!.future;
    value = value.copyWith(isPlaying: false);
    await _applyPlayPause();
  }

  /// resume the video.
  Future<void> resume() async {
    await _creatingCompleter!.future;
    if (value.isCompleted) {
      await seekTo(Duration.zero);
    }
    value = value.copyWith(isPlaying: true, position: Duration.zero);
    await _applyPlayPause();
  }

  Future<void> _applyLooping() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setLooping(_textureId, value.isLooping);
  }

  playOrPause() {
    if (value.isPlaying) {
      value = value.copyWith(isPlaying: false);
    } else {
      value = value.copyWith(isPlaying: true);
    }
    _applyPlayPause();
  }

  void setBoxFit(BoxFit fit) {
    value = value.copyWith(fit: fit);
    _postEvent(VideoEventType.changeBoxFit);
  }

  Future<void> _applyPlayPause() async {
    await _creatingCompleter!.future;
    if (value.isPlaying) {
      await _videoPlayerPlatform.resume(_textureId);
      _timer?.cancel();
      _timer = Timer.periodic(
        const Duration(milliseconds: 500),
        (Timer timer) async {
          if (_isDisposed) {
            return;
          }
          final Duration? newPosition = await position;
          if (newPosition == null) {
            return;
          }
          _updatePosition(newPosition);
        },
      );
      await _applyPlaybackSpeed();
    } else {
      _timer?.cancel();
      await _videoPlayerPlatform.pause(_textureId);
    }
  }

  Future<void> _applyPlaybackSpeed() async {
    await _creatingCompleter!.future;
    if (!value.isPlaying) {
      return;
    }
    await _videoPlayerPlatform.setSpeedPlaying(
      _textureId,
      value.playbackSpeed,
    );
  }

  void _updatePosition(Duration position) {
    value = value.copyWith(position: position);
  }

  Future<void> _applyVolume() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setVolume(_textureId, value.volume);
  }

  Future<void> _applySpeed() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setSpeed(_textureId, value.speed);
  }

  /// Sets the audio volume of [this].
  ///
  /// [volume] indicates a value between 0.0 (silent) and 1.0 (full volume) on a
  /// linear scale.
  Future<void> setVolume(double volume) async {
    await _creatingCompleter!.future;
    value = value.copyWith(volume: volume.clamp(0.0, 1.0));
    await _applyVolume();
  }

  void setAspectRatio(double aspectRatio) {
    value = value.copyWith(aspectRatio: aspectRatio);
    _postEvent(VideoEventType.changeAspectRatio);
  }

  Future<void> resolveByClick() {
    return _videoPlayerPlatform.resolveByClick(_textureId);
  }

  Future<void> backToProtVideo() {
    return _videoPlayerPlatform.backToProtVideo(_textureId);
  }

  Future<bool> isOrientationRotateEnable() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isOrientationRotateEnable(_textureId);
  }

  Future<void> setOrientationRotateEnable(bool enable) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setOrientationRotateEnable(_textureId, enable);
  }

  Future<bool> getOrientationRotateIsLand() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getOrientationRotateIsLand(_textureId);
  }

  Future<void> setOrientationRotateLand(bool isLand) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setOrientationRotateLand(_textureId, isLand);
  }

  Future<OrientationScreenType> getOrientationRotateScreenType() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.getOrientationRotateScreenType(_textureId);
  }

  Future<void> setOrientationRotateScreenType(OrientationScreenType screenType) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setOrientationRotateScreenType(_textureId, screenType);
  }

  Future<bool> isOrientationRotateClick() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isOrientationRotateClick(_textureId);
  }

  Future<void> setOrientationRotateIsClick(bool isClick) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setOrientationRotateIsClick(_textureId, isClick);
  }

  Future<bool> isOrientationRotateClickLand() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isOrientationRotateClickLand(_textureId);
  }

  Future<void> setOrientationRotateIsClickLand(bool isClickLand) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setOrientationRotateIsClickLand(_textureId, isClickLand);
  }

  Future<bool> isOrientationRotateClickPort() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isOrientationRotateClickPort(_textureId);
  }

  Future<void> setOrientationRotateIslickPort(bool islickPort) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setOrientationRotateIslickPort(_textureId, islickPort);
  }

  Future<bool> isOrientationRotatePause() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isOrientationRotatePause(_textureId);
  }

  Future<void> setOrientationRotateIsPause(bool isPause) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setOrientationRotateIsPause(_textureId, isPause);
  }

  Future<bool> isOrientationRotateOnlyRotateLand() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isOrientationRotateOnlyRotateLand(_textureId);
  }

  Future<void> setOrientationRotateIsOnlyRotateLand(bool isOnlyRotateLand) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setOrientationRotateIsOnlyRotateLand(_textureId, isOnlyRotateLand);
  }

  Future<bool> isOrientationRotateWithSystem() async {
    await _creatingCompleter!.future;
    return await _videoPlayerPlatform.isOrientationRotateWithSystem(_textureId);
  }

  Future<void> setOrientationRotateWithSystem(bool isRotateWithSystem) async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.setOrientationRotateWithSystem(_textureId, isRotateWithSystem);
  }

  Future<void> releaseOrientation() async {
    await _creatingCompleter!.future;
    await _videoPlayerPlatform.releaseOrientation(_textureId);
  }

  Future<void> onEnterFullScreen() async {
    await _creatingCompleter!.future;
    value = value.copyWith(isFullScreen: true);
    _postEvent(VideoEventType.startWindowFullscreen);
  }

  Future<void> onExitFullScreen() async {
    await _creatingCompleter!.future;
    value = value.copyWith(isFullScreen: false);
    _postEvent(VideoEventType.exitWindowFullscreen);
  }

  Future<void> enablePictureInPicture({double? top, double? left, double? width, double? height}) async {
    await _videoPlayerPlatform.enablePictureInPicture(textureId, top, left, width, height);
  }

  Future<void> disablePictureInPicture() async {
    await _videoPlayerPlatform.disablePictureInPicture(textureId);
  }

  Future<bool?> isPictureInPictureSupported() async {
    return _videoPlayerPlatform.isPictureInPictureEnabled(_textureId);
  }

  void refresh() {
    value = value.copyWith();
  }
}

/// Widget that displays the video controlled by [controller].
class GsyVideoPlayer extends StatefulWidget {
  /// Uses the given [controller] for all video rendered in this widget.
  ///
  final GsyVideoPlayerController controller;

  const GsyVideoPlayer({super.key, required this.controller, this.onViewReady});

  final void Function(int)? onViewReady;

  @override
  State<GsyVideoPlayer> createState() => _GsyVideoPlayerState();
}

class _GsyVideoPlayerState extends State<GsyVideoPlayer> {
  _GsyVideoPlayerState() {
    _listener = () {
      final int newTextureId = widget.controller.textureId;
      if (newTextureId != _textureId) {
        setState(() {
          _textureId = newTextureId;
        });
      }
    };
  }

  late VoidCallback _listener;

  late int _textureId;

  @override
  void initState() {
    super.initState();
    _textureId = widget.controller.textureId;
    widget.onViewReady?.call(_textureId);
    // Need to listen for initialization events since the actual texture ID
    // becomes available after asynchronous initialization finishes.
    widget.controller.addListener(_listener);
  }

  @override
  void didUpdateWidget(GsyVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller.removeListener(_listener);
    _textureId = widget.controller.textureId;
    widget.controller.addListener(_listener);
  }

  @override
  void deactivate() {
    super.deactivate();
    widget.controller.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return _textureId == GsyVideoPlayerController.kUninitializedTextureId
        ? Container()
        : _VideoPlayerWithRotation(
            rotation: widget.controller.value.rotationCorrection,
            child: _videoPlayerPlatform.buildView(_textureId),
          );
  }
}

class _VideoPlayerWithRotation extends StatelessWidget {
  const _VideoPlayerWithRotation({required this.rotation, required this.child});
  final int rotation;
  final Widget child;

  @override
  Widget build(BuildContext context) => rotation == 0
      ? child
      : Transform.rotate(
          angle: rotation * math.pi / 180,
          child: child,
        );
}

class _VideoAppLifeCycleObserver extends Object with WidgetsBindingObserver {
  _VideoAppLifeCycleObserver(this._controller);

  bool _wasPlayingBeforePause = false;
  final GsyVideoPlayerController _controller;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _wasPlayingBeforePause = _controller.value.isPlaying;
      _controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (_wasPlayingBeforePause) {
        _controller.resume();
      }
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}

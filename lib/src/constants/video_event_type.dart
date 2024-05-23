/// Type of the event.
///
/// Emitted by the platform implementation when the video is initialized or
/// completed or to communicate buffering events.
enum VideoEventType {
  /// The video has been initialized.
  initialized,

  onConfigurationChanged,

  onPrepared,

  onAutoCompletion,

  onCompletion,

  onBufferingUpdate,

  onBufferingEnd,

  onSeekComplete,

  onError,

  onInfo,

  onVideoSizeChanged,

  onVideoPause,

  onVideoResume,

  onVideoResumeWithSeek,

  onVideoPlayerInitialized,

  pipStart,

  pipStop,

  startWindowFullscreen,

  exitWindowFullscreen,

  changeBoxFit,

  changeAspectRatio,

  unknown,
}

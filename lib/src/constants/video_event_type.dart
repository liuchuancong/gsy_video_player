/// Type of the event.
///
/// Emitted by the platform implementation when the video is initialized or
/// completed or to communicate buffering events.
enum VideoEventType {
  /// The video has been initialized.
  initialized,

  //开始加载
  onEventStartPrepared,

  //加载成功
  onEventPrepared,

  //点击了开始按键播放
  onEventClickStartIcon,

  //点击了错误状态下的开始按键
  onEventClickStartError,

  //点击了播放状态下的开始按键
  onEventClickStop,
  //点击了全屏播放状态下的开始按键-
  onEventClickStopFullscreen,
  //点击了暂停状态下的开始按键
  onEventClickResume,
  //点击了全屏暂停状态下的开始按键
  onEventClickResumeFullscreen,
  //点击了空白弹出seekbar
  onEventClickSeekbar,
  //点击了全屏的seekbar
  onEventClickSeekbarFullscreen,
  //播放完了
  onEventAutoComplete,
  //进去全屏
  onEventEnterFullscreen,
  //退出全屏
  onEventQuitFullscreen,
  //进入小窗口
  onEventQuitSmallWidget,
  //退出小窗口
  onEventEnterSmallWidget,
  //触摸调整声音
  onEventTouchScreenSeekVolume,
  //触摸调整进度
  onEventTouchScreenSeekPosition,
  //触摸调整亮度
  onEventTouchScreenSeekLight,
  //播放错误
  onEventPlayError,
  //点击了空白区域开始播放
  onEventClickStartThumb,
  //点击了播放中的空白区域
  onEventClickBlank,
//点击了全屏播放中的空白区域
  onEventClickBlankFullscreen,
  //非正常播放完了
  onEventComplete,
  //进度回调
  onEventProgress,

  onListenerPrepared,

  onListenerAutoCompletion,

  onListenerCompletion,

  onListenerBufferingUpdate,

  onListenerSeekComplete,

  onListenerError,

  onListenerInfo,

  onListenerVideoSizeChanged,

  onListenerBackFullscreen,

  onListenerVideoPause,

  onListenerVideoResume,

  onListenerVideoResumeWithSeek,

  unknown
}

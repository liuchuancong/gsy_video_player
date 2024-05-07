enum VideoPlayState { normal, prepareing, playing, playingBufferingStart, pause, completed, error, unknown }

VideoPlayState getVideoPlayStateName(int state) {
  switch (state) {
    case 0:
      return VideoPlayState.normal;
    case 1:
      return VideoPlayState.prepareing;
    case 2:
      return VideoPlayState.playing;
    case 3:
      return VideoPlayState.playingBufferingStart;
    case 4:
      return VideoPlayState.pause;
    case 5:
      return VideoPlayState.completed;
    case 6:
      return VideoPlayState.error;
    case 7:
      return VideoPlayState.unknown;
    default:
      return VideoPlayState.unknown;
  }
}

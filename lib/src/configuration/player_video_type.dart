enum GsyVideoPlayerType {
  exo,
  sysytem,
  ijk,
  ali,
}

GsyVideoPlayerType getVideoPlayerType(int index) {
  switch (index) {
    case 0:
      return GsyVideoPlayerType.exo;
    case 1:
      return GsyVideoPlayerType.sysytem;
    case 2:
      return GsyVideoPlayerType.ijk;
    case 3:
      return GsyVideoPlayerType.ali;
    default:
      return GsyVideoPlayerType.exo;
  }
}

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

int getGsyVideoPlayerType(GsyVideoPlayerType type) {
  switch (type) {
    case GsyVideoPlayerType.exo:
      return 0;
    case GsyVideoPlayerType.sysytem:
      return 1;
    case GsyVideoPlayerType.ijk:
      return 2;
    case GsyVideoPlayerType.ali:
      return 3;
  }
}

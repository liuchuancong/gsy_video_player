enum IjkCategory {
  format,
  codec,
  sws,
  player,
}

IjkCategory getIjkCategory(int category) {
  switch (category) {
    case 0:
      return IjkCategory.format;
    case 1:
      return IjkCategory.codec;
    case 2:
      return IjkCategory.sws;
    case 3:
      return IjkCategory.player;
    default:
      return IjkCategory.format;
  }
}

enum MaximumVisibleSizeInScreen { auto, unlimited }

MaximumVisibleSizeInScreen getMaximumVisibleSizeInScreenFromInt(int value) {
  switch (value) {
    case -1:
      return MaximumVisibleSizeInScreen.auto;
    case 0:
      return MaximumVisibleSizeInScreen.unlimited;
    default:
      return MaximumVisibleSizeInScreen.auto;
  }
}

int getIntFromMaximumVisibleSizeInScreen(MaximumVisibleSizeInScreen value) {
  switch (value) {
    case MaximumVisibleSizeInScreen.auto:
      return -1;
    case MaximumVisibleSizeInScreen.unlimited:
      return 0;
  }
}

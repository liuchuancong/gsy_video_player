enum PlayerVideoShowType {
  //16:9//默认显示比例
  screenTypeDefault,
  //16:9
  screenType16_9,
  //4:3
  screenType4_3,
  //全屏裁减显示
  screenTypeFull,
  //全屏拉伸显示
  screenTypeMatchFull,
  //18:9
  screenType18_9,
  //自定义
  screenTypeCustom,
}

PlayerVideoShowType getPlayerVideoShowType(int showType) {
  switch (showType) {
    case 0:
      return PlayerVideoShowType.screenTypeDefault;
    case 1:
      return PlayerVideoShowType.screenType16_9;
    case 2:
      return PlayerVideoShowType.screenType4_3;
    case 3:
      return PlayerVideoShowType.screenTypeFull;
    case 4:
      return PlayerVideoShowType.screenTypeMatchFull;
    case 5:
      return PlayerVideoShowType.screenType18_9;
    case 6:
      return PlayerVideoShowType.screenTypeCustom;
    default:
      return PlayerVideoShowType.screenTypeDefault;
  }
}

int getPlayerVideoShowTypeIntValue(PlayerVideoShowType showType) {
  switch (showType) {
    case PlayerVideoShowType.screenTypeDefault:
      return 0;
    case PlayerVideoShowType.screenType16_9:
      return 1;
    case PlayerVideoShowType.screenType4_3:
      return 2;
    case PlayerVideoShowType.screenTypeFull:
      return 3;
    case PlayerVideoShowType.screenTypeMatchFull:
      return 4;
    case PlayerVideoShowType.screenType18_9:
      return 5;
    case PlayerVideoShowType.screenTypeCustom:
      return 6;
  }
}

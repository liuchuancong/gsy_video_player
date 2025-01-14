enum OrientationScreenType {
  screenOrientationUnset,

  screenOrientationUnspecified,

  screenOrientationLandscape,

  screenOrientationPortrait,

  screenOrientationUser,

  screenOrientationBehind,

  screenOrientationSensor,

  screenOrientationNosensor,

  screenOrientationSensorLandscape,

  screenOrientationSensorPortrait,

  screenOrientationReverseLandscape,

  screenOrientationReversePortrait,

  screenOrientationFullSensor,

  screenOrientationUserLandscape,

  screenOrientationUserPortrait,

  screenOrientationFullUser,

  screenOrientationLocked,
}

OrientationScreenType getOrientationScreenType(int orientation) {
  switch (orientation) {
    case -2:
      return OrientationScreenType.screenOrientationUnset;
    case -1:
      return OrientationScreenType.screenOrientationUnspecified;
    case 0:
      return OrientationScreenType.screenOrientationLandscape;
    case 1:
      return OrientationScreenType.screenOrientationPortrait;
    case 2:
      return OrientationScreenType.screenOrientationUser;
    case 3:
      return OrientationScreenType.screenOrientationBehind;
    case 4:
      return OrientationScreenType.screenOrientationSensor;
    case 5:
      return OrientationScreenType.screenOrientationNosensor;
    case 6:
      return OrientationScreenType.screenOrientationSensorLandscape;
    case 7:
      return OrientationScreenType.screenOrientationSensorPortrait;
    case 8:
      return OrientationScreenType.screenOrientationReverseLandscape;
    case 9:
      return OrientationScreenType.screenOrientationReversePortrait;
    case 10:
      return OrientationScreenType.screenOrientationFullSensor;
    case 11:
      return OrientationScreenType.screenOrientationUserLandscape;
    case 12:
      return OrientationScreenType.screenOrientationUserPortrait;
    case 13:
      return OrientationScreenType.screenOrientationFullUser;
    case 14:
      return OrientationScreenType.screenOrientationLocked;
    default:
      return OrientationScreenType.screenOrientationUnset;
  }
}

int getOrientationScreenTypeIntValue(OrientationScreenType type) {
  switch (type) {
    case OrientationScreenType.screenOrientationUnset:
      return -2;
    case OrientationScreenType.screenOrientationUnspecified:
      return -1;
    case OrientationScreenType.screenOrientationLandscape:
      return 0;
    case OrientationScreenType.screenOrientationPortrait:
      return 1;
    case OrientationScreenType.screenOrientationUser:
      return 2;
    case OrientationScreenType.screenOrientationBehind:
      return 3;
    case OrientationScreenType.screenOrientationSensor:
      return 4;
    case OrientationScreenType.screenOrientationNosensor:
      return 5;
    case OrientationScreenType.screenOrientationSensorLandscape:
      return 6;
    case OrientationScreenType.screenOrientationSensorPortrait:
      return 7;
    case OrientationScreenType.screenOrientationReverseLandscape:
      return 8;
    case OrientationScreenType.screenOrientationReversePortrait:
      return 9;
    case OrientationScreenType.screenOrientationFullSensor:
      return 10;
    case OrientationScreenType.screenOrientationUserLandscape:
      return 11;
    case OrientationScreenType.screenOrientationUserPortrait:
      return 12;
    case OrientationScreenType.screenOrientationFullUser:
      return 13;
    case OrientationScreenType.screenOrientationLocked:
      return 14;
  }
}

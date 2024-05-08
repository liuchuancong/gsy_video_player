// MEDIA_ERROR_UNSUPPORTED = -1010,
// MEDIA_ERROR_TIMED_OUT = -110,
// MEDIA_ERROR_IJK_PLAYER = -10000,

enum MediaErrorCategory {
  mediaErrorUnknown,
  mediaErrorServerDied,
  mediaErrorNotValidForProgressivePlayback,
  mediaErrorIO,
  mediaErrorMalformed,
  mediaErrorUnsupported,
  mediaErrorTimedOut,
  mediaErrorIjkPlayer,
}

MediaErrorCategory mediaErrorCategoryForInt(int value) {
  switch (value) {
    case 1:
      return MediaErrorCategory.mediaErrorUnknown;
    case 100:
      return MediaErrorCategory.mediaErrorServerDied;
    case 200:
      return MediaErrorCategory.mediaErrorNotValidForProgressivePlayback;
    case -1004:
      return MediaErrorCategory.mediaErrorIO;
    case -1007:
      return MediaErrorCategory.mediaErrorMalformed;
    case -1010:
      return MediaErrorCategory.mediaErrorUnsupported;
    case -110:
      return MediaErrorCategory.mediaErrorTimedOut;
    case -10000:
      return MediaErrorCategory.mediaErrorIjkPlayer;
    default:
      return MediaErrorCategory.mediaErrorUnknown;
  }
}

enum MediaInfoCategory {
  mediaInfoUnknow,
  mediaInfoStartedAsNext,
  mediaInfoVideoRenderingStart,
  mediaInfoVideoTrackLagging,
  mediaInfoBufferingStart,
  mediaInfoBufferingEnd,
  mediaInfoNetworkBandwidth,
  mediaInfoBadInterleaving,
  mediaInfoNotSeekable,
  mediaInfoMetadataUpdate,
  mediaInfoTimedTextError,
  mediaInfoUnsupportedSubtitle,
  mediaInfoSubtitleTimedOut,
  mediaInfoVideoRotationChanged,
  mediaInfoAudioRenderingStart,
  mediaInfoAudioDecodedStart,
  mediaInfoVideoDecodedStart,
  mediaInfoOpenInput,
  mediaInfoFindStreamInfo,
  mediaInfoComponentOpen,
  mediaInfoVideoSeekRenderingStart,
  mediaInfoAudioSeekRenderingStart,
  mediaInfoMediaAccurateSeekComplete
}

MediaInfoCategory mediaInfoCategoryForInt(int value) {
  switch (value) {
    case 1:
      return MediaInfoCategory.mediaInfoUnknow;
    case 2:
      return MediaInfoCategory.mediaInfoStartedAsNext;
    case 3:
      return MediaInfoCategory.mediaInfoVideoRenderingStart;
    case 700:
      return MediaInfoCategory.mediaInfoVideoTrackLagging;
    case 701:
      return MediaInfoCategory.mediaInfoBufferingStart;
    case 702:
      return MediaInfoCategory.mediaInfoBufferingEnd;
    case 703:
      return MediaInfoCategory.mediaInfoNetworkBandwidth;
    case 800:
      return MediaInfoCategory.mediaInfoBadInterleaving;
    case 801:
      return MediaInfoCategory.mediaInfoNotSeekable;
    case 802:
      return MediaInfoCategory.mediaInfoMetadataUpdate;
    case 900:
      return MediaInfoCategory.mediaInfoTimedTextError;
    case 901:
      return MediaInfoCategory.mediaInfoUnsupportedSubtitle;
    case 902:
      return MediaInfoCategory.mediaInfoSubtitleTimedOut;
    case 10001:
      return MediaInfoCategory.mediaInfoVideoRotationChanged;
    case 10002:
      return MediaInfoCategory.mediaInfoAudioRenderingStart;
    case 10003:
      return MediaInfoCategory.mediaInfoAudioDecodedStart;
    case 10004:
      return MediaInfoCategory.mediaInfoVideoDecodedStart;
    case 10005:
      return MediaInfoCategory.mediaInfoOpenInput;
    case 10006:
      return MediaInfoCategory.mediaInfoFindStreamInfo;
    case 10007:
      return MediaInfoCategory.mediaInfoComponentOpen;
    case 10008:
      return MediaInfoCategory.mediaInfoVideoSeekRenderingStart;
    case 10009:
      return MediaInfoCategory.mediaInfoAudioSeekRenderingStart;
    case 10100:
      return MediaInfoCategory.mediaInfoMediaAccurateSeekComplete;
    default:
      return MediaInfoCategory.mediaInfoUnknow;
  }
}

package com.alizda.gsy_video_player
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** GsyVideoPlayerPlugin */
class GsyVideoPlayerPlugin: FlutterPlugin, ActivityAware {

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    binding.platformViewRegistry
      .registerViewFactory(
        EVENTS_CHANNEL,
        GsyVideoPlayerFactory(binding.binaryMessenger)
      )
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    GsyVideoShared.activity = binding.activity
    GsyVideoShared.binding = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    GsyVideoShared.activity = null
    GsyVideoShared.binding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    GsyVideoShared.activity = binding.activity
    GsyVideoShared.binding = binding
  }

  override fun onDetachedFromActivity() {
    GsyVideoShared.activity = null
    GsyVideoShared.binding = null
  }
  companion object {
    private const val TAG = "GsyVideoPlayerPlugin"
    private const val CHANNEL = "gsy_video_player_channel"
    private const val EVENTS_CHANNEL = "gsy_video_player_channel/videoView"
    private const val DATA_SOURCE_PARAMETER = "dataSource"
    private const val KEY_PARAMETER = "key"
    private const val HEADERS_PARAMETER = "headers"
    private const val USE_CACHE_PARAMETER = "useCache"
    private const val ASSET_PARAMETER = "asset"
    private const val PACKAGE_PARAMETER = "package"
    private const val URI_PARAMETER = "uri"
    private const val FORMAT_HINT_PARAMETER = "formatHint"
    private const val TEXTURE_ID_PARAMETER = "textureId"
    private const val LOOPING_PARAMETER = "looping"
    private const val VOLUME_PARAMETER = "volume"
    private const val LOCATION_PARAMETER = "location"
    private const val SPEED_PARAMETER = "speed"
    private const val WIDTH_PARAMETER = "width"
    private const val HEIGHT_PARAMETER = "height"
    private const val BITRATE_PARAMETER = "bitrate"
    private const val SHOW_NOTIFICATION_PARAMETER = "showNotification"
    private const val TITLE_PARAMETER = "title"
    private const val AUTHOR_PARAMETER = "author"
    private const val IMAGE_URL_PARAMETER = "imageUrl"
    private const val NOTIFICATION_CHANNEL_NAME_PARAMETER = "notificationChannelName"
    private const val OVERRIDDEN_DURATION_PARAMETER = "overriddenDuration"
    private const val NAME_PARAMETER = "name"
    private const val INDEX_PARAMETER = "index"
    private const val LICENSE_URL_PARAMETER = "licenseUrl"
    private const val DRM_HEADERS_PARAMETER = "drmHeaders"
    private const val DRM_CLEARKEY_PARAMETER = "clearKey"
    private const val MIX_WITH_OTHERS_PARAMETER = "mixWithOthers"
    const val URL_PARAMETER = "url"
    const val PRE_CACHE_SIZE_PARAMETER = "preCacheSize"
    const val MAX_CACHE_SIZE_PARAMETER = "maxCacheSize"
    const val MAX_CACHE_FILE_SIZE_PARAMETER = "maxCacheFileSize"
    const val HEADER_PARAMETER = "header_"
    const val ACTIVITY_NAME_PARAMETER = "activityName"
    const val PACKAGE_NAME_PARAMETER = "packageName"
    const val MIN_BUFFER_MS = "minBufferMs"
    const val MAX_BUFFER_MS = "maxBufferMs"
    const val BUFFER_FOR_PLAYBACK_MS = "bufferForPlaybackMs"
    const val BUFFER_FOR_PLAYBACK_AFTER_REBUFFER_MS = "bufferForPlaybackAfterRebufferMs"
    const val CACHE_KEY_PARAMETER = "cacheKey"
    private const val INIT_METHOD = "init"
    private const val CREATE_METHOD = "create"
    private const val SET_DATA_SOURCE_METHOD = "setDataSource"
    private const val SET_LOOPING_METHOD = "setLooping"
    private const val SET_VOLUME_METHOD = "setVolume"
    private const val PLAY_METHOD = "play"
    private const val PAUSE_METHOD = "pause"
    private const val SEEK_TO_METHOD = "seekTo"
    private const val POSITION_METHOD = "position"
    private const val ABSOLUTE_POSITION_METHOD = "absolutePosition"
    private const val SET_SPEED_METHOD = "setSpeed"
    private const val SET_TRACK_PARAMETERS_METHOD = "setTrackParameters"
    private const val SET_AUDIO_TRACK_METHOD = "setAudioTrack"
    private const val ENABLE_PICTURE_IN_PICTURE_METHOD = "enablePictureInPicture"
    private const val DISABLE_PICTURE_IN_PICTURE_METHOD = "disablePictureInPicture"
    private const val IS_PICTURE_IN_PICTURE_SUPPORTED_METHOD = "isPictureInPictureSupported"
    private const val SET_MIX_WITH_OTHERS_METHOD = "setMixWithOthers"
    private const val CLEAR_CACHE_METHOD = "clearCache"
    private const val DISPOSE_METHOD = "dispose"
    private const val PRE_CACHE_METHOD = "preCache"
    private const val STOP_PRE_CACHE_METHOD = "stopPreCache"
  }
}


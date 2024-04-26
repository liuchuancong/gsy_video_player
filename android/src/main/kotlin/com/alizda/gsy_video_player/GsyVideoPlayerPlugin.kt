package com.alizda.gsy_video_player
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** GsyVideoPlayerPlugin */
class GsyVideoPlayerPlugin: FlutterPlugin, ActivityAware {

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    binding.platformViewRegistry
      .registerViewFactory(
        CHANNEL,
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
    private const val CHANNEL = "gsy_video_player_channel/platform_view"
  }
}


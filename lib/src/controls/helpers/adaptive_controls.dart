import 'package:flutter/material.dart';
import 'package:gsy_video_player/src/controls/material/material_controls.dart';
import 'package:gsy_video_player/src/controls/cupertino/cupertino_controls.dart';
import 'package:gsy_video_player/src/controls/material/material_desktop_controls.dart';

class AdaptiveControls extends StatelessWidget {
  const AdaptiveControls({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return const MaterialControls();

      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return const MaterialDesktopControls();

      case TargetPlatform.iOS:
        return const CupertinoControls(
          backgroundColor: Color.fromRGBO(41, 41, 41, 0.7),
          iconColor: Color.fromARGB(255, 200, 200, 200),
        );
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:gsy_video_player/src/controls/models/option_item.dart';

class CupertinoOptionsDialog extends StatefulWidget {
  const CupertinoOptionsDialog({
    super.key,
    required this.options,
    this.cancelButtonText,
  });

  final List<OptionItem> options;
  final String? cancelButtonText;

  @override
  // ignore: library_private_types_in_public_api
  _CupertinoOptionsDialogState createState() => _CupertinoOptionsDialogState();
}

class _CupertinoOptionsDialogState extends State<CupertinoOptionsDialog> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoActionSheet(
        actions: widget.options
            .map(
              (option) => CupertinoActionSheetAction(
                onPressed: () => option.onTap!(),
                child: Text(option.title),
              ),
            )
            .toList(),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDestructiveAction: true,
          child: Text(widget.cancelButtonText ?? 'Cancel'),
        ),
      ),
    );
  }
}
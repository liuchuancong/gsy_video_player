import 'package:gsy_video_player/src/constants/ijk_category.dart';

class IjkOption {
  final String name;
  final int value;
  final IjkCategory category;
  IjkOption({
    required this.category,
    required this.name,
    required this.value,
  });
}

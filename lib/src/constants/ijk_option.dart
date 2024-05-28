import 'package:gsy_video_player/src/constants/ijk_category.dart';

class IjkOption {
  final String name;
  final IjkCategory category;
  final int? valueInt;
  final String? value;
  IjkOption({
    required this.category,
    required this.name,
    this.valueInt,
    this.value = '',
  });
}

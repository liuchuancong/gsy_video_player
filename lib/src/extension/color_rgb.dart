import 'dart:ui';

extension ColorUtils on Color {
  String get rgbValue => getHexValue();
  String getHexValue() {
    return "#${value.toRadixString(16).toUpperCase()}";
  }
}

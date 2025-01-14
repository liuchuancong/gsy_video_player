import 'dart:ui';

extension ColorUtils on Color {
  String get rgbValue => getHexValue();
  String getHexValue() {
    // ignore: deprecated_member_use
    return "#${value.toRadixString(16).toUpperCase()}";
  }
}

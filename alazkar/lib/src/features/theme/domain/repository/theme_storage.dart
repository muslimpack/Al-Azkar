import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeStorage {
  static final box = GetStorage();

  static Brightness getBrightness() {
    final String? brightness = box.read('ThemeBrightness');
    return brightness == Brightness.light.toString()
        ? Brightness.light
        : Brightness.dark;
  }

  static Future setBrightness(Brightness brightness) async {
    await box.write('ThemeBrightness', brightness.toString());
  }

  static Color getColor() {
    final int? colorValue = box.read('ThemeColor');
    return colorValue != null ? Color(colorValue) : Colors.brown;
  }

  static Future setColor(Color color) async {
    await box.write('ThemeColor', color.value);
  }
}

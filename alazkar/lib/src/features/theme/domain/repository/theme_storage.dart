import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeStorage {
  static final box = GetStorage();

  /// *****************************
  static const String _brightnessKey = "ThemeBrightness";
  static Brightness getBrightness() {
    final String? brightness = box.read(_brightnessKey);
    return brightness == Brightness.light.toString()
        ? Brightness.light
        : Brightness.dark;
  }

  static Future setBrightness(Brightness brightness) async {
    await box.write(_brightnessKey, brightness.toString());
  }

  /// *****************************
  static const String _useMaterial3Key = "ThemeUseMaterial3";
  static bool getUseMaterial3() {
    final bool? useMaterial3 = box.read(_useMaterial3Key);
    return useMaterial3 ?? true;
  }

  static Future setUseMaterial3(bool useMaterial3) async {
    await box.write(_useMaterial3Key, useMaterial3);
  }

  /// *****************************
  static const String _colorKey = "ThemeColor";
  static Color getColor() {
    final int? colorValue = box.read(_colorKey);
    return colorValue != null ? Color(colorValue) : Colors.brown;
  }

  static Future setColor(Color color) async {
    await box.write(_colorKey, color.value);
  }

  /// *****************************
  static const String _fontSizeKey = "ThemeFontSize";
  static double getFontSize() {
    final double? data = box.read(_fontSizeKey);
    return data ?? 30;
  }

  static Future setFontSize(double fontSize) async {
    await box.write(_fontSizeKey, fontSize);
  }
}

import 'package:alazkar/src/core/extension/extension_color.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeStorage {
  final GetStorage box;
  ThemeStorage(this.box);

  /// *****************************
  static const String _brightnessKey = "ThemeBrightness";
  Brightness get getBrightness {
    final String? brightness = box.read(_brightnessKey);
    return brightness == Brightness.light.toString()
        ? Brightness.light
        : Brightness.dark;
  }

  Future setBrightness(Brightness brightness) async {
    await box.write(_brightnessKey, brightness.toString());
  }

  /// *****************************
  static const String _useMaterial3Key = "ThemeUseMaterial3";
  bool get getUseMaterial3 {
    final bool? useMaterial3 = box.read(_useMaterial3Key);
    return useMaterial3 ?? true;
  }

  Future setUseMaterial3(bool useMaterial3) async {
    await box.write(_useMaterial3Key, useMaterial3);
  }

  /// *****************************
  static const String _colorKey = "ThemeColor";
  Color get getColor {
    final int? colorValue = box.read(_colorKey);
    return colorValue != null ? Color(colorValue) : Colors.brown;
  }

  Future setColor(Color color) async {
    await box.write(_colorKey, color.toARGB32);
  }
}

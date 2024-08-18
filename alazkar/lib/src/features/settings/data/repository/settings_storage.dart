import 'dart:convert';

import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class SettingsStorage {
  static final _box = GetStorage();

  static const String _settingsPrefixNameKey = "SettingsStorage";

  /// Titles Freq filters
  static const String _showTextInBrackets =
      "${_settingsPrefixNameKey}showTextInBrackets";

  /// Filters for zikr source
  static bool showTextInBrackets() {
    final bool? data = _box.read(_showTextInBrackets);

    return data ?? true;
  }

  /// Filters for zikr source
  static Future setShowTextInBrackets(bool showTextInBrackets) async {
    return _box.write(_showTextInBrackets, showTextInBrackets);
  }

  ///* ******* desktop Window Size ******* */
  static const String desktopWindowSizeKey = "desktopWindowSize";
  static Size? get desktopWindowSize {
    try {
      final data =
          jsonDecode(_box.read(desktopWindowSizeKey) as String? ?? "{}")
              as Map<String, dynamic>;

      final double width = (data['width'] as num).toDouble();
      final double height = (data['height'] as num).toDouble();

      return Size(width, height);
    } catch (e) {
      appPrint(e);
    }
    return const Size(400, 800);
  }

  static Future<void> changeDesktopWindowSize(Size value) async {
    final screenSize = {
      'width': value.width,
      'height': value.height,
    };
    final String data = jsonEncode(screenSize);
    return _box.write(desktopWindowSizeKey, data);
  }
}

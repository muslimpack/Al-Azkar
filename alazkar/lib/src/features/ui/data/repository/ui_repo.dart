import 'dart:convert';

import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class UIRepo {
  final GetStorage box;

  UIRepo(this.box);

  ///* ******* desktop Window Size ******* */
  static const String desktopWindowSizeKey = "desktopWindowSize";
  Size? get desktopWindowSize {
    const Size defaultSize = Size(450, 950);
    try {
      final data = jsonDecode(
        box.read<String?>(desktopWindowSizeKey) ??
            '{"width":${defaultSize.width},"height":${defaultSize.height}}',
      ) as Map<String, dynamic>;
      appPrint(data);

      final double width = (data['width'] as num).toDouble();
      final double height = (data['height'] as num).toDouble();

      return Size(width, height);
    } catch (e) {
      appPrint(e);
    }
    return defaultSize;
  }

  Future<void> changeDesktopWindowSize(Size value) {
    final screenSize = {
      'width': value.width,
      'height': value.height,
    };
    final String data = jsonEncode(screenSize);
    return box.write(desktopWindowSizeKey, data);
  }
}

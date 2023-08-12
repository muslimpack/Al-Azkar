import 'package:flutter/foundation.dart';

void appPrint(Object? object) {
  printColor(object, color: PrintColors.green);
}

void printColor(Object? object, {int color = PrintColors.black}) {
  final orangeText = '\u001b[${color}m$object\u001b[0m';
  if (kDebugMode) {
    print(orangeText);
  }
}

class PrintColors {
  static const int black = 30;
  static const int red = 31;
  static const int green = 32;
  static const int yellow = 33;
  static const int blue = 34;
  static const int magenta = 35;
  static const int cyan = 36;
  static const int white = 37;
}

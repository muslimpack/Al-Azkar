import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ShareAsImageRepo {
  final GetStorage box;

  ShareAsImageRepo(this.box);

  ///MARK: show app info
  final String showAppInfoKey = 'share_image_show_app_info';
  bool get showAppInfo => box.read<bool?>(showAppInfoKey) ?? true;
  Future<void> updateShowAppInfo(bool show) async {
    await box.write(showAppInfoKey, show);
  }

  ///MARK: image text color
  final String textColorKey = 'share_image_text_color';
  Color get textColor => Color(
        box.read<int?>(textColorKey) ?? Colors.white.value,
      );
  Future<void> updateTextColor(Color color) async {
    await box.write(textColorKey, color.value);
  }

  ///MARK: image background color
  final String backgroundColorKey = 'share_image_background_color';
  Color get backgroundColor => Color(
        box.read<int?>(backgroundColorKey) ?? Colors.brown.value,
      );
  Future<void> updateBackgroundColor(Color color) async {
    await box.write(backgroundColorKey, color.value);
  }

  ///MARK: image font size
  final String fontSizeKey = 'share_image_font_size';
  double get fontSize => box.read(fontSizeKey) ?? 30;
  Future<void> updateFontSize(double value) async {
    await box.write(fontSizeKey, value);
  }

  ///MARK: image width
  final String imageWidthKey = 'share_image_image_width';
  double get imageWidth => box.read(imageWidthKey) ?? 900;
  Future<void> updateImageWidth(double value) async {
    await box.write(imageWidthKey, value);
  }

  ///MARK: image quality
  final String imageQualityKey = 'share_image_image_quality';
  double get imageQuality => box.read(imageQualityKey) ?? 2;
  Future<void> updateImageQuality(double value) async {
    await box.write(imageQualityKey, value);
  }
}

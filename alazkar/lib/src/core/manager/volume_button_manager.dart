import 'package:flutter/services.dart';

class VolumeButtonManager {
  static MethodChannel channel = const MethodChannel("volume_button_channel");

  static Future handler({
    required MethodCall call,
    required Function() onVolumeUpPressed,
    required Function() onVolumeDownPressed,
  }) async {
    if (call.method == "volumeBtnPressed") {
      if (call.arguments == "VOLUME_UP_DOWN") {
        onVolumeUpPressed();
      }
      if (call.arguments == "VOLUME_DOWN_DOWN") {
        onVolumeDownPressed();
      }

      return Future.value();
    }
  }

  static Future<void> setActivationStatus({required bool activate}) async {
    const volumeBtnChannel = MethodChannel("volume_button_channel");
    await volumeBtnChannel.invokeMethod(
      'activate_volumeBtn',
      activate,
    );
  }
}

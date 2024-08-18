import 'package:alazkar/src/core/extension/extension_platform.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String text) {
  try {
    if (PlatformExtension.isDesktop) {
      BotToast.showText(
        text: text,
        align: Alignment.bottomCenter,
        textStyle: const TextStyle(
          color: Colors.white,
        ),
        duration: const Duration(seconds: 1),
        contentPadding: const EdgeInsets.all(10),
      );
    } else {
      Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        backgroundColor: Colors.brown.withOpacity(.5),
      );
    }
  } catch (e) {
    appPrint(e);
  }
}

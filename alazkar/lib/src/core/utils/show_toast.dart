import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String text) {
  try {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      backgroundColor: Colors.brown.withOpacity(.5),
    );
  } catch (e) {
    appPrint(e);
  }
}

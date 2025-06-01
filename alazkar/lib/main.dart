import 'package:alazkar/app.dart';
import 'package:alazkar/error_screen.dart';
import 'package:alazkar/services.dart';
import 'package:flutter/material.dart';

void main() async {
  await initServices();
  ErrorWidget.builder = (FlutterErrorDetails details) => ErrorScreen(
        details: details,
      );
  runApp(const MyApp());
}

import 'package:alazkar/src/app.dart';
import 'package:alazkar/src/services.dart';
import 'package:flutter/material.dart';

void main() async {
  await initServices();
  runApp(const MyApp());
}

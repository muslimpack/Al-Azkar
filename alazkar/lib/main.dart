import 'package:alazkar/app.dart';
import 'package:alazkar/services.dart';
import 'package:flutter/material.dart';

void main() async {
  await initServices();
  runApp(const MyApp());
}

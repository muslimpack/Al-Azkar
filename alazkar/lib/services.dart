import 'dart:io';

import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await GetStorage.init();
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) {
      printColor(
        '[Cubit] currentState: ${change.currentState.runtimeType} | nextState: ${change.nextState.runtimeType}',
        color: PrintColors.red,
      );
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    printColor(
      '[Bloc] event: ${transition.event.runtimeType} | currentState: ${transition.currentState.runtimeType} | nextState: ${transition.nextState.runtimeType}',
      color: PrintColors.magenta,
    );
  }
}

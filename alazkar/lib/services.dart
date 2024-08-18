import 'package:alazkar/src/core/extension/extension_platform.dart';
import 'package:alazkar/src/core/utils/app_bloc_observer.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/features/settings/data/repository/settings_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

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

  if (PlatformExtension.isDesktopOrWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await GetStorage.init();

  if (PlatformExtension.isDesktop) {
    await windowManager.ensureInitialized();
    appPrint(SettingsStorage.desktopWindowSize);
    final WindowOptions windowOptions = WindowOptions(
      size: SettingsStorage.desktopWindowSize,
      center: true,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setTitleBarStyle(
        TitleBarStyle.hidden,
        windowButtonVisibility: false,
      );
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // if(kDebugMode) await viewStatistics();
}

import 'package:alazkar/src/core/di/dependency_injection.dart';
import 'package:alazkar/src/core/extension/extension_platform.dart';
import 'package:alazkar/src/core/utils/scroll_behavior.dart';
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:alazkar/src/features/home/presentation/screens/home_page_screen.dart';
import 'package:alazkar/src/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:alazkar/src/features/settings/presentation/controller/cubit/settings_cubit.dart';
import 'package:alazkar/src/features/theme/presentation/controller/cubit/theme_cubit.dart';
import 'package:alazkar/src/features/ui/presentation/components/desktop_window_wrapper.dart';
import 'package:alazkar/src/features/zikr_source_filter/presentation/controller/cubit/zikr_source_filter_cubit.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<SettingsCubit>()),
        BlocProvider(create: (_) => sl<ThemeCubit>()),
        BlocProvider(create: (_) => sl<ZikrSourceFilterCubit>()..start()),
        BlocProvider(
          create: (context) => sl<HomeBloc>()..add(HomeStartEvent()),
        ),
        BlocProvider(create: (context) => sl<SearchCubit>()..start()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            scrollBehavior: AppScrollBehavior(),
            title: 'Al-Azkar',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: state.color,
                brightness: state.brightness,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: "Cairo",
              useMaterial3: state.useMaterial3,
            ),
            localizationsDelegates: const [
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale("ar", "EG"),
            ],
            builder: (context, child) {
              if (PlatformExtension.isDesktop) {
                final botToastBuilder = BotToastInit();
                return DesktopWindowWrapper(
                  child: botToastBuilder(context, child),
                );
              }
              return child ?? const SizedBox();
            },
            home: const HomePageScreen(),
          );
        },
      ),
    );
  }
}

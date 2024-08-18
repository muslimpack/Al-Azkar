import 'package:alazkar/src/core/extension/extension_platform.dart';
import 'package:alazkar/src/features/theme/presentation/controller/cubit/theme_cubit.dart';
import 'package:alazkar/src/features/ui/presentation/components/windows_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

class UIAppBar extends StatefulWidget {
  final BuildContext? shellContext;

  const UIAppBar({super.key, this.shellContext});

  @override
  State<UIAppBar> createState() => _UIAppBarState();
}

class _UIAppBarState extends State<UIAppBar> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (kIsWeb)
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text("الأذكار النووية"),
              ),
            if (PlatformExtension.isDesktop)
              const Expanded(
                child: DragToMoveArea(
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text("الأذكار النووية"),
                  ),
                ),
              ),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                return Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8.0),
                    child: ChoiceChip(
                      selected: state.brightness == Brightness.dark,
                      showCheckmark: false,
                      label: const Icon(Icons.dark_mode_rounded),
                      onSelected: (v) {
                        context.read<ThemeCubit>().changeBrightness(
                              v ? Brightness.dark : Brightness.light,
                            );
                      },
                    ),
                  ),
                );
              },
            ),
            if (!kIsWeb) const WindowButtons(),
          ],
        ),
      ),
    );
  }
}

import 'package:alazkar/src/features/theme/presentation/controller/cubit/theme_cubit.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/controller/bloc/zikr_content_viewer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class ZikrContentViewerBottomAppBar extends StatelessWidget {
  final ZikrContentViewerLoadedState state;
  const ZikrContentViewerBottomAppBar({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: "الباب السابق",
            onPressed: () {
              context
                  .read<ZikrContentViewerBloc>()
                  .add(ZikrContentViewerPerviousTitleEvent());
            },
            icon: const Icon(Icons.keyboard_double_arrow_right_sharp),
          ),
          const Spacer(),
          IconButton(
            tooltip: "إعادة ضبط الخط",
            icon: const Icon(Symbols.refresh),
            onPressed: () async {
              await context.read<ThemeCubit>().restoreFontSize();
            },
          ),
          IconButton(
            tooltip: "تكبير حجم الخط",
            icon: const Icon(Symbols.text_increase),
            onPressed: () async {
              await context.read<ThemeCubit>().increaseFontSize();
            },
          ),
          IconButton(
            tooltip: "تصغير حجم الخط",
            icon: const Icon(Symbols.text_decrease),
            onPressed: () async {
              await context.read<ThemeCubit>().decreaseFontSize();
            },
          ),
          const Spacer(),
          IconButton(
            tooltip: "الباب التالي",
            onPressed: () {
              context
                  .read<ZikrContentViewerBloc>()
                  .add(ZikrContentViewerNextTitleEvent());
            },
            icon: const Icon(Icons.keyboard_double_arrow_left_sharp),
          ),
        ],
      ),
    );
  }
}

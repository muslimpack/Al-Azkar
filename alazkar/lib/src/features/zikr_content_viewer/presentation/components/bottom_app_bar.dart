import 'package:alazkar/src/features/zikr_content_viewer/presentation/controller/bloc/zikr_content_viewer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
            onPressed: () async {
              context
                  .read<ZikrContentViewerBloc>()
                  .add(ZikrContentViewerPerviousTitleEvent());
            },
            icon: const Icon(Icons.keyboard_double_arrow_right_sharp),
          ),
          const Spacer(),
          if (state.activeZikr != null)
            IconButton(
              tooltip: "نسخ الذكر",
              onPressed: () async {
                context
                    .read<ZikrContentViewerBloc>()
                    .add(ZikrContentViewerCopyEvent());
              },
              icon: const Icon(Icons.copy),
            ),
          IconButton(
            tooltip: "إعادة ضبط الخط",
            icon: Icon(MdiIcons.reload),
            onPressed: () {},
          ),
          IconButton(
            tooltip: "تكبير حجم الخط",
            icon: Icon(MdiIcons.formatFontSizeIncrease),
            onPressed: () {},
          ),
          IconButton(
            tooltip: "تصغير حجم الخط",
            icon: Icon(MdiIcons.formatFontSizeDecrease),
            onPressed: () {},
          ),
          const Spacer(),
          IconButton(
            tooltip: "الباب التالي",
            onPressed: () async {
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

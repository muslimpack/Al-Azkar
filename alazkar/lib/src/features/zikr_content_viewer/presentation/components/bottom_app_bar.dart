import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/features/share_as_image/presentation/screens/share_as_image_screen.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/controller/bloc/zikr_content_viewer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          if (state.activeZikr != null)
            IconButton(
              tooltip: "مشاركة الذكر",
              onPressed: () async {
                context
                    .read<ZikrContentViewerBloc>()
                    .add(ZikrContentViewerShareEvent());
              },
              icon: const Icon(Icons.share),
            ),
          if (state.activeZikr != null)
            IconButton(
              tooltip: "مشاركة الذكر كصورة",
              onPressed: () async {
                azkarDBHelper.getContentById(state.activeZikr!.id).then((zikr) {
                  Navigator.push(
                    context,
                    ShareAsImageScreen.route(
                      zikr: zikr,
                      zikrTitle: state.zikrTitle,
                    ),
                  );
                });
              },
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          if (state.activeZikr?.fadl.isNotEmpty ?? false)
            IconButton(
              tooltip: "فضل الذكر",
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("فضل الذكر"),
                      content: Text(state.activeZikr!.fadl),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.contact_support_outlined,
              ),
            ),
          if (state.azkar.isNotEmpty && state.activeZikr!.source.isNotEmpty)
            IconButton(
              tooltip: "مصدر الذكر",
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("مصدر الذكر"),
                      content: Text(state.activeZikr!.source),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.comment,
              ),
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

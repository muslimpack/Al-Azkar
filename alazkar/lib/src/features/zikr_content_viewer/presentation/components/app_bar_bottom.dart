import 'package:alazkar/src/features/zikr_content_viewer/presentation/controller/bloc/zikr_content_viewer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZikrContentViewerAppBarBottom extends StatelessWidget {
  final ZikrContentViewerLoadedState state;
  const ZikrContentViewerAppBarBottom({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (state.activeZikr != null)
          IconButton(
            tooltip: "مشاركة الذكر",
            onPressed: () {
              context
                  .read<ZikrContentViewerBloc>()
                  .add(ZikrContentViewerShareEvent());
            },
            icon: const Icon(Icons.share),
          ),
        if (state.activeZikr?.fadl.isNotEmpty ?? false)
          IconButton(
            tooltip: "فضل الذكر",
            onPressed: () async {
              await showDialog(
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
              Icons.emoji_events_rounded,
            ),
          ),
        if (state.azkar.isNotEmpty && state.activeZikr!.source.isNotEmpty)
          IconButton(
            tooltip: "مصدر الذكر وحكمه",
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // title: const Text("مصدر الذكر وحكمه"),
                    content: Text(
                      "المصدر:\n${state.activeZikr!.source}\n\nالحكم: ${state.activeZikr!.hokm}",
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.comment,
            ),
          ),
        if (state.azkar.isNotEmpty)
          Text(
            "${state.azkar.length} :: ${state.activeZikrIndex + 1}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}

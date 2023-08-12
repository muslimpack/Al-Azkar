import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/widgets/loading.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/components/zikr_item_card.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/controller/bloc/zikr_content_viewer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZikrContentViewerScreen extends StatelessWidget {
  final ZikrTitle zikrTitle;
  const ZikrContentViewerScreen({
    super.key,
    required this.zikrTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ZikrContentViewerBloc, ZikrContentViewerState>(
      bloc: context.read<ZikrContentViewerBloc>(),
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is! ZikrContentViewerLoadedState) {
          return const Loading();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              zikrTitle.name,
              style: const TextStyle(
                fontFamily: "Kitab",
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: PageView.builder(
            itemCount: state.azkar.length,
            itemBuilder: (context, index) {
              final zikr = state.azkar[index];
              return ZikrItemCard(zikr: zikr);
            },
          ),
        );
      },
    );
  }
}

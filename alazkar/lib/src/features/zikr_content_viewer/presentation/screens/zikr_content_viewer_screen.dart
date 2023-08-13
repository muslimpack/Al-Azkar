// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/widgets/loading.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/components/bottom_app_bar.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/components/zikr_item_card.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/controller/bloc/zikr_content_viewer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ZikrContentViewerScreen extends StatelessWidget {
  static const String routeName = "ZikrContentViewer";

  final ZikrTitle zikrTitle;
  const ZikrContentViewerScreen({
    super.key,
    required this.zikrTitle,
  });

  static Route route({required ZikrTitle zikrTitle}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => ZikrContentViewerBloc(zikrTitle),
        child: ZikrContentViewerScreen(
          zikrTitle: zikrTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ZikrContentViewerBloc, ZikrContentViewerState>(
      bloc: context.read<ZikrContentViewerBloc>(),
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: LinearProgressIndicator(
                value: state.progress(),
              ),
            ),
          ),
          body: PageView.builder(
            controller: context.read<ZikrContentViewerBloc>().pageController,
            itemCount: state.azkar.length,
            itemBuilder: (context, index) {
              final zikr = state.azkar[index];
              return ZikrItemCard(zikr: zikr);
            },
          ),
          bottomNavigationBar: ZikrContentViewerBottomAppBar(
            state: state,
          ),
        );
      },
    );
  }
}

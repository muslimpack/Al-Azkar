import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/widgets/loading.dart';
import 'package:alazkar/src/features/share_as_image/presentation/screens/share_as_image_screen.dart';
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
          ),
          body: PageView.builder(
            controller: context.read<ZikrContentViewerBloc>().pageController,
            itemCount: state.azkar.length,
            itemBuilder: (context, index) {
              final zikr = state.azkar[index];
              return ZikrItemCard(zikr: zikr);
            },
          ),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    context
                        .read<ZikrContentViewerBloc>()
                        .add(ZikrContentViewerCopyEvent());
                  },
                  icon: const Icon(Icons.copy),
                ),
                IconButton(
                  onPressed: () async {
                    context
                        .read<ZikrContentViewerBloc>()
                        .add(ZikrContentViewerShareEvent());
                  },
                  icon: const Icon(Icons.share),
                ),
                IconButton(
                  onPressed: () async {
                    azkarDBHelper
                        .getContentById(state.activeZikr.id)
                        .then((zikr) {
                      Navigator.push(
                        context,
                        ShareAsImageScreen.route(zikr: zikr),
                      );
                    });
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

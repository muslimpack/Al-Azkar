import 'package:alazkar/src/core/di/dependency_injection.dart';
import 'package:alazkar/src/core/widgets/loading.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/components/app_bar_bottom.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/components/bottom_app_bar.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/components/zikr_item_card.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/controller/bloc/zikr_content_viewer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';

class ZikrContentViewerScreen extends StatelessWidget {
  static const String routeName = "ZikrContentViewer";

  final int zikrTitleId;
  final int? zikrOrder;
  const ZikrContentViewerScreen({
    super.key,
    required this.zikrTitleId,
    this.zikrOrder,
  });

  static Route route({required int zikrTitleId, int? zikrOrder}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ZikrContentViewerScreen(
        zikrTitleId: zikrTitleId,
        zikrOrder: zikrOrder,
      ),
    );
  }

  double getTextWidth(String text, TextStyle style, BuildContext context) {
    final textSpan = TextSpan(text: text, style: style);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1, // Set to 1 for single line text
    );
    textPainter.layout(
      maxWidth: MediaQuery.of(context)
          .size
          .width, // You can adjust this width as needed
    );
    return textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ZikrContentViewerBloc>()
        ..add(ZikrContentViewerStartEvent(zikrTitleId, zikrOrder: zikrOrder)),
      child: BlocBuilder<ZikrContentViewerBloc, ZikrContentViewerState>(
        builder: (context, state) {
          if (state is! ZikrContentViewerLoadedState) {
            return const Loading();
          }
          const headerStyle = TextStyle(
            fontFamily: "Kitab",
            fontWeight: FontWeight.bold,
          );
          final Size screenSize = MediaQuery.of(context).size;
          final bool isSliding =
              getTextWidth(state.zikrTitle.name, headerStyle, context) >
                  (screenSize.width * .5);
          return Scaffold(
            appBar: AppBar(
              title: isSliding
                  ? SizedBox(
                      height: 60,
                      child: Marquee(
                        text: state.zikrTitle.name,
                        blankSpace: screenSize.width,
                        pauseAfterRound: const Duration(seconds: 1),
                        accelerationCurve: Curves.easeInOut,
                        decelerationCurve: Curves.easeOut,
                        fadingEdgeEndFraction: 1,
                        fadingEdgeStartFraction: .5,
                        showFadingOnlyWhenScrolling: false,
                        style: headerStyle,
                      ),
                    )
                  : Text(
                      state.zikrTitle.name,
                      style: headerStyle,
                    ),
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Column(
                  children: [
                    ZikrContentViewerAppBarBottom(state: state),
                    LinearProgressIndicator(
                      value: state.progress(),
                    ),
                  ],
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
      ),
    );
  }
}

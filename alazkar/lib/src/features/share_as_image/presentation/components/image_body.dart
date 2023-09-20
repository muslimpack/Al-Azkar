// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/features/share_as_image/presentation/components/image_builder.dart';
import 'package:alazkar/src/features/share_as_image/presentation/controller/share_as_image/share_as_image_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareAsImageBody extends StatelessWidget {
  final ShareAsImageLoadedState state;
  const ShareAsImageBody({
    super.key,
    required this.interactiveViewerKey,
    required this.imageKey,
    required this.state,
    required this.repaintKey,
  });

  final GlobalKey<State<StatefulWidget>> interactiveViewerKey;
  final GlobalKey<State<StatefulWidget>> imageKey;
  final GlobalKey<State<StatefulWidget>> repaintKey;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        final Size screenSize = (interactiveViewerKey.currentContext
                ?.findRenderObject() as RenderBox?)!
            .size;
        final Size imageSize =
            (imageKey.currentContext?.findRenderObject() as RenderBox?)!.size;
        context.read<ShareAsImageBloc>().add(
              ShareAsImageDoubleTapEvent(
                screenSize: screenSize,
                imageSize: imageSize,
              ),
            );
      },
      child: Stack(
        children: [
          InteractiveViewer(
            key: interactiveViewerKey,
            constrained: false,
            transformationController: state.transformationController,
            minScale: 0.25,
            maxScale: 4,
            boundaryMargin: const EdgeInsets.all(5000),
            child: FutureBuilder(
              future: state.generateImageBodyContent(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                }
                return RepaintBoundary(
                  key: repaintKey,
                  child: ImageBuilder(
                    key: imageKey,
                    width: state.width,
                    content: (snapshot.data)!,
                    backgroundColor: state.backgroundColor,
                    textColor: state.textColor,
                    fontSize: state.fontSize,
                    showAppInfo: state.showAppInfo,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

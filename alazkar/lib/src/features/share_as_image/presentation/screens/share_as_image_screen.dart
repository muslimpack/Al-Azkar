import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/widgets/loading.dart';
import 'package:alazkar/src/features/share_as_image/presentation/components/image_builder.dart';
import 'package:alazkar/src/features/share_as_image/presentation/components/share_as_image_bottom_bar.dart';
import 'package:alazkar/src/features/share_as_image/presentation/controller/share_as_image/share_as_image_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareAsImageScreen extends StatefulWidget {
  static const String routeName = "/ShareAsImage";

  static Route route({required Zikr zikr}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => ShareAsImageBloc(),
        child: ShareAsImageScreen(
          zikr: zikr,
        ),
      ),
    );
  }

  final Zikr zikr;
  const ShareAsImageScreen({super.key, required this.zikr});

  @override
  State<ShareAsImageScreen> createState() => _ShareAsImageScreenState();
}

class _ShareAsImageScreenState extends State<ShareAsImageScreen> {
  final DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();
  final GlobalKey imageKey = GlobalKey();
  final GlobalKey repaintKey = GlobalKey();
  final GlobalKey interactiveViewerKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    context.read<ShareAsImageBloc>().add(
          ShareAsImageStartEvent(
            zikr: widget.zikr,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShareAsImageBloc, ShareAsImageState>(
      builder: (context, state) {
        if (state is ShareAsImageLoadingState) {
          return const Loading();
        }
        if (state is ShareAsImageLoadedState) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: ShareAsImageAppBar(
                state: state,
                repaintKey: repaintKey,
              ),
            ),
            body: ShareAsImageBody(
              state: state,
              interactiveViewerKey: interactiveViewerKey,
              imageKey: imageKey,
              repaintKey: repaintKey,
            ),
            bottomSheet: const ShareAsImageBottomBar(),
          );
        }

        return const SizedBox();
      },
    );
  }
}

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
                  return const Loading();
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

class ShareAsImageAppBar extends StatelessWidget {
  final ShareAsImageLoadedState state;
  const ShareAsImageAppBar({
    super.key,
    required this.repaintKey,
    required this.state,
  });

  final GlobalKey<State<StatefulWidget>> repaintKey;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text(
        "مشاركة كصورة",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: "Uthmanic",
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () async {
            context.read<ShareAsImageBloc>().add(
                  ShareAsImageShareEvent(
                    key: repaintKey,
                  ),
                );
          },
          icon: const Icon(Icons.share),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(!state.isLoading ? 0 : 20),
        child: !state.isLoading
            ? const SizedBox()
            : LinearProgressIndicator(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                color: Colors.brown,
                minHeight: 15,
              ),
      ),
    );
  }
}

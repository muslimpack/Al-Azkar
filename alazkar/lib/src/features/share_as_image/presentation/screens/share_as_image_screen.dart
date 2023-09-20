// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/widgets/loading.dart';
import 'package:alazkar/src/features/share_as_image/presentation/components/app_bar.dart';
import 'package:alazkar/src/features/share_as_image/presentation/components/image_body.dart';
import 'package:alazkar/src/features/share_as_image/presentation/components/share_as_image_bottom_bar.dart';
import 'package:alazkar/src/features/share_as_image/presentation/controller/share_as_image/share_as_image_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareAsImageScreen extends StatefulWidget {
  static const String routeName = "/ShareAsImage";

  static Route route({required Zikr zikr, required ZikrTitle zikrTitle}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => ShareAsImageBloc(),
        child: ShareAsImageScreen(
          zikr: zikr,
          zikrTitle: zikrTitle,
        ),
      ),
    );
  }

  final Zikr zikr;
  final ZikrTitle zikrTitle;
  const ShareAsImageScreen({
    super.key,
    required this.zikr,
    required this.zikrTitle,
  });

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
            zikrTitle: widget.zikrTitle,
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

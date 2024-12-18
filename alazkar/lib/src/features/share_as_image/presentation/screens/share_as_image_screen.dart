// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/di/dependency_injection.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/features/share_as_image/presentation/components/shareable_image_card.dart';
import 'package:alazkar/src/features/share_as_image/presentation/controller/cubit/share_image_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShareAsImageScreen extends StatelessWidget {
  static const String routeName = "/ShareAsImage";

  static Route route({required Zikr zikr, required ZikrTitle zikrTitle}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ShareAsImageScreen(
        zikr: zikr,
        zikrTitle: zikrTitle,
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ShareImageCubit>()..start(zikr: zikr, zikrTitle: zikrTitle),
      child: BlocBuilder<ShareImageCubit, ShareImageState>(
        builder: (context, state) {
          if (state is! ShareImageLoadedState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            appBar: AppBar(
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
                    await context.read<ShareImageCubit>().shareImage(false);
                  },
                  icon: const Icon(Icons.share),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: state.showLoadingIndicator
                    ? const LinearProgressIndicator()
                    : const SizedBox.shrink(),
              ),
            ),
            body: PageView.builder(
              controller: context.read<ShareImageCubit>().pageController,
              itemCount: state.splittedMatn.length,
              onPageChanged: context.read<ShareImageCubit>().onPageChanged,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    FittedBox(
                      child: RepaintBoundary(
                        key: context.read<ShareImageCubit>().imageKeys[index],
                        child: ShareableImageCard(
                          zikr: state.zikr,
                          zikrTitle: state.zikrTitle,
                          settings: state.settings,
                          matnRange: state.splittedMatn[index],
                          splittedLength: state.splittedMatn.length,
                          splittedindex: index,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            bottomNavigationBar: state.splittedMatn.length < 2
                ? null
                : BottomAppBar(
                    height: kToolbarHeight,
                    child: Text(
                      "${state.splittedMatn.length} : ${state.activeIndex + 1}",
                      textAlign: TextAlign.center,
                    ),
                  ),
          );
        },
      ),
    );
  }
}

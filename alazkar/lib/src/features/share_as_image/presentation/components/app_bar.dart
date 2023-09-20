// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/features/share_as_image/presentation/controller/share_as_image/share_as_image_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

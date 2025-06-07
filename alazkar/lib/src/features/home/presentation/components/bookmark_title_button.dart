// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkTitleButton extends StatelessWidget {
  final int titleId;
  const BookmarkTitleButton({
    super.key,
    required this.titleId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.read<HomeBloc>(),
      builder: (context, state) {
        if (state is! HomeLoadedState) {
          return const SizedBox();
        }
        final isBookmarked = state.favouriteTitlesIds.contains(titleId);

        if (isBookmarked) {
          return IconButton(
            onPressed: () {
              context.read<HomeBloc>().add(HomeUnBookmarkTitleEvent(titleId));
            },
            icon: Icon(
              Icons.bookmark,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        } else {
          return IconButton(
            onPressed: () {
              context.read<HomeBloc>().add(HomeBookmarkTitleEvent(titleId));
            },
            icon: const Icon(
              Icons.bookmark_add_outlined,
            ),
          );
        }
      },
    );
  }
}

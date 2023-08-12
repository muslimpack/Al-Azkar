// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/controller/bloc/zikr_content_viewer_bloc.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/screens/zikr_content_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FehrsItemCard extends StatelessWidget {
  final ZikrTitle zikrTitle;
  const FehrsItemCard({
    super.key,
    required this.zikrTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 25),
                child: Text(zikrTitle.order.toString()),
              ),
            ),
          ),
          if (zikrTitle.isBookmarked!)
            IconButton(
              onPressed: () {
                context
                    .read<HomeBloc>()
                    .add(HomeUnBookmarkTitleEvent(zikrTitle));
              },
              icon: const Icon(
                Icons.bookmark,
              ),
            )
          else
            IconButton(
              onPressed: () {
                context.read<HomeBloc>().add(HomeBookmarkTitleEvent(zikrTitle));
              },
              icon: const Icon(
                Icons.bookmark_add_outlined,
              ),
            ),
        ],
      ),
      title: Text(zikrTitle.name),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return BlocProvider(
                create: (context) => ZikrContentViewerBloc(zikrTitle),
                child: ZikrContentViewerScreen(zikrTitle: zikrTitle),
              );
            },
          ),
        );
      },
    );
  }
}

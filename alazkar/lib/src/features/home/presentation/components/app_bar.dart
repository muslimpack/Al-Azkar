import 'package:flutter/material.dart';

import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';

class HomeAppBar extends StatelessWidget {
  final HomeLoadedState state;
  const HomeAppBar({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      bottom: !state.showTabs
          ? const PreferredSize(
              preferredSize: Size.zero,
              child: SizedBox(),
            )
          : const TabBar(
              tabs: [
                Tab(child: Text("فهرس")),
                Tab(child: Text("المفضلة")),
              ],
            ),
      actions: const [
        Icon(
          Icons.settings,
        )
      ],
    );
  }
}

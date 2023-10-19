import 'package:alazkar/src/features/about/presentation/screens/about_screen.dart';
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  final TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset(
          "assets/icons/app.png",
        ),
      ),
      actions: [
        IconButton(
          splashRadius: 20,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.search),
          onPressed: () {
            context.read<HomeBloc>().add(const HomeToggleSearchEvent(true));
          },
        ),
        IconButton(
          splashRadius: 20,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const AboutScreen();
                },
              ),
            );
          },
        ),
      ],
      bottom: const TabBar(
        tabs: [
          Tab(child: Text("فهرس")),
          Tab(child: Text("المفضلة")),
        ],
      ),
    );
  }
}

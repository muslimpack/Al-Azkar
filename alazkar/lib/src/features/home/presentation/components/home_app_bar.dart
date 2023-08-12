import 'package:flutter/material.dart';

import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeAppBar extends StatefulWidget {
  final HomeLoadedState state;
  const HomeAppBar({
    Key? key,
    required this.state,
  }) : super(key: key);

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
      leading: widget.state.isSearching
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // state.isSearching = false;
                context.read<HomeBloc>().add(HomeEndSearchEvent());
              },
            )
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                "assets/icons/app.png",
              ),
            ),
      title: widget.state.isSearching
          ? TextFormField(
              controller: searchTextController,
              // initialValue: widget.state.searchedText,
              autofocus: true,
              style: const TextStyle(
                fontSize: 18,
                fontFamily: "Kitab",
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: "البحث في الأذكار",
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: "Kitab",
                ),
                contentPadding:
                    EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 15),
              ),
              onChanged: (text) async {
                context.read<HomeBloc>().add(HomeSearchEvent(text));
              },
            )
          : const SizedBox(),
      actions: [
        if (widget.state.isSearching)
          IconButton(
            splashRadius: 20,
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.exit_to_app_sharp),
            onPressed: () {
              searchTextController.clear();

              context.read<HomeBloc>().add(const HomeSearchEvent(""));
            },
          )
        else
          IconButton(
            splashRadius: 20,
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.search),
            onPressed: () {
              context.read<HomeBloc>().add(
                    const HomeSearchEvent(""),
                  );
            },
          ),
      ],
      bottom: !widget.state.showTabs
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
    );
  }
}

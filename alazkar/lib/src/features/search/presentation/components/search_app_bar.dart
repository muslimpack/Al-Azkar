import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:alazkar/src/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({super.key});

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  final TextEditingController searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      snap: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.read<HomeBloc>().add(const HomeToggleSearchEvent(false));
        },
      ),
      title: TextFormField(
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
          contentPadding: EdgeInsets.only(
            left: 15,
            bottom: 5,
            top: 5,
            right: 15,
          ),
        ),
        onChanged: (text) async {
          // context.read<HomeBloc>().add(HomeSearchEvent(text));
          context.read<SearchCubit>().search(text);
        },
      ),
      actions: [
        IconButton(
          splashRadius: 20,
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.exit_to_app_sharp),
          onPressed: () {
            searchTextController.clear();

            // context.read<HomeBloc>().add(const HomeSearchEvent(""));

            context.read<SearchCubit>().search("");
          },
        )
      ],
    );
  }
}

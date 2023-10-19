import 'package:alazkar/src/features/search/presentation/components/search_app_bar.dart';
import 'package:alazkar/src/features/search/presentation/components/search_card.dart';
import 'package:alazkar/src/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                const SearchAppBar(),
              ];
            },
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: state.result.entries.map(
                (e) {
                  return SearchCard(
                    title: e.key,
                    zikr: e.value,
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}

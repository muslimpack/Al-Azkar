import 'package:alazkar/src/core/widgets/loading.dart';
import 'package:alazkar/src/features/home/presentation/components/fehrs_screen.dart';
import 'package:alazkar/src/features/home/presentation/components/home_app_bar.dart';
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:alazkar/src/features/search/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: context.read<HomeBloc>(),
      builder: (context, state) {
        if (state is! HomeLoadedState) {
          return const Loading();
        }
        return state.isSearching
            ? SearchScreen()
            : DefaultTabController(
                length: 2,
                child: Scaffold(
                  body: NestedScrollView(
                    floatHeaderSlivers: true,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        HomeAppBar(state: state),
                      ];
                    },
                    body: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        FehrsScreen(titles: state.titlesToShow),
                        FehrsScreen(
                          titles: state.favouriteTitles(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

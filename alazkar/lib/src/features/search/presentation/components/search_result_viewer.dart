// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/features/search/presentation/components/no_items_found_indicator_builder.dart';
import 'package:alazkar/src/features/search/presentation/components/no_more_items_indicator_builder.dart';
import 'package:alazkar/src/features/search/presentation/controller/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SearchResultViewer<T> extends StatelessWidget {
  final PagingController<int, T> pagingController;
  final Widget Function(BuildContext, T, int) itemBuilder;
  const SearchResultViewer({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state is! SearchLoadedState) return const SizedBox.shrink();

        return PagingListener(
          controller: pagingController,
          builder: (context, pagingState, fetchNextPage) =>
              PagedListView<int, T>(
            state: pagingState,
            fetchNextPage: () => pagingController.fetchNextPage(),
            padding: const EdgeInsets.all(15),
            builderDelegate: PagedChildBuilderDelegate<T>(
              animateTransitions: true,
              transitionDuration: const Duration(milliseconds: 500),
              itemBuilder: (context, item, index) => itemBuilder(
                context,
                item,
                index,
              ),
              // newPageProgressIndicatorBuilder: (context) => const Loading(),
              noMoreItemsIndicatorBuilder: (context) =>
                  const NoMoreItemsIndicatorBuilder(),
              noItemsFoundIndicatorBuilder: (context) =>
                  NoItemsFoundIndicatorBuilder(
                searchText: state.searchText,
              ),
            ),
          ),
        );
      },
    );
  }
}

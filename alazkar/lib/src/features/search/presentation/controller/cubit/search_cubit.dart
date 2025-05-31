import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/helpers/bookmarks_helper.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:alazkar/src/features/search/data/models/search_for.dart';
import 'package:alazkar/src/features/search/data/models/search_type.dart';
import 'package:alazkar/src/features/search/domain/repository/search_repo.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/repository/zikr_filter_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final TextEditingController searchController = TextEditingController();
  late final PagingController<int, ZikrTitle> titlePagingController;
  late final PagingController<int, Zikr> contentPagingController;

  ///
  final HomeBloc homeBloc;
  final ZikrFilterStorage zikrFilterStorage;
  final AzkarDBHelper azkarDBHelper;
  final BookmarksDBHelper bookmarksDBHelper;
  final SearchRepo searchRepo;
  SearchCubit(
    this.homeBloc,
    this.zikrFilterStorage,
    this.azkarDBHelper,
    this.bookmarksDBHelper,
    this.searchRepo,
  ) : super(const SearchLoadingState()) {
    homeBloc.stream.listen((event) {
      final homeBlocState = homeBloc.state;
      if (homeBlocState is! HomeLoadedState) return;
      final state = this.state;
      if (state is! SearchLoadedState) return;
    });
  }

  Future start() async {
    final state = SearchLoadedState(
      searchText: "",
      searchType: searchRepo.searchType,
      searchFor: searchRepo.searchFor,
    );

    titlePagingController = PagingController(
      getNextPageKey: (pageKey) => 0,
      fetchPage: (pageKey) => searchTitleByName(
        searchText: state.searchText,
        searchType: state.searchType,
        offset: pageKey,
      ),
    );

    contentPagingController = PagingController(
      getNextPageKey: (pageKey) => 0,
      fetchPage: (pageKey) => azkarDBHelper.searchContent(
        searchText: state.searchText,
        searchType: state.searchType,
        limit: state.pageSize,
        offset: pageKey,
      ),
    );

    emit(state);
  }

  Future<List<ZikrTitle>> searchTitleByName({
    required String searchText,
    required SearchType searchType,
    required int offset,
  }) async {
    final state = this.state;
    if (state is! SearchLoadedState) return [];

    final titles = await azkarDBHelper.searchTitleByName(
      searchText: state.searchText,
      searchType: state.searchType,
      limit: state.pageSize,
      offset: offset,
    );

    final List<int> favouriteTitlesIds =
        await bookmarksDBHelper.getAllFavoriteTitles();
    final allTitlesWithFavorite = titles
        .map(
          (e) => e.copyWith(
            isBookmarked: favouriteTitlesIds.contains(e.id),
          ),
        )
        .toList();

    return allTitlesWithFavorite;
  }

  ///MARK: Search header
  Future _startNewSearch() async {
    final state = this.state;
    if (state is! SearchLoadedState) return;

    switch (state.searchFor) {
      case SearchFor.title:
        titlePagingController.refresh();

      case SearchFor.content:
        contentPagingController.refresh();
    }
  }

  ///MARK: Search text

  Future updateSearchText(String searchText) async {
    final state = this.state;
    if (state is! SearchLoadedState) return;

    emit(
      state.copyWith(
        searchText: searchText,
      ),
    );

    await _startNewSearch();
  }

  ///MARK: SearchType
  Future changeSearchType(SearchType searchType) async {
    final state = this.state;
    if (state is! SearchLoadedState) return;

    await searchRepo.setSearchType(searchType);

    emit(state.copyWith(searchType: searchType));
    await _startNewSearch();
  }

  ///MARK: Search For
  Future changeSearchFor(SearchFor searchFor) async {
    final state = this.state;
    if (state is! SearchLoadedState) return;

    await searchRepo.setSearchFor(searchFor);

    emit(state.copyWith(searchFor: searchFor));
    await _startNewSearch();
  }

  ///MARK: clear
  Future clear() async {
    searchController.clear();
    await updateSearchText("");
  }

  @override
  Future<void> close() {
    titlePagingController.dispose();
    contentPagingController.dispose();
    searchController.dispose();
    return super.close();
  }
}

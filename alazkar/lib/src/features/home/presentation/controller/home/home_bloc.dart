import 'dart:async';

import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/helpers/bookmarks_helper.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoadingState()) {
    on<HomeStartEvent>(_start);

    on<HomeToggleSearchEvent>(_search);

    on<HomeBookmarkTitleEvent>(_bookmarkTitle);
    on<HomeUnBookmarkTitleEvent>(_unBookmarkTitle);
    on<HomeBookmarksChangedEvent>(_bookmarksChanged);

    add(HomeStartEvent());
  }

  FutureOr<void> _start(
    HomeStartEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    final List<ZikrTitle> titles = await azkarDBHelper.getAllTitles();
    final List<int> favouriteTitlesIds =
        await bookmarksDBHelper.getAllFavoriteTitles();

    final titlesToSet = titles
        .map(
          (e) => e.copyWith(
            isBookmarked: favouriteTitlesIds.contains(e.id),
          ),
        )
        .toList();

    emit(
      HomeLoadedState(
        titles: titlesToSet,
        titlesToShow: titlesToSet,
        isSearching: false,
      ),
    );
  }

  FutureOr<void> _search(
    HomeToggleSearchEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    emit(
      state.copyWith(
        isSearching: event.isSearching,
      ),
    );
  }

  FutureOr<void> _bookmarkTitle(
    HomeBookmarkTitleEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    await bookmarksDBHelper.addTitleToFavourite(titleId: event.zikrTitle.id);

    add(HomeBookmarksChangedEvent());
  }

  FutureOr<void> _unBookmarkTitle(
    HomeUnBookmarkTitleEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    await bookmarksDBHelper.deleteTitleFromFavourite(
      titleId: event.zikrTitle.id,
    );

    add(HomeBookmarksChangedEvent());
  }

  FutureOr<void> _bookmarksChanged(
    HomeBookmarksChangedEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    final List<int> favouriteTitlesIds =
        await bookmarksDBHelper.getAllFavoriteTitles();

    final titlesToSet = state.titles
        .map(
          (e) => e.copyWith(
            isBookmarked: favouriteTitlesIds.contains(e.id),
          ),
        )
        .toList();

    final titlesToShow = state.titlesToShow
        .map(
          (e) => e.copyWith(
            isBookmarked: favouriteTitlesIds.contains(e.id),
          ),
        )
        .toList();

    emit(
      state.copyWith(
        titles: titlesToSet,
        titlesToShow: titlesToShow,
      ),
    );
  }
}

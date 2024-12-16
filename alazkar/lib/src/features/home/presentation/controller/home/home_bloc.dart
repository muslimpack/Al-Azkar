import 'dart:async';

import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/helpers/bookmarks_helper.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/features/home/data/models/titles_freq_enum.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_list_extension.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/repository/zikr_filter_storage.dart';
import 'package:alazkar/src/features/zikr_source_filter/presentation/controller/cubit/zikr_source_filter_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ZikrSourceFilterCubit zikrSourceFilterCubit;
  final ZikrFilterStorage zikrFilterStorage;
  late StreamSubscription zikrSourceFilterCubitStram;
  HomeBloc(this.zikrSourceFilterCubit, this.zikrFilterStorage)
      : super(HomeLoadingState()) {
    zikrSourceFilterCubitStram =
        zikrSourceFilterCubit.stream.listen(zikrSourceFilterCubitChanged);

    on<HomeStartEvent>(_start);

    on<HomeToggleSearchEvent>(_search);

    on<HomeBookmarkTitleEvent>(_bookmarkTitle);
    on<HomeUnBookmarkTitleEvent>(_unBookmarkTitle);
    on<HomeBookmarksChangedEvent>(_bookmarksChanged);
    on<HomeToggleFilterEvent>(_toggleFreqFilter);
    on<HomeFiltersChange>(_handleSettingsFiltersChanges);
  }

  FutureOr<void> _start(
    HomeStartEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());

    final List<ZikrTitle> titlesToSet;

    /// Get titles form db
    final List<ZikrTitle> dbTitles = (await azkarDBHelper.getAllTitles())
      ..sort(
        (a, b) => a.order.compareTo(b.order),
      );

    /// Wire bookmaked data
    final List<int> favouriteTitlesIds =
        await bookmarksDBHelper.getAllFavoriteTitles();

    final titlesWithBookmarkedData = dbTitles
        .map(
          (e) => e.copyWith(
            isBookmarked: favouriteTitlesIds.contains(e.id),
          ),
        )
        .toList();

    ///
    final freq = zikrFilterStorage.getTitlesFreqFilterStatus();

    /// Filters
    titlesToSet = await applyFiltersOnTitels(titlesWithBookmarkedData, freq);

    emit(
      HomeLoadedState(
        titles: titlesWithBookmarkedData,
        titlesToShow: titlesToSet,
        isSearching: false,
        freqFilters: freq,
      ),
    );
  }

  Future<List<ZikrTitle>> applyFiltersOnTitels(
    List<ZikrTitle> titlesWithBookmarkedData,
    List<TitlesFreqEnum> titleFreqList, {
    List<Filter>? zikrFilters,
  }) async {
    final List<ZikrTitle> titlesToSet;

    /// Handle Freq Filter
    final List<ZikrTitle> filterdFreqTitles;

    filterdFreqTitles = titlesWithBookmarkedData
        .where((x) => titleFreqList.validate(x.freq))
        .toList();

    /// Handle titles with no content after applying zikr filters
    final List<ZikrTitle> reducedTitles = List.of([]);
    final List<Filter> filters =
        zikrFilters ?? zikrFilterStorage.getAllFilters();
    for (var i = 0; i < filterdFreqTitles.length; i++) {
      final title = filterdFreqTitles[i];
      final azkarFromDB = await azkarDBHelper.getContentByTitleId(title.id);
      final azkarToSet = filters.getFilteredZikr(azkarFromDB);
      if (azkarToSet.isNotEmpty) reducedTitles.add(title);
    }

    // ignore: join_return_with_assignment
    titlesToSet = reducedTitles;

    return titlesToSet;
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

  FutureOr<void> _toggleFreqFilter(
    HomeToggleFilterEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    /// Handle freq change
    final List<TitlesFreqEnum> newFreq = List.of(state.freqFilters);
    if (newFreq.contains(event.filter)) {
      newFreq.remove(event.filter);
    } else {
      newFreq.add(event.filter);
    }

    /// Handle titles change
    final List<ZikrTitle> titleToView = await applyFiltersOnTitels(
      List.of(state.titles),
      newFreq,
    );

    await zikrFilterStorage.setTitlesFreqFilterStatus(newFreq);

    emit(
      state.copyWith(
        freqFilters: newFreq,
        titlesToShow: titleToView,
      ),
    );
  }

  @override
  Future<void> close() {
    zikrSourceFilterCubitStram.cancel();
    return super.close();
  }

  Future<void> zikrSourceFilterCubitChanged(
    ZikrSourceFilterState filterState,
  ) async {
    appPrint(
      "from homeBLoc filters chaanged ${filterState.filters.where((f) => f.isActivated).length}",
    );

    add(HomeFiltersChange(filterState.filters));
  }

  FutureOr<void> _handleSettingsFiltersChanges(
    HomeFiltersChange event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    final List<ZikrTitle> titleToView = await applyFiltersOnTitels(
      List.of(state.titles),
      state.freqFilters,
      zikrFilters: event.filters,
    );

    emit(
      state.copyWith(
        titlesToShow: titleToView,
      ),
    );
  }
}

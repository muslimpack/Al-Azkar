import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/helpers/bookmarks_helper.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/features/home/presentation/controller/home/home_bloc.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_list_extension.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/repository/zikr_filter_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final HomeBloc homeBloc;
  final ZikrFilterStorage zikrFilterStorage;
  SearchCubit(this.homeBloc, this.zikrFilterStorage)
      : super(
          const SearchState(
            searchText: "",
            result: {},
          ),
        ) {
    homeBloc.stream.listen((event) {
      final homeBlocState = homeBloc.state;
      if (homeBlocState is! HomeLoadedState) return;
      if (state.result.isEmpty) return;

      final result = state.result.map((key, value) {
        return MapEntry(
          homeBlocState.titles.firstWhere((e) => e.id == key.id),
          value,
        );
      });

      emit(state.copyWith(result: result));
    });
  }

  Future search(String searchText) async {
    if (searchText.isEmpty) {
      final Map<ZikrTitle, List<Zikr>> result = {};
      emit(
        SearchState(
          searchText: "",
          result: result,
        ),
      );

      return;
    }

    // Get Searching result from database
    final searchedTitles = await azkarDBHelper.getTitlesByName(searchText);
    final searchedZikr = await azkarDBHelper.getContentsByName(searchText);

    /// Get Filtered Zikr
    final List<Filter> filters = zikrFilterStorage.getAllFilters();
    final filteredZikr = filters.getFilteredZikr(searchedZikr);

    // Get Titles with favorites
    final allTitles = await azkarDBHelper.getAllTitles();
    final List<int> favouriteTitlesIds =
        await bookmarksDBHelper.getAllFavoriteTitles();
    final allTitlesWithFavorite = allTitles
        .map(
          (e) => e.copyWith(
            isBookmarked: favouriteTitlesIds.contains(e.id),
          ),
        )
        .toList();

    final Map<int, ZikrTitle> titleMap = {
      for (final title in allTitlesWithFavorite) title.id: title,
    };

    // Start to handle  Result
    final Map<ZikrTitle, List<Zikr>> result = {};

    /// Titles
    for (final title in searchedTitles) {
      result[titleMap[title.id]!] = [];
    }

    /// Zikr in each title
    for (final zikr in filteredZikr) {
      if (result[titleMap[zikr.titleId]!]?.isEmpty ?? true) {
        result[titleMap[zikr.titleId]!] = [];
      }
      result[titleMap[zikr.titleId]!]?.add(zikr);
    }

    /// Sort result
    final sortedEntries = result.entries.toList()
      ..sort((a, b) => a.key.order.compareTo(b.key.order));

    final sortedMap = Map.fromEntries(sortedEntries);

    emit(
      SearchState(
        searchText: searchText,
        result: sortedMap,
      ),
    );
  }
}

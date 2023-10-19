import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/helpers/bookmarks_helper.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit()
      : super(
          const SearchState(
            searchText: "",
            zikr: [],
            titles: [],
            result: {},
          ),
        );

  Future search(String searchText) async {
    if (searchText.isEmpty) {
      final Map<ZikrTitle, List<Zikr>> result = {};
      emit(
        SearchState(
          searchText: "",
          zikr: const [],
          titles: const [],
          result: result,
        ),
      );

      return;
    }

    // Get Searching result from database
    final searchedTitles = await azkarDBHelper.getTitlesByName(searchText);
    final searchedZikr = await azkarDBHelper.getContentsByName(searchText);

    final Map<ZikrTitle, List<Zikr>> result = {};

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

    final Map<int, List<Zikr>> resultWithId = {};

    for (final title in searchedTitles) {
      resultWithId[title.id] = [];
    }
    for (final zikr in searchedZikr) {
      resultWithId[zikr.titleId] = [];
      resultWithId[zikr.titleId]?.add(zikr);
    }

    final titlesToSet = allTitlesWithFavorite
        .where(
          (title) => resultWithId.containsKey(title.id),
        )
        .toList();

    final Map<int, ZikrTitle> titleMap = {
      for (final title in allTitlesWithFavorite) title.id: title
    };

    for (final entry in resultWithId.entries) {
      final title = titleMap[entry.key]!;
      result[title] = [];
      result[title]?.addAll(entry.value);
    }

    emit(
      SearchState(
        searchText: searchText,
        titles: titlesToSet,
        zikr: searchedZikr,
        result: result,
      ),
    );
  }
}

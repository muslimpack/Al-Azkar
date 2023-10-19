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

    // final List<int> favouriteTitlesIds =
    //     await bookmarksDBHelper.getAllFavoriteTitles();

    // final allTitles = await azkarDBHelper.getAllTitles();
    // final allTitlesWithFavorite = allTitles
    //     .map(
    //       (e) => e.copyWith(
    //         isBookmarked: favouriteTitlesIds.contains(e.id),
    //       ),
    //     )
    //     .toList();

    // final searchedTitles = await azkarDBHelper.getTitlesByName(searchText);
    // final searchedZikr = await azkarDBHelper.getContentsByName(searchText);

    // final Map<int, List<Zikr>> resultWithId = {};
    // searchedTitles.map((e) => resultWithId[e.id] = []);
    // searchedZikr.map((e) => resultWithId[e.id]?.add(e));

    // final titlesToSet =
    //     allTitlesWithFavorite.fold(<ZikrTitle>[], (list, title) {
    //   if (resultWithId.keys.contains(title.id)) {
    //     list.add(title);
    //   }
    //   return list;
    // });
    // titlesToSet.map((e) => result[e] = []);
    // resultWithId.entries.map(
    //   (e) => resultWithId[titlesToSet.indexWhere((t) => t.id == e.key)]
    //       ?.addAll(e.value),
    // );

    final Map<ZikrTitle, List<Zikr>> result = {};
    final List<int> favouriteTitlesIds =
        await bookmarksDBHelper.getAllFavoriteTitles();

    final allTitles = await azkarDBHelper.getAllTitles();
    final allTitlesWithFavorite = allTitles
        .map(
          (e) => e.copyWith(
            isBookmarked: favouriteTitlesIds.contains(e.id),
          ),
        )
        .toList();

    final searchedTitles = await azkarDBHelper.getTitlesByName(searchText);
    final searchedZikr = await azkarDBHelper.getContentsByName(searchText);

    final Map<int, List<Zikr>> resultWithId = {};

    for (final title in searchedTitles) {
      resultWithId[title.id] = [];
    }

    for (final zikr in searchedZikr) {
      resultWithId[zikr.id]?.add(zikr);
    }

    final titlesToSet = allTitlesWithFavorite
        .where(
          (title) => resultWithId.containsKey(title.id),
        )
        .toList();

    for (final entry in resultWithId.entries) {
      final title = titlesToSet.firstWhere((t) => t.id == entry.key);
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

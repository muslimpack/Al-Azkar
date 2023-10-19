import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/helpers/bookmarks_helper.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit()
      : super(const SearchState(searchText: "", zikr: [], titles: []));

  Future search(String searchText) async {
    final titles = await azkarDBHelper.getTitlesByName(searchText);
    final zikr = await azkarDBHelper.getContentsByName(searchText);

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
      SearchState(
        searchText: searchText,
        titles: titlesToSet,
        zikr: zikr,
      ),
    );
  }
}

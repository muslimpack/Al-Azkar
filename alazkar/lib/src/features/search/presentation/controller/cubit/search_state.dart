part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String searchText;
  final List<ZikrTitle> titles;
  final List<Zikr> zikr;
  final Map<ZikrTitle, List<Zikr>> result;
  const SearchState({
    required this.searchText,
    required this.titles,
    required this.zikr,
    required this.result,
  });

  @override
  List<Object> get props => [
        searchText,
        titles,
        zikr,
        result,
      ];
}

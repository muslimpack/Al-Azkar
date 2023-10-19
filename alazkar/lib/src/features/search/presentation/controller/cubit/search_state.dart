part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String searchText;
  final List<ZikrTitle> titles;
  final List<Zikr> zikr;
  const SearchState({
    required this.searchText,
    required this.titles,
    required this.zikr,
  });

  @override
  List<Object> get props => [
        searchText,
        titles,
        zikr,
      ];
}

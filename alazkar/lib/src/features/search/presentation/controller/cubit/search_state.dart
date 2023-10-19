part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String searchText;

  final Map<ZikrTitle, List<Zikr>> result;
  const SearchState({
    required this.searchText,
    required this.result,
  });

  @override
  List<Object> get props => [
        searchText,
        result,
      ];
}

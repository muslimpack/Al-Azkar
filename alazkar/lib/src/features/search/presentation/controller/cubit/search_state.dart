// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  SearchState copyWith({
    String? searchText,
    Map<ZikrTitle, List<Zikr>>? result,
  }) {
    return SearchState(
      searchText: searchText ?? this.searchText,
      result: result ?? this.result,
    );
  }
}

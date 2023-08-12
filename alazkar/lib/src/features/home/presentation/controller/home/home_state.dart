// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeLoadingState extends HomeState {}

final class HomeLoadedState extends HomeState {
  final List<ZikrTitle> titles;
  final List<ZikrTitle> titlesToShow;
  final bool isSearching;
  final bool showTabs;

  const HomeLoadedState({
    required this.titles,
    required this.titlesToShow,
    required this.isSearching,
    required this.showTabs,
  });

  List<ZikrTitle> favouriteTitles() {
    return titlesToShow.fold<List<ZikrTitle>>(
      <ZikrTitle>[],
      (previousValue, element) {
        if (element.isBookmarked!) {
          return previousValue..add(element);
        }
        return previousValue;
      },
    );
  }

  @override
  List<Object> get props => [
        titles,
        titlesToShow,
        isSearching,
        showTabs,
      ];

  HomeLoadedState copyWith({
    List<ZikrTitle>? titles,
    List<ZikrTitle>? titlesToShow,
    bool? isSearching,
    bool? showTabs,
  }) {
    return HomeLoadedState(
      titles: titles ?? this.titles,
      titlesToShow: titlesToShow ?? this.titlesToShow,
      isSearching: isSearching ?? this.isSearching,
      showTabs: showTabs ?? this.showTabs,
    );
  }
}

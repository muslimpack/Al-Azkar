part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStartEvent extends HomeEvent {}

class HomeToggleSearchEvent extends HomeEvent {
  final bool isSearching;

  const HomeToggleSearchEvent(this.isSearching);

  @override
  List<Object> get props => [isSearching];
}

class HomeBookmarkTitleEvent extends HomeEvent {
  final ZikrTitle zikrTitle;

  const HomeBookmarkTitleEvent(this.zikrTitle);

  @override
  List<Object> get props => [zikrTitle];
}

class HomeBookmarksChangedEvent extends HomeEvent {}

class HomeUnBookmarkTitleEvent extends HomeEvent {
  final ZikrTitle zikrTitle;

  const HomeUnBookmarkTitleEvent(this.zikrTitle);

  @override
  List<Object> get props => [zikrTitle];
}

class HomeToggleFilterEvent extends HomeEvent {
  final TitlesFreqEnum filter;

  const HomeToggleFilterEvent(this.filter);

  @override
  List<Object> get props => [filter];
}

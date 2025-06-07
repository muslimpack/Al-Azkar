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
  final int zikrTitleId;

  const HomeBookmarkTitleEvent(this.zikrTitleId);

  @override
  List<Object> get props => [zikrTitleId];
}

class HomeBookmarksChangedEvent extends HomeEvent {}

class HomeUnBookmarkTitleEvent extends HomeEvent {
  final int zikrTitleId;

  const HomeUnBookmarkTitleEvent(this.zikrTitleId);

  @override
  List<Object> get props => [zikrTitleId];
}

class HomeToggleFilterEvent extends HomeEvent {
  final TitlesFreqEnum filter;

  const HomeToggleFilterEvent(this.filter);

  @override
  List<Object> get props => [filter];
}

class HomeFiltersChange extends HomeEvent {
  final List<Filter> filters;

  const HomeFiltersChange(this.filters);

  @override
  List<Object> get props => [filters];
}

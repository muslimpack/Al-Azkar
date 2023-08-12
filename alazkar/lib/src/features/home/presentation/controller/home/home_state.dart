part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeLoadingState extends HomeState {}

final class HomeLoadedState extends HomeState {
  final List<ZikrTitle> titles;
  final bool isSearching;
  final bool showTabs;

  const HomeLoadedState({
    required this.titles,
    required this.isSearching,
    required this.showTabs,
  });

  @override
  List<Object> get props => [
        titles,
        isSearching,
        showTabs,
      ];
}

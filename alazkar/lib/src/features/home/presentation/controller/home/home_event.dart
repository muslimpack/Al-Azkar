part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStartEvent extends HomeEvent {}

class HomeEndSearchEvent extends HomeEvent {}

class HomeSearchEvent extends HomeEvent {
  final String search;

  const HomeSearchEvent(this.search);

  @override
  List<Object> get props => [search];
}

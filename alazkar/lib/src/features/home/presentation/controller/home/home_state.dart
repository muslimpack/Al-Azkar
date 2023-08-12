part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<ZikrTitle> titles;

  const HomeLoaded(this.titles);

  @override
  List<Object> get props => [titles];
}

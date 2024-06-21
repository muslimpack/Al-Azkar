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
  final List<TitlesFreqEnum> freq;
  final List<ZikrTitle> titlesToShow;
  final bool isSearching;

  const HomeLoadedState({
    required this.titles,
    required this.freq,
    required this.titlesToShow,
    required this.isSearching,
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
        freq,
      ];

  HomeLoadedState copyWith({
    List<ZikrTitle>? titles,
    List<TitlesFreqEnum>? freq,
    List<ZikrTitle>? titlesToShow,
    bool? isSearching,
  }) {
    return HomeLoadedState(
      titles: titles ?? this.titles,
      freq: freq ?? this.freq,
      titlesToShow: titlesToShow ?? this.titlesToShow,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

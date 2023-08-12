import 'dart:async';

import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoadingState()) {
    on<HomeStartEvent>(_start);
    on<HomeSearchEvent>(_search);
    on<HomeEndSearchEvent>(_endSearch);

    add(HomeStartEvent());
  }

  FutureOr<void> _start(
    HomeStartEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    final List<ZikrTitle> titles = await azkarDBHelper.getAllTitles();
    emit(
      HomeLoadedState(
        titles: titles,
        titlesToShow: titles,
        isSearching: false,
        showTabs: true,
      ),
    );
  }

  FutureOr<void> _search(
    HomeSearchEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    if (event.search.isEmpty) {
      emit(
        state.copyWith(
          titlesToShow: state.titles,
          isSearching: true,
          showTabs: true,
        ),
      );
      return;
    }

    final searchedTitles = state.titles
        .where(
          (t) => t.name.contains(event.search),
        )
        .toList();

    emit(
      state.copyWith(
        titlesToShow: searchedTitles,
        isSearching: true,
        showTabs: false,
      ),
    );
  }

  FutureOr<void> _endSearch(
    HomeEndSearchEvent event,
    Emitter<HomeState> emit,
  ) async {
    final state = this.state;
    if (state is! HomeLoadedState) return;

    emit(
      state.copyWith(
        titlesToShow: state.titles,
        isSearching: false,
        showTabs: true,
      ),
    );
  }
}

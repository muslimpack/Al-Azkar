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

    add(HomeStartEvent());
  }

  FutureOr<void> _start(HomeStartEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    List<ZikrTitle> titles = await azkarDBHelper.getAllTitles();
    emit(HomeLoadedState(
      titles: titles,
      isSearching: false,
      showTabs: true,
    ));
  }

  FutureOr<void> _search(HomeSearchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    List<ZikrTitle> titles = await azkarDBHelper.getTitlesByName(event.search);
    emit(HomeLoadedState(
      titles: titles,
      isSearching: true,
      showTabs: false,
    ));
  }
}

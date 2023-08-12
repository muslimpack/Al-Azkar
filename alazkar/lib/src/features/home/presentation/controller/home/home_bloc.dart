import 'dart:async';

import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<HomeStartEvent>(_start);
    on<HomeSearchEvent>(_search);
  }

  FutureOr<void> _start(HomeStartEvent event, Emitter<HomeState> emit) {}

  FutureOr<void> _search(HomeSearchEvent event, Emitter<HomeState> emit) {}
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(
          const ThemeState(
            brightness: Brightness.dark,
            color: Colors.brown,
          ),
        );

  void changeBrightness(Brightness brightness) {
    emit(state.copyWith(brightness: brightness));
  }

  void changeColor(Color color) {
    emit(state.copyWith(color: color));
  }
}

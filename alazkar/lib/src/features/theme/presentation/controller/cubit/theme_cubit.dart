import 'package:alazkar/src/features/theme/domain/repository/theme_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(
          ThemeState(
            brightness: ThemeStorage.getBrightness(),
            color: ThemeStorage.getColor(),
          ),
        );

  Future<void> changeBrightness(Brightness brightness) async {
    await ThemeStorage.setBrightness(brightness);
    emit(state.copyWith(brightness: brightness));
  }

  Future<void> changeColor(Color color) async {
    await ThemeStorage.setColor(color);
    emit(state.copyWith(color: color));
  }
}

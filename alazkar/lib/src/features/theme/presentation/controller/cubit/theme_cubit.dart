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
            useMaterial3: ThemeStorage.getUseMaterial3(),
            fontSize: ThemeStorage.getFontSize(),
          ),
        );

  Future<void> changeBrightness(Brightness brightness) async {
    await ThemeStorage.setBrightness(brightness);
    emit(state.copyWith(brightness: brightness));
  }

  Future<void> changeUseMaterial3(bool useMaterial3) async {
    await ThemeStorage.setUseMaterial3(useMaterial3);
    emit(state.copyWith(useMaterial3: useMaterial3));
  }

  Future<void> changeColor(Color color) async {
    await ThemeStorage.setColor(color);
    emit(state.copyWith(color: color));
  }

  Future<void> increaseFontSize() async {
    await _changeFontSize(state.fontSize + 5);
  }

  Future<void> decreaseFontSize() async {
    await _changeFontSize(state.fontSize - 5);
  }

  Future<void> restoreFontSize() async {
    await _changeFontSize(30);
  }

  Future<void> _changeFontSize(double fontSize) async {
    final double sizeToSet = fontSize.clamp(15, 60);
    await ThemeStorage.setFontSize(sizeToSet);
    emit(state.copyWith(fontSize: sizeToSet));
  }
}

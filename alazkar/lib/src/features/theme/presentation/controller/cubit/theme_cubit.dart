import 'package:alazkar/src/features/settings/data/repository/zikr_text_repo.dart';
import 'package:alazkar/src/features/theme/domain/repository/theme_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ZikrTextRepo zikrTextRepo;
  final ThemeStorage themeStorage;
  ThemeCubit(this.zikrTextRepo, this.themeStorage)
      : super(
          ThemeState(
            brightness: themeStorage.getBrightness,
            color: themeStorage.getColor,
            useMaterial3: themeStorage.getUseMaterial3,
            fontSize: zikrTextRepo.fontSize,
          ),
        );

  Future<void> changeBrightness(Brightness brightness) async {
    await themeStorage.setBrightness(brightness);
    emit(state.copyWith(brightness: brightness));
  }

  Future<void> changeUseMaterial3(bool useMaterial3) async {
    await themeStorage.setUseMaterial3(useMaterial3);
    emit(state.copyWith(useMaterial3: useMaterial3));
  }

  Future<void> changeColor(Color color) async {
    await themeStorage.setColor(color);
    emit(state.copyWith(color: color));
  }

  Future<void> increaseFontSize() async {
    await _changeFontSize(state.fontSize + 2);
  }

  Future<void> decreaseFontSize() async {
    await _changeFontSize(state.fontSize - 2);
  }

  Future<void> restoreFontSize() async {
    await _changeFontSize(30);
  }

  Future<void> _changeFontSize(double fontSize) async {
    final double sizeToSet = fontSize.clamp(15, 45);
    await zikrTextRepo.changFontSize(sizeToSet);
    emit(state.copyWith(fontSize: sizeToSet));
  }
}

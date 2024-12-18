import 'package:alazkar/src/features/settings/data/repository/settings_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SettingsStorage settingsStorage;
  SettingsCubit(this.settingsStorage)
      : super(
          SettingsState(
            showTextInBrackets: settingsStorage.showTextInBrackets(),
            praiseWithVolumeKeys: settingsStorage.praiseWithVolumeKeys,
          ),
        );

  Future toggleShowTextInBrackets() async {
    final bool showTextInBrackets = !state.showTextInBrackets;
    await settingsStorage.setShowTextInBrackets(showTextInBrackets);
    emit(state.copyWith(showTextInBrackets: showTextInBrackets));
  }

  ///MARK: praiseWithVolumeKeys
  Future togglePraiseWithVolumeKeys({required bool use}) async {
    await settingsStorage.changePraiseWithVolumeKeysStatus(value: use);
    emit(state.copyWith(praiseWithVolumeKeys: use));
  }
}

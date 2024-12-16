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
          ),
        );

  Future toggleShowTextInBrackets() async {
    final bool showTextInBrackets = !state.showTextInBrackets;
    await settingsStorage.setShowTextInBrackets(showTextInBrackets);
    emit(state.copyWith(showTextInBrackets: showTextInBrackets));
  }
}

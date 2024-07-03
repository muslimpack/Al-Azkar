import 'package:alazkar/src/features/settings/data/repository/settings_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          SettingsState(
            showTextInBrackets: SettingsStorage.showTextInBrackets(),
          ),
        );

  Future toggleShowTextInBrackets() async {
    final bool showTextInBrackets = !state.showTextInBrackets;
    await SettingsStorage.setShowTextInBrackets(showTextInBrackets);
    emit(state.copyWith(showTextInBrackets: showTextInBrackets));
  }
}

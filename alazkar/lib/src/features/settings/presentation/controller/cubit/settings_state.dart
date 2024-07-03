part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool showTextInBrackets;
  const SettingsState({
    required this.showTextInBrackets,
  });

  @override
  List<Object> get props => [showTextInBrackets];

  SettingsState copyWith({
    bool? showTextInBrackets,
  }) {
    return SettingsState(
      showTextInBrackets: showTextInBrackets ?? this.showTextInBrackets,
    );
  }
}

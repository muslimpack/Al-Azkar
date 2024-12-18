// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool showTextInBrackets;
  final bool praiseWithVolumeKeys;
  const SettingsState({
    required this.showTextInBrackets,
    required this.praiseWithVolumeKeys,
  });

  @override
  List<Object> get props => [
        showTextInBrackets,
        praiseWithVolumeKeys,
      ];

  SettingsState copyWith({
    bool? showTextInBrackets,
    bool? praiseWithVolumeKeys,
  }) {
    return SettingsState(
      showTextInBrackets: showTextInBrackets ?? this.showTextInBrackets,
      praiseWithVolumeKeys: praiseWithVolumeKeys ?? this.praiseWithVolumeKeys,
    );
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final Color color;
  final Brightness brightness;
  final bool useMaterial3;
  const ThemeState({
    required this.color,
    required this.brightness,
    required this.useMaterial3,
  });

  @override
  List<Object> get props => [color, brightness, useMaterial3];

  ThemeState copyWith({
    Color? color,
    Brightness? brightness,
    bool? useMaterial3,
  }) {
    return ThemeState(
      color: color ?? this.color,
      brightness: brightness ?? this.brightness,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
    );
  }
}

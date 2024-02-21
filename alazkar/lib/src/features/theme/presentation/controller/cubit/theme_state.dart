part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final Color color;
  final Brightness brightness;
  final bool useMaterial3;
  final double fontSize;
  const ThemeState({
    required this.color,
    required this.brightness,
    required this.useMaterial3,
    required this.fontSize,
  });

  @override
  List<Object> get props => [color, brightness, useMaterial3, fontSize];

  ThemeState copyWith({
    Color? color,
    Brightness? brightness,
    bool? useMaterial3,
    double? fontSize,
  }) {
    return ThemeState(
      color: color ?? this.color,
      brightness: brightness ?? this.brightness,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

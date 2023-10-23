// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final Color color;
  final Brightness brightness;
  const ThemeState({required this.color, required this.brightness});

  @override
  List<Object> get props => [color, brightness];

  ThemeState copyWith({
    Color? color,
    Brightness? brightness,
  }) {
    return ThemeState(
      color: color ?? this.color,
      brightness: brightness ?? this.brightness,
    );
  }
}

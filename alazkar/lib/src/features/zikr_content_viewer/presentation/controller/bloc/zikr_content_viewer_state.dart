part of 'zikr_content_viewer_bloc.dart';

sealed class ZikrContentViewerState extends Equatable {
  const ZikrContentViewerState();

  @override
  List<Object> get props => [];
}

final class ZikrContentViewerLoadingState extends ZikrContentViewerState {}

final class ZikrContentViewerLoadedState extends ZikrContentViewerState {
  final List<Zikr> azkar;
  final int activeZikrIndex;
  final ZikrTitle zikrTitle;

  const ZikrContentViewerLoadedState({
    required this.zikrTitle,
    required this.azkar,
    required this.activeZikrIndex,
  });

  ZikrContentViewerLoadedState copyWith({
    List<Zikr>? azkar,
    int? activeZikrIndex,
  }) {
    return ZikrContentViewerLoadedState(
      zikrTitle: zikrTitle,
      azkar: azkar ?? this.azkar,
      activeZikrIndex: activeZikrIndex ?? this.activeZikrIndex,
    );
  }

  double progress() {
    final length = azkar.length;
    final done = azkar.fold(
      0,
      (previousValue, element) =>
          element.count == 0 ? previousValue + 1 : previousValue,
    );

    return done / length;
  }

  Zikr get activeZikr => azkar[activeZikrIndex];

  @override
  List<Object> get props => [azkar, zikrTitle, activeZikrIndex];
}

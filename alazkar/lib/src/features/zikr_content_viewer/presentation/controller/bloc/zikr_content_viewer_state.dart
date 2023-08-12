// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'zikr_content_viewer_bloc.dart';

sealed class ZikrContentViewerState extends Equatable {
  const ZikrContentViewerState();

  @override
  List<Object> get props => [];
}

final class ZikrContentViewerLoadingState extends ZikrContentViewerState {}

final class ZikrContentViewerLoadedState extends ZikrContentViewerState {
  final List<Zikr> azkar;
  final Zikr activeZikr;

  const ZikrContentViewerLoadedState({
    required this.azkar,
    required this.activeZikr,
  });

  ZikrContentViewerLoadedState copyWith({
    List<Zikr>? azkar,
    Zikr? activeZikr,
  }) {
    return ZikrContentViewerLoadedState(
      azkar: azkar ?? this.azkar,
      activeZikr: activeZikr ?? this.activeZikr,
    );
  }

  @override
  List<Object> get props => [azkar, activeZikr];
}

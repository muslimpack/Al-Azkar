// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'share_image_cubit.dart';

sealed class ShareImageState extends Equatable {
  const ShareImageState();

  @override
  List<Object> get props => [];
}

final class ShareImageLoadingState extends ShareImageState {}

class ShareImageLoadedState extends ShareImageState {
  final Zikr zikr;
  final ZikrTitle zikrTitle;
  final bool showLoadingIndicator;
  final List<TextRange> splittedMatn;
  final ShareableImageCardSettings settings;
  final int activeIndex;
  const ShareImageLoadedState({
    required this.zikr,
    required this.zikrTitle,
    required this.showLoadingIndicator,
    required this.splittedMatn,
    required this.settings,
    required this.activeIndex,
  });

  @override
  List<Object> get props => [
        showLoadingIndicator,
        zikr,
        zikrTitle,
        settings,
        splittedMatn,
        activeIndex,
      ];

  ShareImageLoadedState copyWith({
    Zikr? zikr,
    ZikrTitle? zikrTitle,
    bool? showLoadingIndicator,
    List<TextRange>? splittedMatn,
    ShareableImageCardSettings? settings,
    int? activeIndex,
  }) {
    return ShareImageLoadedState(
      zikr: zikr ?? this.zikr,
      zikrTitle: zikrTitle ?? this.zikrTitle,
      showLoadingIndicator: showLoadingIndicator ?? this.showLoadingIndicator,
      splittedMatn: splittedMatn ?? this.splittedMatn,
      settings: settings ?? this.settings,
      activeIndex: activeIndex ?? this.activeIndex,
    );
  }
}

part of 'zikr_content_viewer_bloc.dart';

sealed class ZikrContentViewerEvent extends Equatable {
  const ZikrContentViewerEvent();

  @override
  List<Object> get props => [];
}

class ZikrContentViewerStartEvent extends ZikrContentViewerEvent {
  final int zikrTitleId;
  const ZikrContentViewerStartEvent(this.zikrTitleId);

  @override
  List<Object> get props => [zikrTitleId];
}

class ZikrContentViewerDecreaseEvent extends ZikrContentViewerEvent {
  final Zikr zikr;

  const ZikrContentViewerDecreaseEvent(this.zikr);

  @override
  List<Object> get props => [zikr];
}

class ZikrContentViewerPageChangeEvent extends ZikrContentViewerEvent {
  final int index;

  const ZikrContentViewerPageChangeEvent(this.index);

  @override
  List<Object> get props => [index];
}

class ZikrContentViewerCopyEvent extends ZikrContentViewerEvent {}

class ZikrContentViewerShareEvent extends ZikrContentViewerEvent {}

class ZikrContentViewerNextTitleEvent extends ZikrContentViewerEvent {}

class ZikrContentViewerPerviousTitleEvent extends ZikrContentViewerEvent {}

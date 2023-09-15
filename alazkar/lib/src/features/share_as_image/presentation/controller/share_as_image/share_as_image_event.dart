part of 'share_as_image_bloc.dart';

abstract class ShareAsImageEvent extends Equatable {
  const ShareAsImageEvent();

  @override
  List<Object?> get props => [];
}

class ShareAsImageStartEvent extends ShareAsImageEvent {
  final Zikr zikr;
  final ZikrTitle zikrTitle;
  const ShareAsImageStartEvent({required this.zikr, required this.zikrTitle});

  @override
  List<Object> get props => [zikr, zikrTitle];
}

class ShareAsImageChangeWidthEvent extends ShareAsImageEvent {
  final double width;
  const ShareAsImageChangeWidthEvent({
    required this.width,
  });
  @override
  List<Object> get props => [
        width,
      ];
}

class ShareAsImageIncreaseFontSizeEvent extends ShareAsImageEvent {}

class ShareAsImageDecreaseFontSizeEvent extends ShareAsImageEvent {}

class ShareAsImageResetFontSizeEvent extends ShareAsImageEvent {}

class ShareAsImageChangeShowAppInfoEvent extends ShareAsImageEvent {
  final bool showAppInfo;
  const ShareAsImageChangeShowAppInfoEvent({
    required this.showAppInfo,
  });
  @override
  List<Object> get props => [
        showAppInfo,
      ];
}

class ShareAsImageChangeFontSizeEvent extends ShareAsImageEvent {
  final double fontSize;
  const ShareAsImageChangeFontSizeEvent({
    required this.fontSize,
  });
  @override
  List<Object> get props => [
        fontSize,
      ];
}

class ShareAsImageChangeTextColorEvent extends ShareAsImageEvent {
  final Color textColor;
  const ShareAsImageChangeTextColorEvent({
    required this.textColor,
  });
  @override
  List<Object> get props => [
        textColor,
      ];
}

class ShareAsImageChangeBackgroundColorEvent extends ShareAsImageEvent {
  final Color backgroundColor;
  const ShareAsImageChangeBackgroundColorEvent({
    required this.backgroundColor,
  });
  @override
  List<Object> get props => [
        backgroundColor,
      ];
}

class ShareAsImageShareEvent extends ShareAsImageEvent {
  final GlobalKey key;
  const ShareAsImageShareEvent({
    required this.key,
  });
  @override
  List<Object?> get props => [
        key,
      ];
}

class ShareAsImageDoubleTapEvent extends ShareAsImageEvent {
  final Size screenSize;
  final Size imageSize;
  const ShareAsImageDoubleTapEvent({
    required this.screenSize,
    required this.imageSize,
  });
  @override
  List<Object> get props => [
        screenSize,
        imageSize,
      ];
}

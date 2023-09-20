part of 'share_as_image_bloc.dart';

abstract class ShareAsImageState extends Equatable {
  const ShareAsImageState();

  @override
  List<Object> get props => [];
}

class ShareAsImageLoadingState extends ShareAsImageState {}

class ShareAsImageLoadedState extends ShareAsImageState {
  final ZikrTitle zikrTitle;
  final Zikr zikr;
  final bool isLoading;
  final bool showAppInfo;
  final double fontSize;
  final double width;
  final Color textColor;
  final Color backgroundColor;
  final TransformationController transformationController;

  /* *************** Variables *************** */

  ShareAsImageLoadedState({
    required this.zikr,
    required this.zikrTitle,
    required this.isLoading,
    required this.showAppInfo,
    required this.fontSize,
    required this.width,
    required this.textColor,
    required this.backgroundColor,
    required this.transformationController,
  });

  // ******************************************* //
  final box = GetStorage();

  Future<Widget> generateImageBodyContent() async {
    return Column(
      children: [
        Text(
          zikrTitle.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize * 1.5,
            color: textColor,
            fontFamily: "Kitab",
          ),
        ),
        Divider(
          thickness: 5,
          height: 40,
          color: Colors.brown.shade900,
        ),
        Text(
          zikr.body,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize * 1.5,
            color: textColor,
            fontFamily: "Kitab",
            height: 2,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "عدد مرات الذكر: ${zikr.count}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontFamily: "Cairo",
          ),
        ),
        const SizedBox(height: 20),
        Text(
          zikr.fadl,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize * 1.3,
            color: textColor,
            fontFamily: "Kitab",
            height: 2,
          ),
        ),
      ],
    );
  }

  ShareAsImageLoadedState copyWith({
    Zikr? zikr,
    ZikrTitle? zikrTitle,
    bool? isLoading,
    bool? showAppInfo,
    double? fontSize,
    double? width,
    Color? textColor,
    Color? backgroundColor,
    TransformationController? transformationController,
  }) {
    return ShareAsImageLoadedState(
      zikr: zikr ?? this.zikr,
      zikrTitle: zikrTitle ?? this.zikrTitle,
      isLoading: isLoading ?? this.isLoading,
      showAppInfo: showAppInfo ?? this.showAppInfo,
      fontSize: fontSize ?? this.fontSize,
      width: width ?? this.width,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      transformationController:
          transformationController ?? this.transformationController,
    );
  }

  @override
  List<Object> get props => [
        zikr,
        zikrTitle,
        isLoading,
        showAppInfo,
        fontSize,
        width,
        textColor,
        backgroundColor,
        transformationController
      ];
}

ShareAsImageData shareAsImageData = ShareAsImageData();

class ShareAsImageData {
  final box = GetStorage();
  //////////////////
  ///
  final String showAppInfoKey = 'share_image_show_app_info';
  bool get showAppInfo => box.read<bool?>(showAppInfoKey) ?? true;

  ///
  final String textColorKey = 'share_image_text_color';
  Color get textColor => Color(
        box.read<int?>(textColorKey) ?? Colors.white.value,
      );

  ///
  final String backgroundColorKey = 'share_image_background_color';
  Color get backgroundColor => Color(
        box.read<int?>(backgroundColorKey) ?? Colors.brown.value,
      );

  ///
  final String fontSizeKey = 'share_image_font_size';
  double get fontSize => box.read(fontSizeKey) ?? 30;

  ///
  final String imageWidthKey = 'share_image_image_width';
  double get imageWidth => box.read(imageWidthKey) ?? 900;

  ///
  final String imageQualityKey = 'share_image_image_quality';
  double get imageQuality => box.read(imageQualityKey) ?? 2;
}

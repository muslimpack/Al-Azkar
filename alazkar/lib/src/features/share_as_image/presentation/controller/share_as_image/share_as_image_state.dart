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
  final box = GetStorage(kGetStorageName);

  Future<Widget> generateImageBodyContent() async {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ImageSharedBorder(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: 50),
          child: Center(
            child: Text(
              zikrTitle.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize * 1.3,
                color: textColor,
                fontFamily: "Kitab",
              ),
            ),
          ),
        ),
        ZikrContentBuilder(
          zikr: zikr,
          enableDiacritics: true,
          fontSize: fontSize * 1.5,
          color: textColor,
        ),
        const SizedBox(height: 20),
        Text(
          "عدد مرات الذكر: ${zikr.count}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontFamily: "Kitab",
            fontStyle: FontStyle.italic,
          ),
        ),
        if (zikr.fadl.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            zikr.fadl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize * 1.3,
              color: textColor,
              fontFamily: "Kitab",
              fontStyle: FontStyle.italic,
              height: 2,
            ),
          ),
        ],
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
        transformationController,
      ];
}

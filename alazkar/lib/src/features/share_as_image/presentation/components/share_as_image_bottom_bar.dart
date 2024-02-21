import 'package:alazkar/src/features/share_as_image/presentation/components/color_swatch_builder.dart';
import 'package:alazkar/src/features/share_as_image/presentation/components/width_dialog.dart';
import 'package:alazkar/src/features/share_as_image/presentation/controller/share_as_image/share_as_image_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ShareAsImageBottomBar extends StatelessWidget {
  const ShareAsImageBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> colorSwatchList = [
      Colors.brown,
      Colors.white,
    ];
    return BlocBuilder<ShareAsImageBloc, ShareAsImageState>(
      builder: (context, state) {
        if (state is! ShareAsImageLoadedState) {
          return const SizedBox();
        }
        return BottomAppBar(
          child: Center(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                Tooltip(
                  message: "وضع معلومات التطبيق",
                  child: Switch(
                    value: state.showAppInfo,
                    onChanged: (value) {
                      context.read<ShareAsImageBloc>().add(
                            ShareAsImageChangeShowAppInfoEvent(
                              showAppInfo: value,
                            ),
                          );
                    },
                  ),
                ),
                Tooltip(
                  message: "لون الخلفية",
                  child: ColorSwatchBuilder(
                    colorToTrack: state.backgroundColor,
                    colorSwatchList: colorSwatchList,
                    apply: (color) {
                      context.read<ShareAsImageBloc>().add(
                            ShareAsImageChangeBackgroundColorEvent(
                              backgroundColor: color,
                            ),
                          );
                    },
                  ),
                ),
                Tooltip(
                  message: "لون النص",
                  child: ColorSwatchBuilder(
                    colorToTrack: state.textColor,
                    colorSwatchList: colorSwatchList,
                    apply: (color) {
                      context.read<ShareAsImageBloc>().add(
                            ShareAsImageChangeTextColorEvent(
                              textColor: color,
                            ),
                          );
                    },
                  ),
                ),
                IconButton(
                  tooltip: "إعادة ضبط الخط",
                  icon: Icon(MdiIcons.reload),
                  onPressed: () {
                    context
                        .read<ShareAsImageBloc>()
                        .add(ShareAsImageResetFontSizeEvent());
                  },
                ),
                IconButton(
                  tooltip: "تكبير حجم الخط",
                  icon: Icon(MdiIcons.formatFontSizeIncrease),
                  onPressed: () {
                    context
                        .read<ShareAsImageBloc>()
                        .add(ShareAsImageIncreaseFontSizeEvent());
                  },
                ),
                IconButton(
                  tooltip: "تصغير حجم الخط",
                  icon: Icon(MdiIcons.formatFontSizeDecrease),
                  onPressed: () {
                    context
                        .read<ShareAsImageBloc>()
                        .add(ShareAsImageDecreaseFontSizeEvent());
                  },
                ),
                IconButton(
                  tooltip: "ضبط عرض الصورة",
                  onPressed: () async {
                    await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (_) {
                        return ImageWidthDialog(
                          initialValue:
                              shareAsImageData.imageWidth.toInt().toString(),
                          onSubmit: (width) async {
                            final int tempWidth = int.tryParse(width) ??
                                shareAsImageData.imageWidth.toInt();

                            context.read<ShareAsImageBloc>().add(
                                  ShareAsImageChangeWidthEvent(
                                    width: tempWidth.toDouble(),
                                  ),
                                );
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(MdiIcons.resize),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

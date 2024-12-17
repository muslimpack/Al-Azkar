// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/features/share_as_image/data/models/shareable_image_card_settings.dart';
import 'package:alazkar/src/features/share_as_image/presentation/components/dot_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ShareableImageCard extends StatelessWidget {
  final ZikrTitle zikrTitle;
  final Zikr zikr;
  final ShareableImageCardSettings settings;
  final TextRange? matnRange;
  final int splittedLength;
  final int splittedindex;

  const ShareableImageCard({
    super.key,
    required this.zikrTitle,
    required this.zikr,
    required this.settings,
    this.matnRange,
    this.splittedLength = 0,
    this.splittedindex = 0,
  });

  String get mainText {
    const String separator = "...";
    String mainText = matnRange != null
        ? zikr.body.substring(
            matnRange!.start,
            matnRange!.end,
          )
        : zikr.body;

    if (splittedLength > 1) {
      if (splittedindex == 0) {
        mainText += separator;
      } else if (splittedindex == splittedLength - 1) {
        mainText = "$separator$mainText";
      } else {
        mainText = "$separator$mainText$separator";
      }
    }

    return mainText;
  }

  @override
  Widget build(BuildContext context) {
    const imageBackgroundColor = Color(0xff1a110e);
    const secondaryColor = Color(0xfffeb99c);
    //todo depened on zikr hokm
    final secondaryElementsColor = Colors.brown.withOpacity(.15);

    final mainTextStyle = TextStyle(
      fontSize: 150,
      fontFamily: settings.mainFontFamily,
      color: Colors.white,
    );

    final secondaryTextStyle = TextStyle(
      fontSize: 35,
      color: secondaryColor,
      fontFamily: settings.secondaryFontFamily,
    );

    return Container(
      color: imageBackgroundColor,
      height: settings.imageSize.height,
      width: settings.imageSize.width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/grid.png",
            fit: BoxFit.cover,
            color: Colors.white.withOpacity(.07),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  imageBackgroundColor,
                  Colors.transparent,
                ],
                radius: 1,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(40).copyWith(top: 60, bottom: 60),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.11),
              border: Border.all(
                color: secondaryElementsColor,
                width: 5,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
                bottomLeft: Radius.circular(255),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  zikrTitle.name,
                  textAlign: TextAlign.center,
                  style: secondaryTextStyle,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: Center(
                    child: AutoSizeText(
                      mainText,
                      minFontSize: 30,
                      textAlign: TextAlign.center,
                      style: mainTextStyle,
                    ),
                  ),
                ),
                if (zikr.fadl.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 65),
                    child: Text(
                      "الفضل: ${zikr.fadl}",
                      style: secondaryTextStyle,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 50),
                ],
              ],
            ),
          ),
          if (splittedLength > 1)
            Padding(
              padding: const EdgeInsets.all(15).copyWith(left: 200, right: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DotBar(
                    activeIndex: splittedindex,
                    length: splittedLength,
                    dotColor: secondaryColor,
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              "assets/icons/app.png",
              height: 140,
            ),
          ),
        ],
      ),
    );
  }
}

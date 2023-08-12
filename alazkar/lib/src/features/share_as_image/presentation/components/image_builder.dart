import 'package:flutter/material.dart';

class ImageBuilder extends StatelessWidget {
  final double width;
  final double fontSize;
  final Widget content;
  final Color backgroundColor;
  final Color textColor;
  final bool showAppInfo;
  const ImageBuilder({
    super.key,
    required this.width,
    required this.backgroundColor,
    required this.textColor,
    required this.content,
    required this.fontSize,
    required this.showAppInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListView(
        padding: const EdgeInsets.all(40),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: content,
          ),
          if (!showAppInfo)
            const SizedBox()
          else ...[
            const SizedBox(
              height: 10,
            ),
            Divider(
              height: 20,
              color: textColor,
            ),
            _footer()
          ],
        ],
      ),
    );
  }

  Widget _footer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/icons/app.png",
                width: fontSize * 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "بواسطة تطبيق الأذكار",
                  style: TextStyle(
                    fontSize: fontSize * (3 / 3),
                    color: textColor,
                    fontFamily: "Uthmanic",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

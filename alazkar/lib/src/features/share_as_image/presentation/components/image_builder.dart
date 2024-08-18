// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dotted_border/dotted_border.dart';
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
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: ImageSharedBorder(
        enbaled: false,
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
              // const SizedBox(height: 50),
              ImageSharedBorder(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 50),
                child: ImageFooter(fontSize: fontSize, textColor: textColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ImageSharedBorder extends StatelessWidget {
  final Widget? child;
  final bool enbaled;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  const ImageSharedBorder({
    super.key,
    this.child,
    this.enbaled = true,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return !enbaled
        ? child ?? const SizedBox()
        : Container(
            margin: margin,
            child: DottedBorder(
              color: Colors.brown.shade900,
              borderType: BorderType.RRect,
              radius: const Radius.circular(10),
              dashPattern: const [10, 0, 10],
              strokeWidth: 5,
              child: Container(
                padding: padding,
                child: child ?? const SizedBox(),
              ),
            ),
          );
  }
}

class ImageFooter extends StatelessWidget {
  const ImageFooter({
    super.key,
    required this.fontSize,
    required this.textColor,
  });

  final double fontSize;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/app.png",
            width: fontSize * 2,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(
              "بواسطة تطبيق الأذكار النووية",
              style: TextStyle(
                fontSize: fontSize * (3 / 3),
                color: textColor,
                fontFamily: "Uthmanic",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

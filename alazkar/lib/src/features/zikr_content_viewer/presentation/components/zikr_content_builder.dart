import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_extension.dart';
import 'package:alazkar/src/features/zikr_content_viewer/presentation/components/custom_text_formatter.dart';
import 'package:flutter/material.dart';

class ZikrContentBuilder extends StatelessWidget {
  final Zikr zikr;
  final double fontSize;
  final bool enableDiacritics;
  final Color? color;
  const ZikrContentBuilder({
    super.key,
    required this.zikr,
    required this.fontSize,
    required this.enableDiacritics,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final containsQuranText = zikr.body.contains("QuranText");
    return containsQuranText
        ? ZikrContentTextWithQuran(
            zikr: zikr,
            enableDiacritics: enableDiacritics,
            fontSize: fontSize,
            color: color,
          )
        : ZikrContentPlainText(
            zikr: zikr,
            enableDiacritics: enableDiacritics,
            fontSize: fontSize,
            color: color,
          );
  }
}

class ZikrContentPlainText extends StatelessWidget {
  final Zikr zikr;
  final double fontSize;
  final bool enableDiacritics;
  final Color? color;
  const ZikrContentPlainText({
    super.key,
    required this.zikr,
    required this.fontSize,
    required this.enableDiacritics,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return StringFormatter(
      //TDOD remove after database update
      text: zikr.body.replaceAll("، ،", "،").replaceAll("  ", " "),
      fontSize: fontSize,
      color: color,
      enableDiacritics: enableDiacritics,
    );
  }
}

class ZikrContentTextWithQuran extends StatelessWidget {
  final Zikr zikr;
  final double fontSize;
  final bool enableDiacritics;
  final Color? color;
  const ZikrContentTextWithQuran({
    super.key,
    required this.zikr,
    required this.fontSize,
    required this.enableDiacritics,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: zikr.getTextSpan(enableDiacritics: enableDiacritics),
      builder: (context, snap) {
        if (!snap.hasData) return const LinearProgressIndicator();

        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: snap.data ?? [],
            style: TextStyle(
              fontSize: fontSize,
              height: 2,
              fontFamily: "Kitab",
              color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        );
      },
    );
  }
}

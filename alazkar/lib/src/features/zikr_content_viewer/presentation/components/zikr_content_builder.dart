// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/constants/const.dart';
import 'package:alazkar/src/core/extension/extension_string.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_extension.dart';
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
    return Text(
      enableDiacritics ? zikr.body : zikr.body.removeDiacritics,
      textAlign: TextAlign.center,
      softWrap: true,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: fontSize,
        height: 2,
        color: color,
        fontFamily: "Kitab",
      ),
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

  List<InlineSpan> getTextSpan(List<String> verses) {
    final List<String> lines = zikr.body.split("\n");

    lines.indexWhere((e) => e.contains("QuranText"));

    final List<InlineSpan> spans = [];

    for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];

      if (line.contains("QuranText")) {
        if (lineIndex != 0) spans.add(const TextSpan(text: "\n\n"));
        for (var i = 0; i < verses.length; i++) {
          final List<String> verse = [];

          if (i == 0) verse.addAll([kEstaaza, "\n\n"]);

          verse.add(kArBasmallah);

          verse.add(" ﴿ ${verses[i].trim()} ﴾");

          if (i != verses.length - 1) verse.add("\n\n");

          spans.add(
            TextSpan(
              text: enableDiacritics
                  ? verse.join()
                  : verse.join().removeDiacritics,
              style: const TextStyle(
                fontFamily: "Uthmanic2",
              ),
            ),
          );
        }
        if (lineIndex != lines.length - 1) {
          spans.add(const TextSpan(text: "\n\n"));
        }
      } else {
        spans.add(
          TextSpan(
            text: enableDiacritics ? line : line.removeDiacritics,
          ),
        );
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: zikr.getQuranVersesText(),
      builder: (context, snap) {
        if (!snap.hasData) return const LinearProgressIndicator();

        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: getTextSpan(snap.data ?? []),
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

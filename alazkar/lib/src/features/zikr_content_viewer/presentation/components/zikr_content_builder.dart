// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/constants/const.dart';
import 'package:alazkar/src/core/extension/extension_string.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_extension.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
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
    final containAyah = zikr.body.contains("﴿");
    return Text(
      enableDiacritics ? zikr.body : zikr.body.removeDiacritics,
      textAlign: TextAlign.center,
      softWrap: true,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: fontSize,
        height: 2,
        color: color,
        fontFamily: containAyah ? "Uthmanic2" : "Kitab",
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

  Future<List<InlineSpan>> getTextSpan() async {
    final List<String> lines = zikr.body.split("\n");

    lines.indexWhere((e) => e.contains("QuranText"));

    final List<InlineSpan> spans = [];

    for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];

      if (line.contains("QuranText")) {
        appPrint(line);
        spans.addAll(
          _getTextSpanForSingleItem(
            await zikr.getQuranVersesTextFormSingleRange(line),
            lines.length,
            lineIndex,
          ),
        );
      } else {
        final containAyah = zikr.body.contains("﴿");
        spans.add(
          TextSpan(
            text: enableDiacritics ? line : line.removeDiacritics,
            style: containAyah
                ? TextStyle(
                    fontFamily: containAyah ? "Uthmanic2" : "Kitab",
                  )
                : null,
          ),
        );
      }
    }
    return spans;
  }

  List<InlineSpan> _getTextSpanForSingleItem(
    List<String> verses,
    int linesLength,
    int lineIndex,
  ) {
    final List<InlineSpan> spans = [];
    if (lineIndex != 0) spans.add(const TextSpan(text: "\n\n"));
    for (var i = 0; i < verses.length; i++) {
      final List<String> verse = [];

      if (i == 0) verse.addAll([kEstaaza, "\n\n"]);

      verse.add(kArBasmallah);

      verse.add(" ﴿ ${verses[i].trim()} ﴾");

      if (i != verses.length - 1) verse.add("\n\n");

      spans.add(
        TextSpan(
          text: enableDiacritics ? verse.join() : verse.join().removeDiacritics,
          style: const TextStyle(
            fontFamily: "Uthmanic2",
          ),
        ),
      );
    }
    if (lineIndex != linesLength - 1) {
      spans.add(const TextSpan(text: "\n\n"));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTextSpan(),
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

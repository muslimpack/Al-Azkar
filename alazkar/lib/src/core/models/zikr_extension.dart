import 'dart:async';

import 'package:alazkar/src/core/constants/const.dart';
import 'package:alazkar/src/core/extension/extension_rich_text.dart';
import 'package:alazkar/src/core/extension/extension_string.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/core/utils/range_text_formatter.dart';
import 'package:alazkar/src/features/quran/data/models/verse_range.dart';
import 'package:alazkar/src/features/quran/data/repository/uthmani_repository.dart';
import 'package:flutter/material.dart';

extension ZikrExt on Zikr {
  Future<String> toPlainText({bool enableDiacritics = true}) async {
    if (body.contains("QuranText")) {
      final spans = await getTextSpan(enableDiacritics: enableDiacritics);
      final RichText richText = RichText(
        text: TextSpan(
          children: spans,
        ),
      );

      return richText.toPlainText();
    } else {
      return body;
    }
  }

  Future<Map<VerseRange, String>> getQuranVersesTextFormSingleRange(
    String rangeText,
  ) async {
    final List<VerseRange> ranges = RangeTextFormatter.parse(rangeText);
    final Map<VerseRange, String> result = {};

    final List<String> verses = [];
    for (final range in ranges) {
      final text = await uthmaniRepository.getArabicText(
        sura: range.startSura,
        startAyah: range.startAyah,
        endAyah: range.endingAyah,
      );
      verses.add(text);
      result[range] = text;
    }

    return result;
  }

  Future<List<InlineSpan>> getTextSpan({bool enableDiacritics = true}) async {
    final List<String> lines = body.split("\n");

    lines.indexWhere((e) => e.contains("QuranText"));

    final List<InlineSpan> spans = [];

    for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];
      appPrint("line:: $line");
      if (line.contains("QuranText")) {
        spans.addAll(
          _getTextSpanForSingleItem(
            await getQuranVersesTextFormSingleRange(line),
            lines.length,
            lineIndex,
            enableDiacritics,
          ),
        );
      } else {
        final containAyah = body.contains("﴿");
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
    Map<VerseRange, String> verses,
    int linesLength,
    int lineIndex,
    bool enableDiacritics,
  ) {
    final List<InlineSpan> spans = [];
    if (lineIndex != 0) spans.add(const TextSpan(text: "\n\n"));
    for (var i = 0; i < verses.entries.length; i++) {
      final currentVerse = verses.entries.elementAt(i);

      final List<String> verse = [];

      final alhashrFinalAyah =
          currentVerse.key.startSura == 59 && currentVerse.key.startAyah == 22;

      final bool notHaveEstaaza = alhashrFinalAyah;
      if (i == 0 && !notHaveEstaaza) verse.addAll([kEstaaza, "\n\n"]);

      verse.add(kArBasmallah);

      verse.add(" ﴿ ${currentVerse.value.trim()} ﴾");

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
}

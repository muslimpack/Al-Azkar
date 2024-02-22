import 'dart:async';

import 'package:alazkar/src/core/constants/const.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/utils/range_text_formatter.dart';
import 'package:alazkar/src/features/quran/data/models/verse_range.dart';
import 'package:alazkar/src/features/quran/data/repository/uthmani_repository.dart';

extension ZikrExt on Zikr {
  Future<List<String>> getQuranVersesTextFormSingleRange(
    String rangeText,
  ) async {
    final List<VerseRange> ranges = RangeTextFormatter.parse(rangeText);

    final List<String> verses = [];
    for (final range in ranges) {
      final text = await uthmaniRepository.getArabicText(
        sura: range.startSura,
        startAyah: range.startAyah,
        endAyah: range.endingAyah,
      );
      verses.add(text);
    }

    return verses;
  }

  Future<List<String>> convertVersesToText() async {
    final List<String> lines = body.split("\n");

    lines.indexWhere((e) => e.contains("QuranText"));

    final List<String> spans = [];

    for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
      final line = lines[lineIndex];

      if (line.contains("QuranText")) {
        spans.addAll(
          _convertVersesToTextForSingleItem(
            await getQuranVersesTextFormSingleRange(line),
            lines.length,
            lineIndex,
          ),
        );
      } else {
        spans.add(
          line,
        );
      }
    }
    return spans;
  }

  List<String> _convertVersesToTextForSingleItem(
    List<String> verses,
    int linesLength,
    int lineIndex,
  ) {
    final List<String> spans = [];
    if (lineIndex != 0) spans.add("\n\n");
    for (var i = 0; i < verses.length; i++) {
      final List<String> verse = [];

      if (i == 0) verse.addAll([kEstaaza, "\n\n"]);

      verse.add(kArBasmallah);

      verse.add(" ﴿ ${verses[i].trim()} ﴾");

      if (i != verses.length - 1) verse.add("\n\n");

      spans.add(
        verse.join(),
      );
    }
    if (lineIndex != linesLength - 1) {
      spans.add("\n\n");
    }

    return spans;
  }

  Future<String> getPlainText() async {
    if (body.contains("QuranText")) {
      final text = await convertVersesToText();
      return text.join();
    } else {
      return body;
    }
  }
}

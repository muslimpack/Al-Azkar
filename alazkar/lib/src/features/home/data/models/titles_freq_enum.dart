import 'package:alazkar/src/core/utils/app_print.dart';

enum TitlesFreqEnum {
  daily,
  week,
  month,
  year,
}

extension TitlesFreqEnumExt on TitlesFreqEnum {
  String get arabicName {
    switch (this) {
      case TitlesFreqEnum.daily:
        return "يومي";
      case TitlesFreqEnum.week:
        return "أسبوعي";
      case TitlesFreqEnum.month:
        return "شهري";
      case TitlesFreqEnum.year:
        return "سنوي";
    }
  }
}

extension TitlesFreqEnumListExt on List<TitlesFreqEnum> {
  bool validate(String freq) {
    bool isValid = false;

    for (var i = 0; i < length; i++) {
      final freqTxt = this[i].name[0].toLowerCase();
      appPrint(freqTxt);
      isValid = freq.contains(freqTxt);

      if (isValid) break;
    }

    return isValid;
  }
}

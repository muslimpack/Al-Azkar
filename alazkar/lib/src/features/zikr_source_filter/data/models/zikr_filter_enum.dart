enum ZikrFilter {
  quran,
  sahihBukhari,
  sahihMuslim,
  abuDawood,
  atTirmidhi,
  anNasai,
  ibnMajah,
  malik,
  adDarami,
  ahmad,
  ibnSunny,
}

extension ZikrFilterExt on ZikrFilter {
  String get nameInDatabase {
    switch (this) {
      case ZikrFilter.quran:
        return "سورة";
      case ZikrFilter.sahihBukhari:
        return "البخاري";
      case ZikrFilter.sahihMuslim:
        return "مسلم";
      case ZikrFilter.abuDawood:
        return "داود";
      case ZikrFilter.atTirmidhi:
        return "الترمذي";
      case ZikrFilter.anNasai:
        return "النسائي";
      case ZikrFilter.ibnMajah:
        return "ماجه";
      case ZikrFilter.malik:
        return "مالك";
      case ZikrFilter.adDarami:
        return "الدارمي";
      case ZikrFilter.ahmad:
        return "أحمد";
      case ZikrFilter.ibnSunny:
        return "السني";
    }
  }

  String get arabicName {
    switch (this) {
      case ZikrFilter.quran:
        return "القرآن";
      case ZikrFilter.sahihBukhari:
        return "صحيح البخاري";
      case ZikrFilter.sahihMuslim:
        return "صحيح مسلم";
      case ZikrFilter.abuDawood:
        return "سنن أبي داود";
      case ZikrFilter.atTirmidhi:
        return "سنن الترمذي";
      case ZikrFilter.anNasai:
        return "سنن النسائي";
      case ZikrFilter.ibnMajah:
        return "سنن ابن ماجه";
      case ZikrFilter.malik:
        return "موطأ مالك";
      case ZikrFilter.adDarami:
        return "مسند الدارمي";
      case ZikrFilter.ahmad:
        return "مسند أحمد";
      case ZikrFilter.ibnSunny:
        return "عمل اليوم والليلة لابن السني";
    }
  }

  String get englishName {
    switch (this) {
      case ZikrFilter.quran:
        return "Quran";
      case ZikrFilter.sahihBukhari:
        return "Sahih Bukhari";
      case ZikrFilter.sahihMuslim:
        return "Sahih Muslim";
      case ZikrFilter.abuDawood:
        return "Sunan Abu Dawood";
      case ZikrFilter.atTirmidhi:
        return "Sunan AtTirmidhi";
      case ZikrFilter.anNasai:
        return "Sunan AnNasai";
      case ZikrFilter.ibnMajah:
        return "Sunan IbnMajah";
      case ZikrFilter.malik:
        return "Malik";
      case ZikrFilter.adDarami:
        return "AdDarami";
      case ZikrFilter.ahmad:
        return "Ahmad";
      case ZikrFilter.ibnSunny:
        return "IbnSunny";
    }
  }
}

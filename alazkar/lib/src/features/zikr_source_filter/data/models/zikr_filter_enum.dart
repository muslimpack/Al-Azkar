enum ZikrFilter {
  /// Source
  quran("سور", "القرآن", "Quran"),

  sahihBukhari("بخار", "صحيح البخاري", "Sahih Bukhari"),

  sahihMuslim("مسلم", "صحيح مسلم", "Sahih Muslim"),

  abuDawood("داو", "سنن أبي داود", "Sunan Abu Dawood"),

  atTirmidhi("ترمذ", "سنن الترمذي", "Sunan AtTirmidhi"),

  anNasai("النسائي", "سنن النسائي", "Sunan AnNasai"),

  ibnMajah("ماج", "سنن ابن ماجه", "Sunan IbnMajah"),

  malik("مالك", "موطأ مالك", "Malik"),

  adDarami("دارم", "مسند الدارمي", "AdDarami"),

  ahmad("أحمد", "مسند أحمد", "Ahmad"),

  ibnSunny("بن السن", "عمل اليوم والليلة لابن السني", "IbnSunny"),

  hakim("حاكم", "المستدرك على الصحيحين للحاكم النيسابوري", "AlHakim"),

  bayhaqi("بيهق", "سنن البيهقي", "AlBayhaqi"),

  athar("أثر", "أثر", "Athr"),

  /// Hokm
  hokmSahih("صحيح", "صحيح", "Authentic"),

  hokmHasan("حسن", "حسن", "Good"),

  hokmDaeif("ضعيف", "ضعيف", "Weak"),

  hokmMawdue("موضوع", "موضوع", "Fabricated"),

  hokmAthar("أثر", "أثر", "Athar");

  const ZikrFilter(this.nameInDatabase, this.arabicName, this.englishName);
  final String nameInDatabase;
  final String arabicName;
  final String englishName;
}

extension ZikrFilterExt on ZikrFilter {
  List<ZikrFilter> get hokmFilters => [
        ZikrFilter.hokmSahih,
        ZikrFilter.hokmHasan,
        ZikrFilter.hokmDaeif,
        ZikrFilter.hokmMawdue,
        ZikrFilter.hokmAthar,
      ];

  bool get isForHokm => hokmFilters.contains(this);
}

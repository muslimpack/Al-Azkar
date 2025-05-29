import 'package:flutter/material.dart';

enum SearchType {
  typical,
  allWords,
  anyWords;

  static SearchType fromString(String map) {
    return SearchType.values.where((e) => e.name == map).firstOrNull ??
        SearchType.typical;
  }
}

extension SearchTypeExtension on SearchType {
  String localeName(BuildContext context) {
    switch (this) {
      case SearchType.typical:
        return "بحث مطابق";
      case SearchType.allWords:
        return "جميع الكلمات";
      case SearchType.anyWords:
        return "أي كلمة";
    }
  }
}

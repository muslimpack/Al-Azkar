import 'package:flutter/material.dart';

enum SearchFor {
  title,
  content;

  static SearchFor fromString(String map) {
    return SearchFor.values.where((e) => e.name == map).firstOrNull ??
        SearchFor.title;
  }
}

extension SearchForExtension on SearchFor {
  String localeName(BuildContext context) {
    switch (this) {
      case SearchFor.title:
        return "الفهرس";
      case SearchFor.content:
        return "المحتوى";
    }
  }
}

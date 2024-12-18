// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/di/dependency_injection.dart';
import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_enum.dart';
import 'package:flutter/foundation.dart';

Future<void> viewStatistics() async {
  if (!kDebugMode) return;
  final allTitles = await sl<AzkarDBHelper>().getAllTitles();
  final allContent = await sl<AzkarDBHelper>().getAllContents();
  appPrint("عدد الأذكار: ${allContent.length}");
  appPrint("عدد الأبواب: ${allTitles.length}");
  appPrint("***********");

  await viewContentsStatistics(allContent);
}

Future<void> viewContentsStatistics(List<Zikr> allContent) async {
  final filterResult = ZikrFilter.values
      .map(
        (e) => ZikrContentStats(filter: e),
      )
      .toList();

  for (final content in allContent) {
    for (final f in filterResult) {
      if (f.filter.isForHokm) {
        f.count += (content.hokm == f.filter.nameInDatabase) ? 1 : 0;
        f.titlesId.add(content.titleId);
      } else {
        f.count += (content.source.contains(f.filter.nameInDatabase)) ? 1 : 0;
        f.titlesId.add(content.titleId);
      }
    }
  }

  // Sort the list of entries by value
  filterResult.sort((a, b) => b.count.compareTo(a.count));

  for (final f in filterResult) {
    if (!f.filter.isForHokm) {
      appPrint(f);
    }
  }
  appPrint("***********");
  for (final f in filterResult) {
    if (f.filter.isForHokm) {
      appPrint(f);
    }
  }
}

class ZikrContentStats {
  final ZikrFilter filter;
  final Set<int> titlesId;
  int count;
  String get statsKey =>
      "${filter.isForHokm ? "حكم " : ""}${filter.arabicName}";
  int get titleCount => titlesId.length;

  ZikrContentStats({
    required this.filter,
    this.count = 0,
  }) : titlesId = {};

  @override
  String toString() {
    return "[${filter.arabicName}]=> عدد: $count";
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_enum.dart';
import 'package:flutter/foundation.dart';

Future<void> viewStatistics() async {
  if (!kDebugMode) return;
  final allTitles = await azkarDBHelper.getAllTitles();
  final allContent = await azkarDBHelper.getAllContents();

  await viewContentsStatistics(allContent);
}

Future<void> viewContentsStatistics(List<Zikr> allContent) async {
  appPrint(allContent.length);
  appPrint("***********");

  const List<ZikrFilter> filters = ZikrFilter.values;
  final filterResult = {for (final f in filters) getKey(f): 0};

  for (final content in allContent) {
    for (final f in filters) {
      if (f.isForHokm) {
        final result = (content.hokm == f.nameInDatabase) ? 1 : 0;
        filterResult[getKey(f)] = result + (filterResult[getKey(f)] ?? 0);
      } else {
        final result = content.source.contains(f.nameInDatabase) ? 1 : 0;
        filterResult[getKey(f)] = result + (filterResult[getKey(f)] ?? 0);
      }
    }
  }

  // Convert map to a list of entries
  final entries = filterResult.entries.toList();

  // Sort the list of entries by value
  entries.sort((a, b) => b.value.compareTo(a.value));

  // Create a new map from the sorted list of entries
  final Map<String, int> sortedMap = Map.fromEntries(entries);

  for (final f in sortedMap.entries) {
    if (!f.key.contains("حكم")) {
      appPrint("${f.key}: ${f.value}");
    }
  }
  appPrint("***********");
  for (final f in sortedMap.entries) {
    if (f.key.contains("حكم")) {
      appPrint("${f.key.split(" ")[1]}: ${f.value}");
    }
  }
}

String getKey(ZikrFilter f) {
  return "${f.isForHokm ? "حكم " : ""}${f.arabicName}";
}



/*
contents: 1456
**********************
 سنن الترمذي: 660
 سنن أبي داود: 620
 مسند أحمد: 609
 صحيح مسلم: 474
 سنن ابن ماجه: 459
 صحيح البخاري: 367
 سنن النسائي: 334
 مسند الدارمي: 258
 أثر: 224
 عمل اليوم والليلة لابن السني: 182
 القرآن: 176
 موطأ مالك: 134
 سنن البيهقي: 19
 المستدرك على الصحيحين للحاكم النيسابوري: 13
 ************************
 حكم صحيح: 943
 حكم ضعيف: 221
 حكم أثر: 200
 حكم حسن: 79
 حكم موضوع: 14
*/

import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:flutter/material.dart';

class SearchBottomBar extends StatelessWidget {
  final Map<ZikrTitle, List<Zikr>> result;

  const SearchBottomBar({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final titleCount = result.length;
    final zikrCount = result.entries.fold(
      0,
      (previousValue, element) => previousValue + element.value.length,
    );

    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "عدد الفهارس: $titleCount",
          ),
          Text(
            "عدد الأذكار: $zikrCount",
          ),
        ],
      ),
    );
  }
}

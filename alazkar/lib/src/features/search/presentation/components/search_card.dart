// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/extension/extension_string.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/features/home/presentation/components/fehrs_item_card.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final String searchText;
  final ZikrTitle title;
  final List<Zikr> zikr;

  const SearchCard({
    super.key,
    required this.searchText,
    required this.title,
    required this.zikr,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FehrsItemCard(
        zikrTitle: title,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(right: 60),
        child: Column(
          children: [
            ...zikr.map((e) {
              final isAyah = e.body.contains("﴿");
              return Card(
                child: ListTile(
                  title: Text(
                    e.search.truncateTextAroundWordByWord(searchText, 7),
                    style: TextStyle(
                      fontFamily: isAyah ? "Uthmanic2" : "Kitab",
                      fontSize: 20,
                      height: 2,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

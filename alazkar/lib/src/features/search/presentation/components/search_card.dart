import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/features/home/presentation/components/fehrs_item_card.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final ZikrTitle title;
  final List<Zikr> zikr;

  const SearchCard({
    super.key,
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
              return Card(
                child: ListTile(
                  title: SelectableText(
                    e.body,
                    style: const TextStyle(
                      fontFamily: "Kitab",
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

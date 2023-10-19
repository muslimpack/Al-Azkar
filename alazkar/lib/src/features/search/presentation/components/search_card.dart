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
      subtitle: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.only(right: 60),
        children: [
          ...zikr.map((e) {
            return Card(
              child: ListTile(
                title: Text(e.body),
              ),
            );
          })
        ],
      ),
    );
  }
}

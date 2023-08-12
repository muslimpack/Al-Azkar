// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:alazkar/src/core/models/zikr_title.dart';

class FehrsScreen extends StatelessWidget {
  final List<ZikrTitle> titles;
  const FehrsScreen({super.key, required this.titles});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: titles.map(
          (e) {
            return FehrsItemCard(
              zikrTitle: e,
            );
          },
        ).toList(),
      ),
    );
  }
}

class FehrsItemCard extends StatelessWidget {
  final ZikrTitle zikrTitle;
  const FehrsItemCard({
    Key? key,
    required this.zikrTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 25),
                child: Text(zikrTitle.order.toString()),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_add_outlined,
            ),
          ),
        ],
      ),
      title: Text(zikrTitle.name),
      onTap: () {},
    );
  }
}

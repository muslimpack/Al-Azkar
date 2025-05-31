// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/extension/extension_string.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_extension.dart';
import 'package:flutter/material.dart';

class SearchContentCard extends StatelessWidget {
  final Zikr zikr;
  final String searchText;
  const SearchContentCard({
    super.key,
    required this.zikr,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    final isAyah = zikr.body.contains("﴿");

    return ListTile(
      isThreeLine: true,
      contentPadding: const EdgeInsets.all(10),
      leading: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 25),
            child: Text(zikr.id.toString()),
          ),
        ),
      ),
      subtitle: FutureBuilder(
        future: zikr.toPlainText(),
        builder: (context, snap) {
          if (!snap.hasData) return const LinearProgressIndicator();
          return ListTile(
            title: Text(
              (snap.data ?? "")
                  .removeDiacritics
                  .truncateTextAroundWordByWord(searchText, 7),
              style: TextStyle(
                fontFamily: isAyah ? "Uthmanic2" : "Kitab",
                fontSize: 25,
                height: 2,
              ),
            ),
          );
        },
      ),
      // subtitle: const Text(""),
      onTap: () {
        /// TODO: navigate to zikr viewer
        // Navigator.push(
        //   context,
        //   ZikrContentViewerScreen.route(zikrTitle: zikrTitle),
        // );
      },
    );
  }
}

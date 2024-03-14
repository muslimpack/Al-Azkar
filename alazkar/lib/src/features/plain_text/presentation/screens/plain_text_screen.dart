import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_extension.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/widgets/loading.dart';
import 'package:flutter/material.dart';

class PlainTextScreen extends StatefulWidget {
  const PlainTextScreen({super.key});

  @override
  State<PlainTextScreen> createState() => _PlainTextScreenState();
}

class _PlainTextScreenState extends State<PlainTextScreen> {
  bool isLoading = true;
  String text = "";
  StringBuffer sb = StringBuffer();
  @override
  void initState() {
    super.initState();
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });

    sb.clear();

    final Map<ZikrTitle, List<Zikr>> db = {};

    final titles = await azkarDBHelper.getAllTitles();
    db.addAll({for (final e in titles) e: <Zikr>[]});

    for (final title in titles) {
      final content = await azkarDBHelper.getContentByTitleId(title.id);
      db[title] = content;
    }

    for (final element in db.entries) {
      sb.writeln("================================");
      sb.writeln("${element.key.order}- ${element.key.name}");
      sb.writeln("================================");

      for (final zikr in element.value) {
        sb.writeln("************");
        sb.writeln("${zikr.order}");
        sb.writeln("************");
        sb.writeln(await zikr.toPlainText());
        sb.writeln("عدد المرات: ${zikr.count}");
        if (zikr.fadl.isNotEmpty) sb.writeln("الفضل: ${zikr.fadl}");
        if (zikr.source.isNotEmpty) sb.writeln("المصدر: ${zikr.source}");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plain Text"),
        actions: [
          IconButton(
            onPressed: () {
              getData();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Loading()
          : ListView(
              children: [
                SelectableText(sb.toString()),
              ],
            ),
    );
  }
}

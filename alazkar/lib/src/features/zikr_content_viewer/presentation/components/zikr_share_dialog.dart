// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/di/dependency_injection.dart';
import 'package:alazkar/src/core/extension/extension.dart';
import 'package:alazkar/src/core/extension/extension_string.dart';
import 'package:alazkar/src/core/helpers/azkar_helper.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_extension.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/core/utils/show_toast.dart';
import 'package:alazkar/src/features/settings/data/repository/settings_storage.dart';
import 'package:alazkar/src/features/share_as_image/presentation/screens/share_as_image_screen.dart';
import 'package:alazkar/src/features/zikr_content_viewer/data/repository/zikr_viewer_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ZikrShareDialog extends StatefulWidget {
  final int zikrId;
  const ZikrShareDialog({
    super.key,
    required this.zikrId,
  });

  @override
  State<ZikrShareDialog> createState() => _ZikrShareDialogState();
}

class _ZikrShareDialogState extends State<ZikrShareDialog> {
  late final Zikr zikr;
  String shareText = '';
  bool shareFadl = false;
  bool shareSource = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future _load() async {
    zikr = await sl<AzkarDBHelper>().getContentById(widget.zikrId);

    shareFadl = sl<ZikrViewerRepo>().shareFadl;
    shareSource = sl<ZikrViewerRepo>().shareSource;

    isLoading = false;
    _buildSharedText();
  }

  Future _buildSharedText() async {
    shareText = await sharedText();
    setState(() {});
  }

  Future<String> sharedText() async {
    final StringBuffer sb = StringBuffer();
    final content = (await zikr.getTextSpan()).map((e) => e.toPlainText()).join("\n");
    final proccessedText =
        sl<SettingsStorage>().showTextInBrackets() ? content : content.removeTextInBrackets;

    //TDOD remove after database update
    sb.writeln(
      "${proccessedText.replaceAll("، ،", "،").replaceAll("  ", " ")}\n",
    );
    sb.writeln("🔢عدد المرات: ${zikr.count}");
    if (shareFadl && zikr.fadl.isNotEmpty) {
      sb.writeln();
      sb.writeln("🏆الفضل: ${zikr.fadl}");
    }
    if (shareSource && zikr.source.isNotEmpty) {
      sb.writeln();
      sb.writeln("📚المصدر:\n${zikr.source}");
    }
    sb.writeln();
    sb.writeln("#الأذكار_النووية");
    return sb.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200),
      child: AlertDialog(
        scrollable: true,
        title: const Text("مشاركة الذكر"),
        content: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 350),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          shareText,
                          style: const TextStyle(
                            fontFamily: "Kitab",
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      ChoiceChip(
                        selected: shareFadl,
                        label: const Text("مشاركة الفضل"),
                        onSelected: (value) async {
                          shareFadl = value;
                          await sl<ZikrViewerRepo>().toggleShareFadl(value);
                          _buildSharedText();
                        },
                      ),
                      ChoiceChip(
                        selected: shareSource,
                        label: const Text("مشاركة المصدر"),
                        onSelected: (value) async {
                          shareSource = value;
                          await sl<ZikrViewerRepo>().toggleShareSource(value);
                          _buildSharedText();
                        },
                      ),
                    ],
                  ),
                ],
              ),
        actions: [
          IconButton(
            tooltip: "مشاركة كصورة",
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: () async {
              final ZikrTitle zikrTitle = await sl<AzkarDBHelper>().getTitlesById(zikr.titleId);
              if (!context.mounted) return;
              context.push(
                ShareAsImageScreen(
                  zikr: zikr,
                  zikrTitle: zikrTitle,
                ),
              );
            },
          ),
          IconButton(
            tooltip: "نسخ",
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: shareText),
              );
              showToast("تم النسخ للحافظة");
            },
          ),
          Builder(builder: (context) {
            return IconButton(
              tooltip: "مشاركة",
              icon: const Icon(Icons.share),
              onPressed: () async {
                try {
                  final box = context.findRenderObject()! as RenderBox;
                  await SharePlus.instance.share(
                    ShareParams(
                      text: shareText,
                      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
                    ),
                  );
                } catch (e) {
                  appPrint(e);
                }
              },
            );
          }),
        ],
      ),
    );
  }
}

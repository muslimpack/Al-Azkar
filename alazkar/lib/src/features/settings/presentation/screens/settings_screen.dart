import 'package:alazkar/src/features/about/presentation/screens/about_screen.dart';
import 'package:alazkar/src/features/settings/presentation/components/praise_with_volume_switch.dart';
import 'package:alazkar/src/features/settings/presentation/components/show_text_in_bracket_switch.dart';
import 'package:alazkar/src/features/theme/presentation/screens/theme_screen.dart';
import 'package:alazkar/src/features/zikr_source_filter/presentation/screens/select_zikr_hokm_screen.dart';
import 'package:alazkar/src/features/zikr_source_filter/presentation/screens/select_zikr_source_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الإعدادات"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text("مظهر التطبيق"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ThemeScreen();
                  },
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text("اختيار مصدر الأذكار"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ZikrSourceFilterScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text("اختيار حكم الأذكار"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const ZikrHokmFilterScreen();
                  },
                ),
              );
            },
          ),
          const Divider(),
          const ShowTextInBracketsSwitch(),
          const PraiseWithVolumeSwitch(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("عنا"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const AboutScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

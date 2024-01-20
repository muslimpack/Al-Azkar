import 'package:alazkar/src/core/constants/const.dart';
import 'package:alazkar/src/core/utils/open_url.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const String routeName = "/about";

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AboutScreen(),
    );
  }

  const AboutScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "عن التطبيق",
          style: TextStyle(fontFamily: "Uthmanic"),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 15),
          ListTile(
            leading: Image.asset(
              "assets/icons/app.png",
            ),
            title: Text("تطبيق الأذكار النووية الإصدار $appVersion"),
            subtitle: const Text("تطبيق مجاني خالي من الإعلانات ومفتوح المصدر"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.handshake),
            title: Text("نسألكم الدعاء لنا ولوالدينا"),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.source_outlined),
            title: Text("المصدر"),
            isThreeLine: true,
            subtitle: Text("""
الكتاب: حلية الأبرار وشعار الأخيار في تلخيص الدعوات والأذكار المستحبة في الليل والنهار
المعروف بـ: الأذكار النواوية
المؤلف: أبو زكريا، يحيى بن شرف النواوي (٦٣١ - ٦٧٦ هـ)
من طبعتين مختلفتين

1-
الناشر: الجفان والجابي للطباعة والنشر - دار ابن حزم للطباعة والنشر
بعناية: بَسّام عبد الوهّاب الجابي [ت ١٤٣٨ هـ]
الطبعة: الطبعة الأولى ١٤٢٥ هـ- ٢٠٠٤ م

2-
الناشر: دار المنهاج
 المحقق: صلاح الدين محمد محمود الحمصي - عبد اللطيف أحمد عبد اللطيف - محمد محمد طاهر شعبان - محمد غسان نصوح عزقول
طبع على نفقة الشيخ: إسماعيل جمال الحريري
 سنة النشر: 1425 - 2005
"""),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.open_in_browser),
            title: const Text("رابط المشروع المفتوح المصدر"),
            onTap: () {
              openURL("https://github.com/muslimpack/Al-Azkar");
            },
          ),
        ],
      ),
    );
  }
}

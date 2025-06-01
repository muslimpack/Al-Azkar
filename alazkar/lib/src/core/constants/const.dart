import 'package:alazkar/src/core/extension/extension_platform.dart';

final String appVersion = [
  "1.0.0",
  "0.9.0",
  "0.8.0",
  "0.7.0",
  "0.6.0",
  "0.5.0",
  "0.4.0",
  "0.3.0",
  "0.2.0",
  "0.1.0",
].first;

const String kEstaaza =
    "أَعُوذُ بِاللَّهِ (السَّمِيعِ الْعَلِيمِ) مِنَ الشَّيْطَانِ الرَّجِيمِ (مِنْ هَمْزِهِ وَنَفْخِهِ وَنَفْثِهِ)";
const String kArBasmallah = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ";
const Iterable<int> kArabicDiacriticsChar = [
  1617,
  124,
  1614,
  124,
  1611,
  124,
  1615,
  124,
  1612,
  124,
  1616,
  124,
  1613,
  124,
  1618,
];

String kGetStorageName =
    PlatformExtension.isDesktop ? "alazkar_storage" : "GetStorage";

const double kFontChangeBy = 2;
const double kFontDefault = 30;
const double kFontMin = 15;
const double kFontMax = 45;

const String kDeveloperEmail = "muslimpack.org@gmail.com";

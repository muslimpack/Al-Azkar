import 'package:get_storage/get_storage.dart';

class SettingsStorage {
  static final box = GetStorage();

  static const String _settingsPrefixNameKey = "SettingsStorage";

  /// Titles Freq filters
  static const String _showTextInBrackets =
      "${_settingsPrefixNameKey}showTextInBrackets";

  /// Filters for zikr source
  static bool showTextInBrackets() {
    final bool? data = box.read(_showTextInBrackets);

    return data ?? true;
  }

  /// Filters for zikr source
  static Future setShowTextInBrackets(bool showTextInBrackets) async {
    return box.write(_showTextInBrackets, showTextInBrackets);
  }
}

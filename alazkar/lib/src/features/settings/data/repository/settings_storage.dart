import 'package:get_storage/get_storage.dart';

class SettingsStorage {
  final GetStorage _box;
  SettingsStorage(this._box);

  static const String _settingsPrefixNameKey = "SettingsStorage";

  /// showTextInBrackets
  static const String _showTextInBrackets =
      "${_settingsPrefixNameKey}showTextInBrackets";

  bool showTextInBrackets() {
    final bool? data = _box.read(_showTextInBrackets);

    return data ?? true;
  }

  Future setShowTextInBrackets(bool showTextInBrackets) async {
    return _box.write(_showTextInBrackets, showTextInBrackets);
  }
}

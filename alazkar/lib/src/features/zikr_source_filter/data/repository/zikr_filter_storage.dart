import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_enum.dart';
import 'package:get_storage/get_storage.dart';

class ZikrFilterStorage {
  static final box = GetStorage();

  static const String filterPrefixName = "ZikrSourceFilter";
  static bool getFilterStatus(ZikrFilter zikrFilter) {
    final bool? data = box.read(_getZikrFilterKey(zikrFilter));
    return data ?? true;
  }

  static Future setFilterStatus(Filter filter) async {
    return box.write(_getZikrFilterKey(filter.filter), filter.isActivated);
  }

  static String _getZikrFilterKey(ZikrFilter filter) {
    return "filterPrefixName${filter.name}";
  }
}

import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_enum.dart';
import 'package:get_storage/get_storage.dart';

class ZikrFilterStorage {
  static final box = GetStorage();

  static List<Filter> getAllFilters() {
    return ZikrFilter.values
        .map((e) => Filter(filter: e, isActivated: getFilterStatus(e)))
        .toList();
  }

  static const String _filterPrefixNameKey = "ZikrFilterStorage";

  static const String _enableFiltersKey =
      "${_filterPrefixNameKey}enableFilters";

  static bool getEnableFiltersStatus() {
    final bool? data = box.read(_enableFiltersKey);
    return data ?? false;
  }

  static Future setEnableFiltersStatus(bool activateFilters) async {
    return box.write(_enableFiltersKey, activateFilters);
  }

  static bool getFilterStatus(ZikrFilter zikrFilter) {
    final bool? data = box.read(_getZikrFilterKey(zikrFilter));
    return data ?? true;
  }

  static Future setFilterStatus(Filter filter) async {
    return box.write(_getZikrFilterKey(filter.filter), filter.isActivated);
  }

  static String _getZikrFilterKey(ZikrFilter filter) {
    return "$_filterPrefixNameKey${filter.name}";
  }
}

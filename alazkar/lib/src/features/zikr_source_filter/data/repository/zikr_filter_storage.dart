import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/features/home/data/models/titles_freq_enum.dart';
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

  /// Filters for zikr source
  static bool getEnableFiltersStatus() {
    final bool? data = box.read(_enableFiltersKey);
    return data ?? false;
  }

  /// Filters for zikr source
  static Future setEnableFiltersStatus(bool activateFilters) async {
    return box.write(_enableFiltersKey, activateFilters);
  }

  static const String _enableHokmFiltersKey =
      "${_filterPrefixNameKey}enableHokmFilters";

  /// Filters for zikr Hokm
  static bool getEnableHokmFiltersStatus() {
    final bool? data = box.read(_enableHokmFiltersKey);
    return data ?? false;
  }

  /// Filters for zikr Hokm
  static Future setEnableHokmFiltersStatus(bool activateFilters) async {
    return box.write(_enableHokmFiltersKey, activateFilters);
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

  /// Titles Freq filters
  static const String _titlesFreqFilter =
      "${_filterPrefixNameKey}titlesFreqFilter";

  /// Filters for zikr source
  static List<TitlesFreqEnum> getTitlesFreqFilterStatus() {
    final String? data = box.read(_titlesFreqFilter);
    appPrint("FreqFilter: $data");

    final List<TitlesFreqEnum> result = List.of([]);
    if (data != null && data.isNotEmpty) {
      result.addAll(result.toEnumList(data));
    } else {
      result.addAll(TitlesFreqEnum.values);
    }

    return result;
  }

  /// Filters for zikr source
  static Future setTitlesFreqFilterStatus(List<TitlesFreqEnum> freqList) async {
    return box.write(_titlesFreqFilter, freqList.toJson());
  }
}

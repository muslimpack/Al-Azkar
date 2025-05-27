import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/features/home/data/models/titles_freq_enum.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_enum.dart';
import 'package:get_storage/get_storage.dart';

class ZikrFilterStorage {
  final GetStorage box;

  ZikrFilterStorage(this.box);

  List<Filter> getAllFilters() {
    return ZikrFilter.values
        .map((e) => Filter(filter: e, isActivated: getFilterStatus(e)))
        .toList();
  }

  static const String _filterPrefixNameKey = "ZikrFilterStorage";

  static const String _enableFiltersKey =
      "${_filterPrefixNameKey}enableFilters";

  /// Filters for zikr source
  bool getEnableFiltersStatus() {
    final bool? data = box.read(_enableFiltersKey);
    return data ?? false;
  }

  /// Filters for zikr source
  Future setEnableFiltersStatus(bool activateFilters) {
    return box.write(_enableFiltersKey, activateFilters);
  }

  static const String _enableHokmFiltersKey =
      "${_filterPrefixNameKey}enableHokmFilters";

  /// Filters for zikr Hokm
  bool getEnableHokmFiltersStatus() {
    final bool? data = box.read(_enableHokmFiltersKey);
    return data ?? false;
  }

  /// Filters for zikr Hokm
  Future setEnableHokmFiltersStatus(bool activateFilters) {
    return box.write(_enableHokmFiltersKey, activateFilters);
  }

  bool getFilterStatus(ZikrFilter zikrFilter) {
    final bool? data = box.read(_getZikrFilterKey(zikrFilter));
    return data ?? true;
  }

  Future setFilterStatus(Filter filter) {
    return box.write(_getZikrFilterKey(filter.filter), filter.isActivated);
  }

  static String _getZikrFilterKey(ZikrFilter filter) {
    return "$_filterPrefixNameKey${filter.name}";
  }

  /// Titles Freq filters
  static const String _titlesFreqFilter =
      "${_filterPrefixNameKey}titlesFreqFilter";

  /// Filters for zikr source
  List<TitlesFreqEnum> getTitlesFreqFilterStatus() {
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
  Future setTitlesFreqFilterStatus(List<TitlesFreqEnum> freqList) {
    return box.write(_titlesFreqFilter, freqList.toJson());
  }
}

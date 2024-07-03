import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_enum.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/repository/zikr_filter_storage.dart';

extension FilterListExt on List<Filter> {
  List<Zikr> getFilteredZikr(List<Zikr> azkar) {
    final filterBySource = ZikrFilterStorage.getEnableFiltersStatus();
    final filterByHokm = ZikrFilterStorage.getEnableHokmFiltersStatus();

    if (!filterBySource && !filterByHokm) {
      return azkar;
    }

    final List<Filter> filters = ZikrFilterStorage.getAllFilters();

    return azkar.where((zikr) {
      if (filterBySource && !filters.validateSource(zikr.source)) {
        return false;
      }
      if (filterByHokm && !filters.validateHokm(zikr.hokm)) {
        return false;
      }
      return true;
    }).toList();
  }

  bool validateSource(String source) {
    bool isValid = false;

    for (final e in this) {
      if (!e.isActivated || e.filter.isForHokm) continue;

      isValid = source.contains(e.filter.nameInDatabase);

      if (isValid) break;
    }

    return isValid;
  }

  bool validateHokm(String hokm) {
    bool isValid = false;

    for (final e in this) {
      if (!e.isActivated || !e.filter.isForHokm) continue;

      isValid = hokm == e.filter.nameInDatabase;

      if (isValid) break;
    }

    return isValid;
  }
}

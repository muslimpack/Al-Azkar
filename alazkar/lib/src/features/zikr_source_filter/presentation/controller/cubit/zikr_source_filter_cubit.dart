import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/repository/zikr_filter_storage.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'zikr_source_filter_state.dart';

class ZikrSourceFilterCubit extends Cubit<ZikrSourceFilterState> {
  ZikrSourceFilterCubit()
      : super(
          const ZikrSourceFilterState(
            filters: [],
            enableFilters: false,
          ),
        );

  void start() {
    final List<Filter> filters = ZikrFilterStorage.getAllFilters();

    emit(
      ZikrSourceFilterState(
        filters: filters,
        enableFilters: ZikrFilterStorage.getEnableFiltersStatus(),
      ),
    );
  }

  Future toggleEnableFilters(bool enableFilters) async {
    ZikrFilterStorage.setEnableFiltersStatus(enableFilters);

    emit(state.copyWith(enableFilters: enableFilters));
  }

  Future toggleFilter(Filter filter) async {
    final newFilter = filter.copyWith(isActivated: !filter.isActivated);
    await ZikrFilterStorage.setFilterStatus(newFilter);

    final newList = List.of(state.filters).map((e) {
      if (e.filter == newFilter.filter) return newFilter;
      return e;
    }).toList();

    emit(state.copyWith(filters: newList));
  }
}

part of 'zikr_source_filter_cubit.dart';

class ZikrSourceFilterState extends Equatable {
  final List<Filter> filters;
  final bool enableFilters;

  const ZikrSourceFilterState({
    required this.filters,
    required this.enableFilters,
  });

  @override
  List<Object> get props => [filters, enableFilters];

  ZikrSourceFilterState copyWith({
    List<Filter>? filters,
    bool? enableFilters,
  }) {
    return ZikrSourceFilterState(
      filters: filters ?? this.filters,
      enableFilters: enableFilters ?? this.enableFilters,
    );
  }
}

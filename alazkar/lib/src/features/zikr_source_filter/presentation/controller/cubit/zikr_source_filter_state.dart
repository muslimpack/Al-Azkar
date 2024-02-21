// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'zikr_source_filter_cubit.dart';

class ZikrSourceFilterState extends Equatable {
  final List<Filter> filters;

  const ZikrSourceFilterState({required this.filters});

  @override
  List<Object> get props => [filters];

  ZikrSourceFilterState copyWith({
    List<Filter>? filters,
  }) {
    return ZikrSourceFilterState(
      filters: filters ?? this.filters,
    );
  }
}

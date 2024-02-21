// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/features/zikr_source_filter/data/models/zikr_filter_enum.dart';
import 'package:equatable/equatable.dart';

class Filter extends Equatable {
  final ZikrFilter filter;
  final bool isActivated;

  const Filter({
    required this.filter,
    required this.isActivated,
  });

  Filter copyWith({
    ZikrFilter? filter,
    bool? isActivated,
  }) {
    return Filter(
      filter: filter ?? this.filter,
      isActivated: isActivated ?? this.isActivated,
    );
  }

  @override
  List<Object> get props => [filter, isActivated];
}

extension FilterListExt on List<Filter> {
  bool validate(String text) {
    appPrint(text);
    bool isValid = false;

    for (final e in this) {
      if (!e.isActivated) continue;
      isValid = text.contains(e.filter.nameInDatabase);
      if (isValid) break;
    }

    return isValid;
  }
}

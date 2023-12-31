import 'dart:convert';

import 'package:equatable/equatable.dart';

class ZikrTitle extends Equatable {
  final int id;
  final int order;
  final String name;
  final bool? isBookmarked;
  const ZikrTitle({
    required this.id,
    required this.order,
    required this.name,
    this.isBookmarked,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order': order,
      'name': name,
    };
  }

  factory ZikrTitle.fromMap(Map<String, dynamic> map) {
    return ZikrTitle(
      id: map['id'] as int,
      order: map['order'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZikrTitle.fromJson(String source) =>
      ZikrTitle.fromMap(json.decode(source) as Map<String, dynamic>);

  ZikrTitle copyWith({
    int? id,
    int? order,
    String? name,
    bool? isBookmarked,
  }) {
    return ZikrTitle(
      id: id ?? this.id,
      order: order ?? this.order,
      name: name ?? this.name,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [id, order, name, isBookmarked];
}

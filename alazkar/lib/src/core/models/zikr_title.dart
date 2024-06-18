// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ZikrTitle extends Equatable {
  final int id;
  final int order;
  final String name;
  final String freq;
  final bool? isBookmarked;
  const ZikrTitle({
    required this.id,
    required this.order,
    required this.name,
    required this.freq,
    this.isBookmarked,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order': order,
      'name': name,
      'freq': freq,
    };
  }

  factory ZikrTitle.fromMap(Map<String, dynamic> map) {
    return ZikrTitle(
      id: map['id'] as int,
      order: map['order'] as int,
      name: map['name'] as String,
      freq: map['freq'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ZikrTitle.fromJson(String source) =>
      ZikrTitle.fromMap(json.decode(source) as Map<String, dynamic>);

  ZikrTitle copyWith({
    int? id,
    int? order,
    String? name,
    String? freq,
    bool? isBookmarked,
  }) {
    return ZikrTitle(
      id: id ?? this.id,
      order: order ?? this.order,
      name: name ?? this.name,
      freq: freq ?? this.freq,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [id, order, name, freq, isBookmarked];
}

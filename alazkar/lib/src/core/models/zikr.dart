// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Zikr extends Equatable {
  final int id;
  final int titleId;
  final int order;
  final String body;
  final String source;
  final String fadl;
  final String hokm;
  final int count;
  final String search;
  const Zikr({
    required this.id,
    required this.titleId,
    required this.order,
    required this.body,
    required this.source,
    required this.fadl,
    required this.hokm,
    required this.count,
    required this.search,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'titleId': titleId,
      'order': order,
      'body': body,
      'source': source,
      'fadl': fadl,
      'hokm': hokm,
      'count': count,
      'search': search,
    };
  }

  factory Zikr.fromMap(Map<String, dynamic> map) {
    return Zikr(
      id: map['id'] as int,
      titleId: map['titleId'] as int,
      order: map['order'] as int,
      body: map['body'] as String,
      search: (map['search'] as String?) ?? "",
      source: (map['source'] as String?) ?? "",
      fadl: (map['fadl'] as String?) ?? "",
      hokm: map['hokm'] as String,
      count: map['count'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Zikr.fromJson(String source) =>
      Zikr.fromMap(json.decode(source) as Map<String, dynamic>);

  Zikr copyWith({
    int? id,
    int? titleId,
    int? order,
    String? body,
    String? source,
    String? fadl,
    String? hokm,
    int? count,
    String? search,
  }) {
    return Zikr(
      id: id ?? this.id,
      titleId: titleId ?? this.titleId,
      order: order ?? this.order,
      body: body ?? this.body,
      source: source ?? this.source,
      fadl: fadl ?? this.fadl,
      hokm: hokm ?? this.hokm,
      count: count ?? this.count,
      search: search ?? this.search,
    );
  }

  @override
  List<Object> get props =>
      [id, titleId, order, body, source, fadl, hokm, count, search];
}

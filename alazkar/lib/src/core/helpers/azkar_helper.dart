import 'dart:async';

import 'package:alazkar/src/core/helpers/db_helper.dart';
import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_extension.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/features/search/data/models/search_type.dart';
import 'package:alazkar/src/features/search/data/models/sql_query.dart';
import 'package:sqflite/sqflite.dart';

class AzkarDBHelper {
  /* ************* Variables ************* */

  static const String dbName = "Al-Azkar.db";
  static const int dbVersion = 13;

  /* ************* Singleton Constructor ************* */

  static AzkarDBHelper? _instance;
  static Database? _database;
  static late final DBHelper _dbHelper;

  factory AzkarDBHelper() {
    _dbHelper = DBHelper(dbName: dbName, dbVersion: dbVersion);
    _instance ??= AzkarDBHelper._createInstance();
    return _instance!;
  }

  AzkarDBHelper._createInstance();

  Future<Database> get database async {
    _database ??= await _dbHelper.initDatabase();
    return _database!;
  }

  Future<void> init() async {
    // Ensure the database is initialized
    await database;
  }

  /* ************* | ************* */

  Future<List<ZikrTitle>> getAllTitles() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM titles ORDER BY `order` ASC');

    return List.generate(maps.length, (i) {
      return ZikrTitle.fromMap(maps[i]);
    });
  }

  Future<List<ZikrTitle>> getTitlesByName(String name) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM titles WHERE name LIKE ? ORDER BY `order` ASC',
      ['%$name%'],
    );

    return List.generate(maps.length, (i) {
      return ZikrTitle.fromMap(maps[i]);
    });
  }

  Future<ZikrTitle> getTitlesById(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM titles WHERE id = ? ',
      [id],
    );

    return List.generate(maps.length, (i) {
      return ZikrTitle.fromMap(maps[i]);
    }).first;
  }

  Future<List<Zikr>> getAllContents() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM contents ORDER BY `order` ASC');

    return flattenZikrBodyText(
      List.generate(maps.length, (i) {
        return Zikr.fromMap(maps[i]);
      }),
    );
  }

  Future<List<Zikr>> getContentsByName(String name) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM contents WHERE search LIKE ? ORDER BY `order` ASC',
      ['%$name%'],
    );

    return flattenZikrBodyText(
      List.generate(maps.length, (i) {
        return Zikr.fromMap(maps[i]);
      }),
    );
  }

  Future<List<Zikr>> getContentByTitleId(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM contents WHERE titleId = ? ORDER BY `order` ASC',
      [id],
    );

    return flattenZikrBodyText(
      List.generate(maps.length, (i) {
        return Zikr.fromMap(maps[i]);
      }),
    );
  }

  Future<List<Zikr>> flattenZikrBodyText(List<Zikr> contents) {
    return Future.wait(
      contents
          .map((e) async => e.copyWith(body: await e.toPlainText()))
          .toList(),
    );
  }

  Future<Zikr> getContentById(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM contents WHERE id = ? ORDER BY `order` ASC',
      [id],
    );

    return (await flattenZikrBodyText(
      List.generate(maps.length, (i) {
        return Zikr.fromMap(maps[i]);
      }),
    ))
        .first;
  }

  ///New Search

  SqlQuery _searchTitlesSearchType(
    String searchText,
    String property, {
    required SearchType searchType,
    required bool useFilters,
  }) {
    final SqlQuery sqlQuery = SqlQuery();

    final List<String> splittedSearchWords = searchText.trim().split(' ');

    switch (searchType) {
      case SearchType.typical:
        sqlQuery.query = 'WHERE $property LIKE ?';
        sqlQuery.args.addAll(['%$searchText%']);

      case SearchType.allWords:
        final String allWordsQuery =
            splittedSearchWords.map((word) => '$property LIKE ?').join(' AND ');
        final List<String> params =
            splittedSearchWords.map((word) => '%$word%').toList();
        sqlQuery.query = 'WHERE ($allWordsQuery)';
        sqlQuery.args.addAll([...params]);

      case SearchType.anyWords:
        final String allWordsQuery =
            splittedSearchWords.map((word) => '$property LIKE ?').join(' OR ');
        final List<String> params =
            splittedSearchWords.map((word) => '%$word%').toList();
        sqlQuery.query = 'WHERE ($allWordsQuery)';
        sqlQuery.args.addAll([...params]);
    }

    return sqlQuery;
  }

  Future<(int, List<ZikrTitle>)> searchTitleByName({
    required String searchText,
    required SearchType searchType,
    required int limit,
    required int offset,
  }) async {
    if (searchText.isEmpty) return (0, <ZikrTitle>[]);

    final Database db = await database;

    final whereFilters = _searchTitlesSearchType(
      searchText,
      "name",
      searchType: searchType,
      useFilters: true,
    );

    /// Pagination
    final String qurey =
        '''SELECT * FROM titles ${whereFilters.query} LIMIT ? OFFSET ?''';

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      qurey,
      [...whereFilters.args, limit, offset],
    );

    /// Total Count
    final String totalCountQurey =
        '''SELECT COUNT(*) as count FROM titles ${whereFilters.query} ''';
    final List<Map<String, dynamic>> countResult =
        await db.rawQuery(totalCountQurey, [...whereFilters.args]);
    final int count = countResult.first["count"] as int? ?? 0;

    final itemList = List.generate(maps.length, (i) {
      return ZikrTitle.fromMap(maps[i]);
    });

    return (count, itemList);
  }

  Future<(int, List<Zikr>)> searchContent({
    required String searchText,
    required SearchType searchType,
    required int limit,
    required int offset,
  }) async {
    if (searchText.isEmpty) return (0, <Zikr>[]);

    final Database db = await database;

    final whereFilters = _searchTitlesSearchType(
      searchText,
      "search",
      searchType: searchType,
      useFilters: true,
    );

    /// Pagination
    final String qurey =
        '''SELECT * FROM contents ${whereFilters.query} LIMIT ? OFFSET ?''';

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      qurey,
      [...whereFilters.args, limit, offset],
    );

    /// Total Count
    final String totalCountQurey =
        '''SELECT COUNT(*) as count FROM contents ${whereFilters.query} ''';
    final List<Map<String, dynamic>> countResult =
        await db.rawQuery(totalCountQurey, [...whereFilters.args]);
    final int count = countResult.first["count"] as int? ?? 0;

    final itemList = List.generate(maps.length, (i) {
      return Zikr.fromMap(maps[i]);
    });

    return (count, itemList);
  }

  /// Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}

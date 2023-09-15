import 'dart:async';
import 'dart:io';

import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

BookmarksDBHelper bookmarksDBHelper = BookmarksDBHelper();

class BookmarksDBHelper {
  /* ************* Variables ************* */

  static const String dbName = "Bookmarks.db";
  static const int dbVersion = 1;

  /* ************* Singleton Constructor ************* */

  static BookmarksDBHelper? _databaseHelper;
  static Database? _database;

  factory BookmarksDBHelper() {
    _databaseHelper ??= BookmarksDBHelper._createInstance();
    return _databaseHelper!;
  }

  BookmarksDBHelper._createInstance();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /* ************* Database Creation ************* */

  // init
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    final exist = await databaseExists(path);

    //Check if database is already in that Directory
    if (!exist) {
      // Database isn't exist > Create new Database
      await _copyFromAssets(path: path);
    }

    return openDatabase(
      path,
      version: dbVersion,
    );
  }

  Future<void> _copyFromAssets({
    required String path,
  }) async {
    //
    try {
      await Directory(dirname(path)).create(recursive: true);

      final ByteData data = await rootBundle.load(join("assets", "db", dbName));
      final List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } catch (e) {
      appPrint(e.toString());
    }
  }

  /* ************* Functions ************* */

  Future<List<int>> getAllFavoriteTitles() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''SELECT * from favourite_titles order by titleId asc''',
    );

    return List.generate(maps.length, (i) {
      return maps[i]["titleId"] as int;
    });
  }

  /// Add title to favourite
  Future<void> addTitleToFavourite({
    required int titleId,
  }) async {
    final db = await database;
    await db.rawInsert(
      'INSERT INTO favourite_titles( titleId) VALUES(?)',
      [titleId],
    );
  }

  Future<void> deleteTitleFromFavourite({
    required int titleId,
  }) async {
    final db = await database;

    await db
        .rawDelete("DELETE FROM favourite_titles WHERE titleId = ?", [titleId]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

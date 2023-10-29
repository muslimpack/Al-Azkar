import 'dart:async';
import 'dart:io';

import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
    late final String path;
    if (Platform.isWindows) {
      final dbPath = (await getApplicationSupportDirectory()).path;
      path = join(dbPath, dbName);
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, dbName);
    }

    final exist = await databaseExists(path);
    appPrint("$exist: $path");

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

  Future<void> _copyFromAssets({required String path}) async {
    try {
      final String dbAssetPath = join("assets", "db", dbName);
      if (Platform.isWindows) {
        appPrint("Azkar Try copy for windows");
        try {
          await File(dbAssetPath).copy(path);
        } catch (e) {
          appPrint(e);
        }
      } else {
        Directory(dirname(path)).createSync(recursive: true);

        final ByteData data = await rootBundle.load(dbAssetPath);
        final List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        File(path).writeAsBytesSync(bytes, flush: true);
      }
    } catch (e) {
      appPrint(e);
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

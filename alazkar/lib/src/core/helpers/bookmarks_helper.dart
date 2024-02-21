import 'dart:async';
import 'dart:io';

import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

BookmarksDBHelper bookmarksDBHelper = BookmarksDBHelper();

class BookmarksDBHelper {
  /* ************* Variables ************* */

  static const String dbName = "Bookmarks.db";
  static const int dbVersion = 2;

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

    return openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreateDatabase,
      onUpgrade: _onUpgradeDatabase,
      onDowngrade: _onDowngradeDatabase,
    );
  }

  /// On create database
  FutureOr<void> _onCreateDatabase(Database db, int version) async {
    appPrint("Create Bookmarks.db");

    /// Create favourite_contents table
    await db.execute('''
    CREATE TABLE "favourite_contents" (
      "id"	INTEGER NOT NULL UNIQUE,
      "contentId"	INTEGER NOT NULL UNIQUE,
      PRIMARY KEY("id" AUTOINCREMENT)
    );
    ''');

    /// Create favourite_titles table
    await db.execute('''
    CREATE TABLE "favourite_titles" (
      "id"	INTEGER NOT NULL UNIQUE,
      "titleId"	INTEGER NOT NULL UNIQUE,
      PRIMARY KEY("id" AUTOINCREMENT)
    );
    ''');

    ///
    await addDefaultTitles(db);
  }

  /// default favourite titles
  Future addDefaultTitles(Database db) async {
    await db.execute('''
    INSERT OR IGNORE INTO favourite_titles(titleId) VALUES
    (2),     --  أذكار الاستيقاظ
    (84),    --  أذكار بعد السلام الصلاة
    (89),    --  الصباح
    (94),    --  المساء
    (99),    --  النوم
    (191),   --  السفر
    (254);   --  دخول السوق
    ''');
  }

  /// On upgrade database version
  FutureOr<void> _onUpgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await addDefaultTitles(db);
    }
  }

  /// On downgrade database version
  FutureOr<void> _onDowngradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) {}

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
      'INSERT OR IGNORE INTO favourite_titles( titleId) VALUES(?)',
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

import 'dart:async';
import 'dart:io';

import 'package:alazkar/src/core/models/zikr.dart';
import 'package:alazkar/src/core/models/zikr_title.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

AzkarDBHelper azkarDBHelper = AzkarDBHelper();

class AzkarDBHelper {
  /* ************* Variables ************* */

  static const String dbName = "Al-Azkar.db";
  static const int dbVersion = 3;

  /* ************* Singleton Constructor ************* */

  static AzkarDBHelper? _instance;
  static Database? _database;

  factory AzkarDBHelper() {
    _instance ??= AzkarDBHelper._createInstance();
    return _instance!;
  }

  AzkarDBHelper._createInstance();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /* ************* Database Creation ************* */

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
      appPrint("Azkar not exist");
      // Database isn't exist > Create new Database
      await _copyFromAssets(path: path);
    }

    Database database = await openDatabase(path);

    await database.getVersion().then((currentVersion) async {
      if (currentVersion < dbVersion) {
        appPrint("[DB] New Version Detected");
        database.close();

        //delete the old database so you can copy the new one
        await deleteDatabase(path);

        // Database isn't exist > Create new Database
        await _copyFromAssets(path: path);
      }
    });

    return database = await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreateDatabase,
      onUpgrade: _onUpgradeDatabase,
      onDowngrade: _onDowngradeDatabase,
    );
  }

  FutureOr<void> _onCreateDatabase(Database db, int version) async {}

  FutureOr<void> _onUpgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) {}

  FutureOr<void> _onDowngradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) {}

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

  Future<List<ZikrTitle>> getAllTitles() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('titles');

    return List.generate(maps.length, (i) {
      return ZikrTitle.fromMap(maps[i]);
    });
  }

  Future<List<ZikrTitle>> getTitlesByName(String name) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM titles WHERE name LIKE ?', ['%$name%']);

    return List.generate(maps.length, (i) {
      return ZikrTitle.fromMap(maps[i]);
    });
  }

  Future<List<Zikr>> getContentsByName(String name) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db
        .rawQuery('SELECT * FROM contents WHERE search LIKE ?', ['%$name%']);

    return List.generate(maps.length, (i) {
      return Zikr.fromMap(maps[i]);
    });
  }

  Future<List<Zikr>> getContentByTitleId(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM contents WHERE titleId = ?', [id]);

    return List.generate(maps.length, (i) {
      return Zikr.fromMap(maps[i]);
    });
  }

  Future<Zikr> getContentById(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM contents WHERE id = ?', [id]);

    return List.generate(maps.length, (i) {
      return Zikr.fromMap(maps[i]);
    }).first;
  }

  /// Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}

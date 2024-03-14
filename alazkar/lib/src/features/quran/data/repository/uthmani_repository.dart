import 'dart:async';
import 'dart:io';

import 'package:alazkar/src/core/extension/extension_object.dart';
import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:alazkar/src/features/quran/data/models/verse_model.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

UthmaniRepository uthmaniRepository = UthmaniRepository();

class UthmaniRepository {
  ///|*| ************* Variables ************* *|

  static const String name = "quran.ar.uthmani.v2";
  static const String dbName = "$name.db";
  static const int dbVersion = 1;

  static UthmaniRepository? _databaseHelper;
  static Database? _database;

  ///|*| ************* Singleton Constructor ************* *|
  factory UthmaniRepository() {
    _databaseHelper ??= UthmaniRepository._createInstance();
    return _databaseHelper!;
  }

  UthmaniRepository._createInstance();

  Future<Database> get database async {
    if (_database == null || !(_database?.isOpen ?? false)) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  ///|*| ************* Database Creation ************* *|
  Future<String> getDbPath() async {
    late final String path;

    if (Platform.isWindows) {
      final dbPath = (await getApplicationSupportDirectory()).path;
      path = join(dbPath, dbName);
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, dbName);
    }

    return path;
  }

  /// init
  Future<Database> _initDatabase() async {
    final path = await getDbPath();

    final exist = await databaseExists(path);

    //Check if database is already in that Directory
    if (!exist) {
      // Database isn't exist > Create new Database
      await _copyFromAssets(path: path);
    }

    Database database = await openDatabase(path);

    await database.getVersion().then((currentVersion) async {
      if (currentVersion != dbVersion) {
        appPrint("[DB] New version detected");
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
    );
  }

  /// Copy database from assets to Database Directory of app
  FutureOr<void> _copyFromAssets({required String path}) async {
    appPrint("[DB] Start copying...");

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
        final List<int> bytes = data.buffer.asUint8List();

        await File(path).writeAsBytes(bytes, flush: true);
      }
    } catch (e) {
      appPrint(e);
    }
  }

  ///|*| ************* Functions ************* |

  Future<String> getArabicText({
    required int sura,
    required int startAyah,
    required int endAyah,
  }) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
SELECT * FROM arabic_text 
WHERE sura = ? AND ayah BETWEEN ? AND ? 
ORDER BY ayah;
''',
      [sura, startAyah, endAyah],
    );

    if (maps.isEmpty) return "";

    return maps.map((e) => Verse.fromMap(e)).fold(
          "",
          (previousValue, element) =>
              "$previousValue ${element.text} ${element.ayah.toArabicNumber()}",
        );
  }

  /// Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}

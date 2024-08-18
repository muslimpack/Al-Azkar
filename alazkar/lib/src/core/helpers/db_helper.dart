import 'dart:async';
import 'dart:io';

import 'package:alazkar/src/core/utils/app_print.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  late final String dbName;
  late final int dbVersion;

  DBHelper({required this.dbName, required this.dbVersion}) {
    appPrint("# DatabaseHelper for $dbName");
  }

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

  Future<void> copyFromAssets(String path, String dbAssetPath) async {
    appPrint("$dbName copying new db...");

    try {
      final ByteData data = await rootBundle.load(dbAssetPath);
      final List<int> bytes = data.buffer.asUint8List();
      final File file = File(path);

      await file.writeAsBytes(bytes, flush: true);

      // Verify file size after writing (optional, for debugging)
      final writtenFileSize = await file.length();
      // Check if the ByteData size matches the expected size (optional, for debugging)
      appPrint(
        "$dbName Expected size: ${data.lengthInBytes}, actual size: ${bytes.length} | Written file size: $writtenFileSize",
      );

      appPrint("$dbName copy done");
    } catch (e) {
      appPrint("$dbName copy failed: $e");
    }
  }

  Future<Database> initDatabase() async {
    appPrint("$dbName init db");
    final String path = await getDbPath();
    final bool exist = await databaseExists(path);
    bool copyRequired = false;

    if (exist) {
      final File dbFile = File(path);
      final File assetFile = File('assets/db/$dbName');
      final int dbFileSize = await dbFile.length();
      final int assetFileSize = await assetFile.length();

      if (dbFileSize != assetFileSize) {
        appPrint("$dbName file size mismatch, copying new database");
        await deleteDatabase(path);
        copyRequired = true;
      }
    } else {
      copyRequired = true;
    }

    if (copyRequired) {
      await copyFromAssets(path, 'assets/db/$dbName');
      final tempDB = await openDatabase(path, version: dbVersion);
      await tempDB.close();
    }

    final Database database = await openDatabase(path);

    await database.getVersion().then((currentVersion) async {
      if (currentVersion < dbVersion) {
        appPrint(
          "$dbName detect new version | C:$currentVersion - N:$dbVersion",
        );
        database.close();
        await deleteDatabase(path);
        await copyFromAssets(path, 'assets/db/$dbName');
      }
    });

    return openDatabase(path, version: dbVersion);
  }
}

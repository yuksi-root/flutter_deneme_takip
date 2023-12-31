// ignore_for_file: avoid_print

import 'package:flutter_deneme_takip/core/local_database/deneme_tables.dart';
import 'package:flutter_deneme_takip/models/deneme.dart';
import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';

class DenemeDbProvider {
  DenemeDbProvider._();
  static final DenemeDbProvider db = DenemeDbProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await openDb();
    return _database!;
  }

  Future openDb() async {
    print("creating db");
    final Database db;
    db = await openDatabase(join(await getDatabasesPath(), "deneme_app.db"),
        onCreate: (db, version) async {
          await DenemeTables.tarihCreateTable(db);
          await DenemeTables.mathCreateTable(db);
          await DenemeTables.cografyaCreateTable(db);
          await DenemeTables.vatandasCreateTable(db);
          await DenemeTables.turkceCreateTable(db);
        },
        version: 1,
        onOpen: (Database db) async {
          //await DenemeTables.reCreateTable(db);
        });
    return db;
  }

  Future<void> insertDeneme(DenemeModel deneme, String lessonTable) async {
    final db = await database;

    db.insert(lessonTable, deneme.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getDenemelerByDenemeId(
      String lessonTable, int denemeId) async {
    final db = await database;
    final res = await db
        .rawQuery('SELECT * FROM $lessonTable WHERE denemeId = ?', [denemeId]);
    if (res.isEmpty) {
      return [];
    } else {
      var denemeMap = res.toList();

      return denemeMap.isNotEmpty ? denemeMap : [];
    }
  }

  Future<int> removeTableItem(String lessonTable, int id, String idName) async {
    final db = await database;
    int delete =
        await db.rawDelete('DELETE FROM $lessonTable WHERE $idName = ?', [id]);
    return delete;
  }

  Future<List<Map<String, dynamic>>> getLessonDeneme(String tableName) async {
    final db = await database;
    var res = await db.query(tableName);
    if (res.isEmpty) {
      return [];
    } else {
      var denemeMap = res.toList();

      return denemeMap.isNotEmpty ? denemeMap : [];
    }
  }

  Future<int?> getFindLastId(String tableName, String idName) async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT MAX($idName) as last_id FROM $tableName');
    int? lastId = result.first['last_id'] as int?;

    return lastId;
  }

  Future<List<int>> getAllDenemeIds(String tableName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(tableName, columns: ['denemeId']);

    return List.generate(maps.length, (index) {
      return maps[index]['denemeId'] as int;
    });
  }

  Future<void> clearDatabase() async {
    final db = await database;
    await db.rawQuery("DELETE FROM ${DenemeTables.historyTableName}");
    await db.rawQuery("DELETE FROM ${DenemeTables.mathTableName}");
    await db.rawQuery("DELETE FROM ${DenemeTables.cografyaTableName}");
    await db.rawQuery("DELETE FROM ${DenemeTables.vatandasTableName}");
    await db.rawQuery("DELETE FROM ${DenemeTables.turkceTableName}");
  }
}

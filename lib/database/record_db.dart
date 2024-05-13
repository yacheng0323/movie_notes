import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:movie_notes/database/database_service.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:sqflite/sqlite_api.dart';

class RecordDB {
  final tableName = "Records";

  Future<void> createTable(Database database) async {
    try {
      await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id"  INTEGER NOT NULL,
      "title" VARCHAR(255) NOT NULL,
      "datetime" INTEGER NOT NULL,
      "content" TEXT,
      "theater" VARCHAR(255) NOT NULL,
      "imagefile" TEXT,
      PRIMARY KEY("id"  AUTOINCREMENT)
    );""");
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  //* 建立一筆資料
  Future<int> create({
    required String title,
    required int datetime,
    String? content,
    required String theater,
    String? imagefile,
  }) async {
    try {
      final database = await GetIt.I.get<DatabaseService>().database;
      return await database.rawInsert(
          '''INSERT INTO $tableName (title,datetime,content,theater,imagefile) VALUES (?,?,?,?,?)''',
          [title, datetime, content, theater, imagefile]);
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  Future<List<RecordData>> fetchAll() async {
    try {
      final database = await GetIt.I.get<DatabaseService>().database;
      final records = await database
          .rawQuery('''SELECT * from $tableName ORDER BY datetime DESC''');
      return records
          .map((record) => RecordData.fromSqfliteDatabase(record))
          .toList();
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  //* 如果有搜尋需求?
  Future<RecordData> fetchById(int id) async {
    try {
      final database = await GetIt.I.get<DatabaseService>().database;
      final record = await database
          .rawQuery('''SELECT * from $tableName WHERE id = ?''', [id]);
      return RecordData.fromSqfliteDatabase(record.first);
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  //* 回傳id
  Future<int?> getId(String title) async {
    try {
      final db = await GetIt.I.get<DatabaseService>().database;
      List<Map<String, dynamic>> result = await db.query(
        tableName,
        where: "title = ?",
        whereArgs: [title],
        columns: ["id"],
      );
      if (result.isNotEmpty) {
        return result.first["id"] as int?;
      } else {
        return null;
      }
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  Future<int> update({
    required int id,
    required String? title,
    required int? datetime,
    String? content,
    required String? theater,
    String? imagefile,
  }) async {
    try {
      final database = await GetIt.I.get<DatabaseService>().database;
      final Map<String, dynamic> updatedData = {};

      if (title != null) updatedData["title"] = title;
      if (datetime != null) updatedData["datetime"] = datetime;
      if (content != null) updatedData["content"] = content;
      if (theater != null) updatedData["theater"] = theater;
      if (imagefile != null) updatedData["imagefile"] = imagefile;

      return await database.rawUpdate(
          '''UPDATE $tableName SET title = ?, datetime = ?,content = ?,theater = ?,imagefile = ? where id = ?''',
          [title, datetime, content, theater, imagefile, id]);
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  Future<void> delete(int id) async {
    try {
      final database = await GetIt.I.get<DatabaseService>().database;
      await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  //* 刪除資料表中所有資料
  Future<void> deleteAllData() async {
    try {
      final database = await GetIt.I.get<DatabaseService>().database;
      await database.delete(tableName);
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  //* 刪除整個資料表
  Future<void> deleteTable() async {
    try {
      final database = await GetIt.I.get<DatabaseService>().database;
      await database.execute("DROP TABLE $tableName");
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }
}

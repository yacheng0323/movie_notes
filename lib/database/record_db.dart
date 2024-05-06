import 'package:movie_notes/database/database_service.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:sqflite/sqlite_api.dart';

class RecordDB {
  final tableName = "Records";

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id"  INTEGER NOT NULL,
      "title" VARCHAR(255) NOT NULL,
      "datetime" INTEGER NOT NULL,
      "content" TEXT,
      "theater" VARCHAR(255) NOT NULL,
      "imagepath" VARCHAR(255),
      PRIMARY KEY("id"  AUTOINCREMENT)
    );""");
  }

  Future<int> create({
    required String title,
    required int datetime,
    String? content,
    required String theater,
    String? filename,
  }) async {
    final database = await DatabaseService().database;
    return await database.rawInsert(
        '''INSERT INTO $tableName (title,datetime,content,theater,imagepath) VALUES (?,?,?,?,?)''',
        [title, datetime, content, theater, filename]);
  }

  Future<List<RecordData>> fetchAll() async {
    final database = await DatabaseService().database;
    final records = await database
        .rawQuery('''SELECT * from $tableName ORDER BY datetime DESC''');
    return records
        .map((record) => RecordData.fromSqfliteDatabase(record))
        .toList();
  }

  //* 如果有搜尋需求?
  // Future<RecordData> fetchById(int id) async {
  //   final database = await DatabaseService().database;
  //   final record = await database.rawQuery('''SELECT * from $tableName WHERE id = ?''',[id]);
  //   return RecordData.fromSqfliteDatabase(record.first);
  // }

  Future<int> update({
    required int id,
    required String? title,
    required int? datetime,
    String? content,
    required String? theater,
    String? imagepath,
  }) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        "title": title,
        "datetime": datetime,
        "content": content ?? null,
        "theater": theater,
        "imagepath": imagepath ?? null,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }

  Future<void> deleteAll() async {
    final database = await DatabaseService().database;
    await database.delete(tableName);
  }

  // Future<void>
}

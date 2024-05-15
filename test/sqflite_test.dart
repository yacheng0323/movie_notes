import 'package:flutter_test/flutter_test.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  group("simple sqflite", () {
    const tableName = "Records";
    late Database db;

    setUp(() async {
      db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    });

    tearDown(() async {
      await db.close();
    });

    test("rawInsert test", () async {
      expect(await db.getVersion(), 0);
      await db.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id"  INTEGER NOT NULL,
      "title" VARCHAR(255) NOT NULL,
      "datetime" INTEGER NOT NULL,
      "content" TEXT,
      "theater" VARCHAR(255) NOT NULL,
      "imagepath" TEXT,
      PRIMARY KEY("id"  AUTOINCREMENT)
    );""");
      int request = await db.rawInsert(
          '''INSERT INTO $tableName (title,datetime,content,theater,imagepath) VALUES (?,?,?,?,?)''',
          ["title", 0, "content", "theater", "imagepath"]);

      expect(request, 1);
    });

    test("rawQuery test", () async {
      await db.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id"  INTEGER NOT NULL,
      "title" VARCHAR(255) NOT NULL,
      "datetime" INTEGER NOT NULL,
      "content" TEXT,
      "theater" VARCHAR(255) NOT NULL,
      "imagepath" TEXT,
      PRIMARY KEY("id"  AUTOINCREMENT)
    );""");
      await db.rawInsert(
          '''INSERT INTO $tableName (title,datetime,content,theater,imagepath) VALUES (?,?,?,?,?)''',
          ["title", 0, "content", "theater", "imagepath"]);
      await db.rawInsert(
          '''INSERT INTO $tableName (title,datetime,content,theater,imagepath) VALUES (?,?,?,?,?)''',
          ["title", 1, "content", "theater", "imagepath"]);
      final records = await db
          .rawQuery('''SELECT * from $tableName ORDER BY datetime DESC''');
      records.map((record) => RecordData.fromSqfliteDatabase(record)).toList();

      expect(records.length, 2);
    });
  });
}

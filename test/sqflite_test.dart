import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  group("simple sqflite", () {
    const tableName = "Records";
    test("createTable test", () async {
      var db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
      expect(await db.getVersion(), 0);
      await db.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "id"  INTEGER NOT NULL,
      "title" VARCHAR(255) NOT NULL,
      "datetime" INTEGER NOT NULL,
      "content" TEXT,
      "theater" VARCHAR(255) NOT NULL,
      "imagefile" TEXT,
      PRIMARY KEY("id"  AUTOINCREMENT)
    );""");
      // await
    });
  });
}

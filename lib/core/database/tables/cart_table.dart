import 'package:sqflite/sqlite_api.dart';

class CartTable {
  static const String tableName = 'cart';

  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT,
        name TEXT,
        price REAL,
        quantity INTEGER,
        image TEXT,
        size TEXT,
         optionId Text,
        currency TEXT,
        UNIQUE(productId, size)
      )
    ''');
  }
}

import 'package:sqflite/sqlite_api.dart';

class WishlistTable {
  static const String tableName = 'wishlist';

  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT UNIQUE,
        name TEXT,
        price REAL,
        image TEXT,
        rate REAL,
        special REAL,
        currency TEXT
      )
    ''');
  }
}

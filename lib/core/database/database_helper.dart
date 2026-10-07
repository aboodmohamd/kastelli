import 'package:kastelli/core/database/tables/cart_table.dart';
import 'package:kastelli/core/database/tables/notification_table.dart';
import 'package:kastelli/core/database/tables/wishlist_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final String dbPath = join(await getDatabasesPath(), 'app.db');

    return await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await CartTable.create(db);
        await WishlistTable.create(db);
        await NotificationTable.create(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await WishlistTable.create(db);
          await NotificationTable.create(db);
        }
      },
    );
  }
}

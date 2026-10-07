import 'package:sqflite/sqlite_api.dart';

class NotificationTable {
  static const String tableName = 'notification';

  static Future<void> create(Database db) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        notificationId TEXT,
        title TEXT,
        body TEXT,
        notification_type TEXT,
        date_time TEXT
      )
    ''');
  }
}

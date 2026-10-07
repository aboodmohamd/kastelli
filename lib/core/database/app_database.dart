import 'package:kastelli/core/database/database_helper.dart';
import 'package:kastelli/core/database/tables/cart_table.dart';
import 'package:kastelli/core/database/tables/notification_table.dart';
import 'package:kastelli/core/database/tables/wishlist_table.dart';
import 'package:kastelli/core/network/api_client.dart';
import 'package:sqflite/sqlite_api.dart';

class AppDatabase {
  final DatabaseHelper provider;

  AppDatabase(this.provider, {required ApiConsumer apiConsumer});

  Future<void> create({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    final db = await provider.database;
    await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> read({required String tableName}) async {
    final db = await provider.database;
    return await db.query(tableName);
  }

  Future<void> delete({
    required String tableName,
    String? where,
    List<Object?>? listWhere,
  }) async {
    final db = await provider.database;
    await db.delete(tableName, where: where, whereArgs: listWhere);
  }

  Future<void> insertCart(Map<String, dynamic> data) async {
    final db = await provider.database;
    await db.insert('cart', data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getCart() async {
    final db = await provider.database;
    return await db.query('cart');
  }

  Future<void> deleteCartItem({
    required String productId,
    required String size,
  }) async {
    final db = await provider.database;
    await db.delete(
      'cart',
      where: 'productId = ? AND size = ?',
      whereArgs: [productId, size],
    );
  }

  Future<void> updateProductQuantity({
    required bool increment,
    required String productId,
    required String size,
    int amount = 1,
  }) async {
    final Database db = await provider.database;

    await db.rawUpdate(
      '''
        UPDATE cart
        SET quantity = CASE
          WHEN ? = 1 THEN quantity + ?
          ELSE MAX(quantity - ?, 1)
        END
        WHERE productId = ? AND size = ?
      ''',
      [increment ? 1 : 0, amount, amount, productId, size],
    );
  }

  Future<void> insertWishlist(Map<String, dynamic> data) async {
    final db = await provider.database;

    await db.insert(
      'wishlist',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getWishlist() async {
    final db = await provider.database;
    return await db.query('wishlist');
  }

  Future<void> deleteFromWishlist(String productId) async {
    final db = await provider.database;

    await db.delete('wishlist', where: 'productId = ?', whereArgs: [productId]);
  }

  Future<bool> isInWishlist(String productId) async {
    final db = await provider.database;

    final result = await db.query(
      'wishlist',
      where: 'productId = ?',
      whereArgs: [productId],
    );

    return result.isNotEmpty;
  }

  Future<void> clearAll() async {
    await delete(tableName: CartTable.tableName);
    await delete(tableName: WishlistTable.tableName);
    await delete(tableName: NotificationTable.tableName);
  }
}

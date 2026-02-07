import 'package:sqflite/sqflite.dart';

import '../models/guest_model.dart';
import 'database_helper.dart';

class GuestDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// 🔥 Bulk Insert (سريع جدًا)
  Future<void> insertGuestsBulk(List<Guest> guests) async {
    final db = await _dbHelper.database;

    final batch = db.batch();

    for (final guest in guests) {
      batch.insert(
        'guests',
        guest.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  /// get by id
  Future<Guest?> getGuestById(String id) async {
    final db = await _dbHelper.database;

    final result =
    await db.query('guests', where: 'guestId = ?', whereArgs: [id]);

    if (result.isEmpty) return null;

    return Guest.fromMap(result.first);
  }

  /// mark verified
  Future<void> markVerified(String id) async {
    final db = await _dbHelper.database;

    await db.update(
      'guests',
      {'verified': 1},
      where: 'guestId = ?',
      whereArgs: [id],
    );
  }

  /// stats
  Future<Map<String, int>> getStats() async {
    final db = await _dbHelper.database;

    final total =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM guests')) ??
            0;

    final verified = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM guests WHERE verified = 1')) ??
        0;

    final remaining = total - verified;

    return {
      'total': total,
      'verified': verified,
      'remaining': remaining,
    };
  }

  Future<List<Guest>> getAllGuests() async {
    final db = await _dbHelper.database;

    final result = await db.query(
      'guests',
      orderBy: 'name ASC',
    );

    return result.map((map) => Guest.fromMap(map)).toList();
  }

  /// clear all
  Future<void> clearAll() async {
    final db = await _dbHelper.database;
    await db.delete('guests');
  }
}

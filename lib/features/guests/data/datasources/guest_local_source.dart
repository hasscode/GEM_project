import '../../../../core/database/app_database.dart';
import '../../../check_in/domain/check_in_result.dart';
import '../../domain/models/event_snapshot.dart';
import '../../domain/models/guest.dart';
import '../models/guest_dto.dart';

class GuestLocalSource {
  GuestLocalSource(this.database, {DateTime Function()? now})
    : now = now ?? DateTime.now;
  final AppDatabase database;
  final DateTime Function() now;

  Future<EventSnapshot> snapshot({String? eventId}) async {
    final db = await database.database;
    return db.transaction((txn) async {
      final rows = await txn.query('events', orderBy: 'loaded_at DESC');
      final events = rows
          .map(
            (r) => EventInfo(
              r['id'] as String,
              r['name'] as String,
              loadedAt: DateTime.tryParse(r['loaded_at'] as String),
            ),
          )
          .toList();
      final active = events.any((e) => e.id == eventId)
          ? eventId
          : events.firstOrNull?.id;
      final guests = active == null
          ? <Guest>[]
          : (await txn.query(
              'event_guests',
              where: 'event_id = ?',
              whereArgs: [active],
              orderBy: 'name COLLATE NOCASE ASC',
            )).map(GuestDto.fromRow).toList();
      return EventSnapshot(
        events: events,
        guests: guests,
        activeEventId: active,
      );
    });
  }

  Future<void> seed(
    String eventId,
    List<Guest> guests, {
    required bool replace,
  }) async {
    final db = await database.database;
    await db.transaction((txn) async {
      final existing = await txn.query(
        'events',
        where: 'id = ?',
        whereArgs: [eventId],
      );
      if (existing.isNotEmpty && !replace) return;
      if (existing.isNotEmpty) {
        await txn.delete(
          'event_guests',
          where: 'event_id = ?',
          whereArgs: [eventId],
        );
        await txn.delete('events', where: 'id = ?', whereArgs: [eventId]);
      }
      await txn.insert('events', {
        'id': eventId,
        'name': 'حفل التخرج • تجربة',
        'loaded_at': now().toUtc().toIso8601String(),
      });
      final batch = txn.batch();
      for (final guest in guests) {
        batch.insert('event_guests', GuestDto.toRow(guest));
      }
      await batch.commit(noResult: true);
    });
  }

  Future<CheckInResult> checkIn(String eventId, String guestId) async {
    final db = await database.database;
    return db.transaction((txn) async {
      final rows = await txn.query(
        'event_guests',
        where: 'event_id = ? AND guest_id = ?',
        whereArgs: [eventId, guestId],
      );
      if (rows.isEmpty) return const CheckInResult(CheckInStatus.notFound);
      final guest = GuestDto.fromRow(rows.single);
      if (guest.checkedIn) {
        return CheckInResult(CheckInStatus.alreadyCheckedIn, guest);
      }
      if (!guest.isComplete) {
        return CheckInResult(CheckInStatus.incomplete, guest);
      }
      await txn.update(
        'event_guests',
        {
          'checked_in': 1,
          'checked_in_at': now().toUtc().toIso8601String(),
          'pending_sync': 1,
        },
        where: 'event_id = ? AND guest_id = ? AND checked_in = 0',
        whereArgs: [eventId, guestId],
      );
      final updated = await txn.query(
        'event_guests',
        where: 'event_id = ? AND guest_id = ?',
        whereArgs: [eventId, guestId],
      );
      return CheckInResult(
        CheckInStatus.accepted,
        GuestDto.fromRow(updated.single),
      );
    });
  }
}

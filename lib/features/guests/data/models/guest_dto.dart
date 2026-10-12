import '../../domain/models/guest.dart';

class GuestDto {
  static Guest fromRow(Map<String, Object?> row) => Guest(
    eventId: row['event_id'] as String,
    id: row['guest_id'] as String,
    name: (row['name'] as String?) ?? '',
    nationalId: row['national_id'] as String?,
    companions: row['companions'] as int?,
    location: row['location'] as String?,
    checkedIn: row['checked_in'] == 1,
    pendingSync: row['pending_sync'] == 1,
    checkedInAt: DateTime.tryParse(row['checked_in_at'] as String? ?? ''),
  );
  static Map<String, Object?> toRow(Guest guest) => {
    'event_id': guest.eventId,
    'guest_id': guest.id,
    'name': guest.name,
    'national_id': guest.nationalId,
    'companions': guest.companions,
    'location': guest.location,
    'checked_in': guest.checkedIn ? 1 : 0,
    'checked_in_at': guest.checkedInAt?.toUtc().toIso8601String(),
    'pending_sync': guest.pendingSync ? 1 : 0,
  };
}

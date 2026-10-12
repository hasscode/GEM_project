import '../../guests/domain/models/guest.dart';

/// Future backend boundary. Not registered until an authenticated API exists.
/// Initial data is cached once. Only pending attendance is sent at final sync.
/// Acknowledgment must precede clearing pending flags; reuse batchId on retry.
abstract interface class EventSyncGateway {
  Future<List<Guest>> downloadGuests(String eventId);
  Future<void> uploadAttendance({
    required String eventId,
    required String batchId,
    required List<Guest> checkedInGuests,
  });
}

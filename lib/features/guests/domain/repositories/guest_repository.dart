import '../../../check_in/domain/check_in_result.dart';
import '../models/event_snapshot.dart';

abstract interface class GuestRepository {
  Future<EventSnapshot> loadSnapshot({String? eventId});
  Future<void> generateDemo({bool replace = false});
  Future<CheckInResult> checkIn(String eventId, String guestId);
}

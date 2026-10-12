import '../../../check_in/domain/check_in_result.dart';
import '../../domain/models/event_snapshot.dart';
import '../../domain/repositories/guest_repository.dart';
import '../datasources/demo_guest_source.dart';
import '../datasources/guest_local_source.dart';

class LocalGuestRepository implements GuestRepository {
  const LocalGuestRepository(this.local, this.demo);
  final GuestLocalSource local;
  final DemoGuestSource demo;
  @override
  Future<EventSnapshot> loadSnapshot({String? eventId}) =>
      local.snapshot(eventId: eventId);
  @override
  Future<void> generateDemo({bool replace = false}) =>
      local.seed(DemoGuestSource.eventId, demo.load(), replace: replace);
  @override
  Future<CheckInResult> checkIn(String eventId, String guestId) =>
      local.checkIn(eventId, guestId);
}

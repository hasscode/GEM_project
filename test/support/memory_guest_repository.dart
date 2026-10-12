import 'package:gem_project/features/guests/domain/repositories/guest_repository.dart';
import 'package:gem_project/features/guests/domain/models/event_snapshot.dart';
import 'package:gem_project/features/guests/domain/models/guest.dart';
import 'package:gem_project/features/guests/data/datasources/demo_guest_source.dart';
import 'package:gem_project/features/check_in/domain/check_in_result.dart';

class MemoryGuestRepository implements GuestRepository {
  List<Guest> guests = [];
  int writes = 0;
  @override
  Future<void> generateDemo({bool replace = false}) async {
    if (guests.isEmpty || replace) guests = DemoGuestSource().load();
  }

  @override
  Future<EventSnapshot> loadSnapshot({String? eventId}) async => EventSnapshot(
    events: guests.isEmpty
        ? []
        : [const EventInfo(DemoGuestSource.eventId, 'حفل التخرج • تجربة')],
    guests: guests,
    activeEventId: guests.isEmpty ? null : DemoGuestSource.eventId,
  );
  @override
  Future<CheckInResult> checkIn(String eventId, String guestId) async {
    writes++;
    final index = guests.indexWhere(
      (g) => g.eventId == eventId && g.id == guestId,
    );
    if (index < 0) return const CheckInResult(CheckInStatus.notFound);
    final old = guests[index];
    if (old.checkedIn) {
      return CheckInResult(CheckInStatus.alreadyCheckedIn, old);
    }
    if (!old.isComplete) return CheckInResult(CheckInStatus.incomplete, old);
    final updated = Guest(
      eventId: old.eventId,
      id: old.id,
      name: old.name,
      nationalId: old.nationalId,
      companions: old.companions,
      location: old.location,
      checkedIn: true,
      pendingSync: true,
      checkedInAt: DateTime.utc(2026, 10, 10, 18),
    );
    guests = [...guests]..[index] = updated;
    return CheckInResult(CheckInStatus.accepted, updated);
  }
}

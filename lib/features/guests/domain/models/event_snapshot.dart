import 'guest.dart';

class EventInfo {
  const EventInfo(this.id, this.name, {this.loadedAt});
  final String id, name;
  final DateTime? loadedAt;
}

class EventSnapshot {
  EventSnapshot({
    required List<EventInfo> events,
    required List<Guest> guests,
    required this.activeEventId,
  }) : events = List.unmodifiable(events),
       guests = List.unmodifiable(guests);
  final List<EventInfo> events;
  final List<Guest> guests;
  final String? activeEventId;
  EventInfo? get event =>
      events.where((e) => e.id == activeEventId).firstOrNull;
  int get total => guests.length;
  int get checkedIn => guests.where((g) => g.checkedIn).length;
  int get remaining => total - checkedIn;
  int get incomplete => guests.where((g) => !g.isComplete).length;
  int get pending => guests.where((g) => g.pendingSync).length;
  int get companions =>
      guests.fold(0, (count, g) => count + (g.companions ?? 0));

  DateTime? get lastUpdatedAt {
    var latest = event?.loadedAt;
    for (final guest in guests) {
      final checkIn = guest.checkedInAt;
      if (checkIn != null && (latest == null || checkIn.isAfter(latest))) {
        latest = checkIn;
      }
    }
    return latest;
  }
}

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:gem_project/features/guests/domain/models/event_snapshot.dart';
import 'package:gem_project/features/guests/presentation/cubit/event_cubit.dart';
import 'package:gem_project/features/check_in/domain/check_in_guest.dart';
import 'package:gem_project/features/check_in/domain/check_in_result.dart';
import 'package:gem_project/features/check_in/presentation/cubit/check_in_cubit.dart';
import '../support/memory_guest_repository.dart';

class ControlledRepository extends MemoryGuestRepository {
  final requests = <Completer<EventSnapshot>>[];
  final scanRequest = Completer<CheckInResult>();
  @override
  Future<EventSnapshot> loadSnapshot({String? eventId}) {
    final completer = Completer<EventSnapshot>();
    requests.add(completer);
    return completer.future;
  }

  @override
  Future<CheckInResult> checkIn(String eventId, String guestId) {
    writes++;
    return scanRequest.future;
  }
}

void main() {
  EventSnapshot snapshot(String id) =>
      EventSnapshot(events: [EventInfo(id, id)], guests: [], activeEventId: id);
  test('latest load wins and refresh retains data on error', () async {
    final repo = ControlledRepository();
    final cubit = EventCubit(repo);
    final first = cubit.load();
    final second = cubit.load();
    repo.requests[1].complete(snapshot('new'));
    await second;
    repo.requests[0].complete(snapshot('old'));
    await first;
    expect(cubit.state.snapshot!.activeEventId, 'new');
    final refresh = cubit.load();
    expect(cubit.state.snapshot!.activeEventId, 'new');
    repo.requests[2].completeError(Exception('private database path'));
    await refresh;
    expect(cubit.state.snapshot!.activeEventId, 'new');
    expect(cubit.state.error, isNot(contains('private database path')));
    await cubit.close();
  });
  test('closing while awaiting success or failure does not emit', () async {
    for (final fail in [false, true]) {
      final repo = ControlledRepository();
      final cubit = EventCubit(repo);
      final work = cubit.load();
      await cubit.close();
      if (fail) {
        repo.requests.single.completeError(Exception('closed'));
      } else {
        repo.requests.single.complete(snapshot('x'));
      }
      await work;
    }
  });
  test('scanner blocks concurrent input and safely closes in flight', () async {
    final repo = ControlledRepository();
    final cubit = CheckInCubit(CheckInGuest(repo));
    const raw = '{"eventId":"e","guestId":"g"}';
    final first = cubit.scan(raw, 'e');
    await cubit.scan(raw, 'e');
    expect(repo.writes, 1);
    await cubit.close();
    repo.scanRequest.complete(const CheckInResult(CheckInStatus.notFound));
    await first;
  });
}

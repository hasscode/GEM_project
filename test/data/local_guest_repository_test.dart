import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:gem_project/core/database/app_database.dart';
import 'package:gem_project/features/check_in/domain/check_in_guest.dart';
import 'package:gem_project/features/check_in/domain/check_in_result.dart';
import 'package:gem_project/features/check_in/domain/qr_payload.dart';
import 'package:gem_project/features/guests/data/datasources/demo_guest_source.dart';
import 'package:gem_project/features/guests/data/datasources/guest_local_source.dart';
import 'package:gem_project/features/guests/data/repositories/local_guest_repository.dart';

void main() {
  sqfliteFfiInit();
  const event = DemoGuestSource.eventId;
  late AppDatabase db;
  late LocalGuestRepository repo;
  setUp(() {
    db = AppDatabase(databaseFactoryFfi, path: inMemoryDatabasePath);
    repo = LocalGuestRepository(GuestLocalSource(db), DemoGuestSource());
  });
  tearDown(() => db.close());

  test(
    'seed, accept, repeat, missing, invalid, wrong event and incomplete decisions',
    () async {
      await repo.generateDemo();
      final scan = CheckInGuest(repo);
      final accepted = await scan(
        const QrPayload(event, 'GUEST-001').encode(),
        event,
      );
      expect(accepted.status, CheckInStatus.accepted);
      expect(accepted.guest!.checkedIn, isTrue);
      expect(accepted.guest!.checkedInAt, isNotNull);
      expect(accepted.guest!.pendingSync, isTrue);
      final repeat = await scan(
        const QrPayload(event, 'GUEST-001').encode(),
        event,
      );
      expect(repeat.status, CheckInStatus.alreadyCheckedIn);
      expect(repeat.guest!.checkedInAt, accepted.guest!.checkedInAt);
      expect(
        (await scan(const QrPayload(event, 'absent').encode(), event)).status,
        CheckInStatus.notFound,
      );
      expect((await scan('invalid', event)).status, CheckInStatus.invalidQr);
      expect(
        (await scan(
          const QrPayload('another-event', 'GUEST-001').encode(),
          event,
        )).status,
        CheckInStatus.wrongEvent,
      );
      expect(
        (await scan(
          const QrPayload(event, 'GUEST-004').encode(),
          event,
        )).status,
        CheckInStatus.incomplete,
      );
      final state = await repo.loadSnapshot();
      expect(state.checkedIn, 1);
      expect(state.pending, 1);
      expect(state.remaining, 3);
      expect(state.incomplete, 1);
      expect(() => state.guests.clear(), throwsUnsupportedError);
    },
  );

  test(
    'simultaneous scans accept only once; safe reseed preserves attendance',
    () async {
      await repo.generateDemo();
      final results = await Future.wait(
        List.generate(8, (_) => repo.checkIn(event, 'GUEST-002')),
      );
      expect(
        results.where((r) => r.status == CheckInStatus.accepted).length,
        1,
      );
      expect(
        results.where((r) => r.status == CheckInStatus.alreadyCheckedIn).length,
        7,
      );
      await repo.generateDemo();
      expect((await repo.loadSnapshot()).checkedIn, 1);
      await repo.generateDemo(replace: true);
      expect((await repo.loadSnapshot()).checkedIn, 0);
    },
  );

  test(
    'v1 migration preserves old attendance and restart persists new check-ins',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'eem-migration-test-',
      );
      final path = '${directory.path}/gem.db';
      AppDatabase? upgraded;
      AppDatabase? reopened;
      try {
        final old = await databaseFactoryFfi.openDatabase(
          path,
          options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, _) async {
              await db.execute(
                'CREATE TABLE guests(id INTEGER PRIMARY KEY, guestId TEXT UNIQUE, name TEXT, location TEXT, companions INTEGER, verified INTEGER)',
              );
              await db.insert('guests', {
                'id': 1,
                'guestId': 'old-1',
                'name': 'Old guest',
                'location': 'Hall',
                'companions': 0,
                'verified': 1,
              });
            },
          ),
        );
        await old.close();
        upgraded = AppDatabase(databaseFactoryFfi, path: path);
        final upgradedRepo = LocalGuestRepository(
          GuestLocalSource(upgraded),
          DemoGuestSource(),
        );
        final legacy = await upgradedRepo.loadSnapshot();
        expect(legacy.activeEventId, 'legacy');
        expect(legacy.checkedIn, 1);
        expect(legacy.guests.single.nationalId, isNull);
        await upgradedRepo.generateDemo();
        await upgradedRepo.checkIn(event, 'GUEST-001');
        await upgradedRepo.generateDemo(replace: true);
        expect(
          (await upgradedRepo.loadSnapshot(eventId: 'legacy')).checkedIn,
          1,
        );
        await upgradedRepo.checkIn(event, 'GUEST-003');
        await upgraded.close();
        reopened = AppDatabase(databaseFactoryFfi, path: path);
        final snapshot = await LocalGuestRepository(
          GuestLocalSource(reopened),
          DemoGuestSource(),
        ).loadSnapshot(eventId: event);
        expect(snapshot.checkedIn, 1);
        expect(snapshot.pending, 1);
      } finally {
        await upgraded?.close();
        await reopened?.close();
        await directory.delete(recursive: true);
      }
    },
  );

  test(
    'seed transaction rolls back when a source contains duplicate keys',
    () async {
      await repo.generateDemo();
      await repo.checkIn(event, 'GUEST-001');
      final guest = DemoGuestSource().load().first;
      await expectLater(
        GuestLocalSource(db).seed(event, [guest, guest], replace: true),
        throwsA(isA<DatabaseException>()),
      );
      expect((await repo.loadSnapshot()).checkedIn, 1);
      expect((await repo.loadSnapshot()).total, 4);
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:gem_project/features/check_in/domain/qr_payload.dart';
import 'package:gem_project/features/guests/data/datasources/demo_guest_source.dart';
import 'package:gem_project/features/guest_lookup/domain/search_guests.dart';

void main() {
  final guests = DemoGuestSource().load();
  test(
    'demo includes four unique synthetic IDs and an inspectable incomplete guest',
    () {
      expect(guests.length, 4);
      expect(guests.map((g) => g.id).toSet().length, 4);
      expect(guests.where((g) => g.isComplete).length, 3);
      expect(guests.last.missingFields, ['المكان']);
      expect(guests[2].companions, 0);
      expect(guests[2].isComplete, isTrue);
    },
  );
  test(
    'QR has only event and guest identity, and rejects malformed payloads',
    () {
      final raw = QrPayload(guests.first.eventId, guests.first.id).encode();
      expect(raw.contains(guests.first.nationalId!), isFalse);
      expect(QrPayload.parse(raw)?.guestId, guests.first.id);
      for (final input in [
        'not-json',
        '[]',
        '{}',
        '{"eventId":3,"guestId":"G"}',
        '{"eventId":"e","guestId":""}',
        '{"v":2,"eventId":"e","guestId":"g"}',
        'x' * 2049,
      ]) {
        expect(
          QrPayload.parse(input),
          isNull,
          reason: input.substring(0, input.length.clamp(0, 80)),
        );
      }
    },
  );
  test('Arabic name search normalizes hamza and diacritics', () {
    expect(searchGuests(guests, 'اَحمد', SearchMode.name).map((g) => g.id), [
      'GUEST-001',
      'GUEST-004',
    ]);
    expect(
      searchGuests(guests, 'محمود', SearchMode.name).single.id,
      'GUEST-002',
    );
    expect(searchGuests(guests, 'غير موجود', SearchMode.name), isEmpty);
  });
  test('identity matches exactly and accepts Arabic digits', () {
    expect(
      searchGuests(guests, '٠٠٠٠٠٠٠٠٠٠٠٠٠١', SearchMode.nationalId).single.id,
      'GUEST-001',
    );
    expect(searchGuests(guests, '0001', SearchMode.nationalId), isEmpty);
    expect(
      searchGuests(
        guests,
        '',
        SearchMode.name,
        incompleteOnly: true,
      ).single.name,
      'مريم تامر أحمد',
    );
  });
}

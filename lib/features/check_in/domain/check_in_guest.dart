import '../../guests/domain/repositories/guest_repository.dart';
import 'check_in_result.dart';
import 'qr_payload.dart';

class CheckInGuest {
  const CheckInGuest(this.repository);
  final GuestRepository repository;
  Future<CheckInResult> call(String raw, String eventId) async {
    final payload = QrPayload.parse(raw);
    if (payload == null) return const CheckInResult(CheckInStatus.invalidQr);
    if (payload.eventId != eventId) {
      return const CheckInResult(CheckInStatus.wrongEvent);
    }
    return repository.checkIn(eventId, payload.guestId);
  }
}

import '../../guests/domain/models/guest.dart';

enum CheckInStatus {
  accepted,
  alreadyCheckedIn,
  notFound,
  invalidQr,
  wrongEvent,
  incomplete,
}

class CheckInResult {
  const CheckInResult(this.status, [this.guest]);
  final CheckInStatus status;
  final Guest? guest;
}

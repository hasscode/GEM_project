import '../../../model/models/guest_model.dart';

abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanVerified extends ScanState {
  final Guest guest;
  ScanVerified(this.guest);
}

class ScanAlreadyVerified extends ScanState {
  final Guest guest;
  ScanAlreadyVerified(this.guest);
}

class ScanDenied extends ScanState {}

class ScanError extends ScanState {
  final String message;
  ScanError(this.message);
}

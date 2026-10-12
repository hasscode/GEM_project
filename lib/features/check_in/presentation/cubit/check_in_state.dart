import '../../domain/check_in_result.dart';

class CheckInState {
  const CheckInState({this.busy = false, this.result, this.error});
  final bool busy;
  final CheckInResult? result;
  final String? error;
}

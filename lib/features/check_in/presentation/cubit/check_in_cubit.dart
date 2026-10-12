import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/check_in_guest.dart';
import 'check_in_state.dart';

class CheckInCubit extends Cubit<CheckInState> {
  CheckInCubit(this.checkIn) : super(const CheckInState());
  final CheckInGuest checkIn;
  Future<void> scan(String raw, String eventId) async {
    if (isClosed || state.busy || state.result != null || state.error != null) {
      return;
    }
    emit(const CheckInState(busy: true));
    try {
      final result = await checkIn(raw, eventId);
      if (!isClosed) emit(CheckInState(result: result));
    } catch (_) {
      if (!isClosed) {
        emit(const CheckInState(error: 'تعذر تسجيل الحضور. حاول مرة أخرى.'));
      }
    }
  }

  void reset() {
    if (!isClosed && !state.busy) emit(const CheckInState());
  }
}

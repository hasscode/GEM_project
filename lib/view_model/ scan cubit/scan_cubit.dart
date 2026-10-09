import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gem_project/view_model/%20scan%20cubit/scan_state.dart';
import '../../../model/repositories/guest_repository.dart';


class ScanCubit extends Cubit<ScanState> {
  ScanCubit(this._repo) : super(ScanInitial());

  final GuestRepository _repo;

  Future<void> checkGuest(String id) async {
    try {
      emit(ScanLoading());

      final result = await _repo.verifyGuest(id);

      switch (result.$1) {
        case ScanResult.verified:
          emit(ScanVerified(result.$2!));

        case ScanResult.alreadyVerified:
          emit(ScanAlreadyVerified(result.$2!));

        case ScanResult.denied:
          emit(ScanDenied());
      }
    } catch (e) {
      emit(ScanError(e.toString()));
    }
  }

  void reset() => emit(ScanInitial());
}

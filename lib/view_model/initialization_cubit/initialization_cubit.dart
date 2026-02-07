import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/repositories/guest_repository.dart';
import 'initialization_state.dart';

class InitializationCubit extends Cubit<InitializationState> {
  InitializationCubit(this._repo) : super(InitializationInitial());

  final GuestRepository _repo;

  /// check if data exists
  Future<void> checkInitialization() async {
    emit(InitializationLoading());

    final stats = await _repo.getStats();

    if ((stats['total'] ?? 0) == 0) {
      emit(InitializationEmpty());
    } else {
      emit(InitializationReady());
    }
  }

  /// import excel
  Future<void> importExcel(File file) async {
    try {
      emit(InitializationLoading());

      await _repo.importFromExcel(file);

      emit(InitializationImported());
    } catch (e) {
      emit(InitializationError(e.toString()));
    }
  }
}

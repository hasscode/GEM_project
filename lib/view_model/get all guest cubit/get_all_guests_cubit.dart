import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/repositories/guest_repository.dart';
import 'get_all_guests_state.dart';

class GuestListCubit extends Cubit<GuestListState> {
  final GuestRepository _repo;

  GuestListCubit(this._repo) : super(GuestListInitial());

  Future<void> loadGuests() async {
    try {
      emit(GuestListLoading());

      final guests = await _repo.getAllGuests();
      final stats = await _repo.getStats();

      emit(GuestListLoaded(guests, stats));
    } catch (e) {
      emit(GuestListError(e.toString()));
    }
  }
}
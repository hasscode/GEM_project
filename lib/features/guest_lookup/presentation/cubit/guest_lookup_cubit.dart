import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/search_guests.dart';
import 'guest_lookup_state.dart';

class GuestLookupCubit extends Cubit<GuestLookupState> {
  GuestLookupCubit() : super(const GuestLookupState());
  void search(String value) {
    if (!isClosed) emit(state.copyWith(query: value));
  }

  void changeMode(SearchMode mode) {
    if (!isClosed) emit(state.copyWith(mode: mode));
  }

  void showIncomplete(bool value) {
    if (!isClosed) emit(state.copyWith(incompleteOnly: value));
  }
}

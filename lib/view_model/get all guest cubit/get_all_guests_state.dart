import '../../model/models/guest_model.dart';

abstract class GuestListState {}

class GuestListInitial extends GuestListState {}

class GuestListLoading extends GuestListState {}

class GuestListLoaded extends GuestListState {
  final List<Guest> guests;
  final Map<String, int> stats;

  GuestListLoaded(this.guests, this.stats);
}

class GuestListError extends GuestListState {
  final String message;
  GuestListError(this.message);
}
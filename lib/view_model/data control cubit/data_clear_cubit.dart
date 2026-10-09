
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/repositories/guest_repository.dart';
import 'data_clear_state.dart';

class DataClearCubit extends Cubit<DataClearState> {
  DataClearCubit(this._repo) : super(DataIdle());

  final GuestRepository _repo;

  Future<void> clearAll() async {
    emit(DataClearing());

    await _repo.clearAll();

    emit(DataCleared());
  }
}

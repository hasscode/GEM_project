import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../model/repositories/guest_repository.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit(this._repo) : super(const DashboardState());

  final GuestRepository _repo;

  Future<void> loadStats() async {
    final stats = await _repo.getStats();

    emit(
      state.copyWith(
        total: stats['total'],
        verified: stats['verified'],
        remaining: stats['remaining'],
      ),
    );
  }
}

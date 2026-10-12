import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/guest_repository.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit(this.repository) : super(const EventState());
  final GuestRepository repository;
  int _generation = 0;

  Future<void> load({String? eventId}) async {
    if (isClosed || state.saving) return;
    final request = ++_generation;
    emit(EventState(snapshot: state.snapshot, loading: true));
    try {
      final snapshot = await repository.loadSnapshot(
        eventId: eventId ?? state.snapshot?.activeEventId,
      );
      if (isClosed || request != _generation) return;
      emit(EventState(snapshot: snapshot));
    } catch (_) {
      if (isClosed || request != _generation) return;
      emit(
        EventState(
          snapshot: state.snapshot,
          error: 'تعذر قراءة البيانات. حاول مرة أخرى.',
        ),
      );
    }
  }

  Future<void> generateDemo({bool replace = false}) async {
    if (isClosed || state.saving || state.loading) return;
    ++_generation;
    emit(EventState(snapshot: state.snapshot, saving: true));
    try {
      await repository.generateDemo(replace: replace);
      final snapshot = await repository.loadSnapshot(
        eventId: 'demo-graduation',
      );
      if (!isClosed) emit(EventState(snapshot: snapshot));
    } catch (_) {
      if (!isClosed) {
        emit(
          EventState(
            snapshot: state.snapshot,
            error:
                'تعذر إكمال تجهيز البيانات. أعد تحميل القائمة للتأكد من حالتها.',
          ),
        );
      }
    }
  }
}

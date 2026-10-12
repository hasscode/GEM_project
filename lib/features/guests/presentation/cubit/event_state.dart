import '../../domain/models/event_snapshot.dart';

class EventState {
  const EventState({
    this.snapshot,
    this.loading = false,
    this.saving = false,
    this.error,
  });
  final EventSnapshot? snapshot;
  final bool loading, saving;
  final String? error;
}

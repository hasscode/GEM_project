import '../../domain/search_guests.dart';

class GuestLookupState {
  const GuestLookupState({
    this.query = '',
    this.mode = SearchMode.name,
    this.incompleteOnly = false,
  });
  final String query;
  final SearchMode mode;
  final bool incompleteOnly;
  GuestLookupState copyWith({
    String? query,
    SearchMode? mode,
    bool? incompleteOnly,
  }) => GuestLookupState(
    query: query ?? this.query,
    mode: mode ?? this.mode,
    incompleteOnly: incompleteOnly ?? this.incompleteOnly,
  );
}

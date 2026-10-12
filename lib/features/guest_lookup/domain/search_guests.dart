import '../../guests/domain/models/guest.dart';

enum SearchMode { name, nationalId }

String normalizeSearch(String value) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  var result = value.trim().toLowerCase();
  for (var i = 0; i < 10; i++) {
    result = result.replaceAll(arabic[i], '$i').replaceAll(persian[i], '$i');
  }
  return result
      .replaceAll(RegExp('[أإآ]'), 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll(RegExp('[\u064B-\u065F\u0670\u0640]'), '')
      .replaceAll(RegExp(r'\s+'), ' ');
}

List<Guest> searchGuests(
  List<Guest> guests,
  String query,
  SearchMode mode, {
  bool incompleteOnly = false,
}) {
  final normalized = normalizeSearch(query);
  return List.unmodifiable(
    guests.where(
      (g) =>
          (!incompleteOnly || !g.isComplete) &&
          (normalized.isEmpty ||
              (mode == SearchMode.name
                  ? normalizeSearch(g.name).contains(normalized)
                  : normalizeSearch(g.nationalId ?? '') == normalized)),
    ),
  );
}

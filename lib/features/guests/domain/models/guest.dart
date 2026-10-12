class Guest {
  const Guest({
    required this.eventId,
    required this.id,
    required this.name,
    this.nationalId,
    this.companions,
    this.location,
    this.checkedIn = false,
    this.checkedInAt,
    this.pendingSync = false,
  });
  final String eventId, id, name;
  final String? nationalId, location;
  final int? companions;
  final bool checkedIn, pendingSync;
  final DateTime? checkedInAt;

  List<String> get missingFields => List.unmodifiable([
    if (name.trim().isEmpty) 'الاسم',
    if (nationalId == null || !RegExp(r'^\d{14}$').hasMatch(nationalId!))
      'الرقم القومي',
    if (companions == null || companions! < 0) 'عدد المرافقين',
    if (location == null || location!.trim().isEmpty) 'المكان',
  ]);
  bool get isComplete => missingFields.isEmpty;
}

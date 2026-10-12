import 'dart:convert';

class QrPayload {
  const QrPayload(this.eventId, this.guestId);
  final String eventId, guestId;
  String encode() =>
      jsonEncode({'v': 1, 'eventId': eventId, 'guestId': guestId});

  static QrPayload? parse(String input) {
    if (input.length > 2048) return null;
    try {
      final value = jsonDecode(input);
      if (value is! Map<String, dynamic> ||
          (value.containsKey('v') && value['v'] != 1)) {
        return null;
      }
      final event = value['eventId'];
      final guest = value['guestId'];
      if (event is! String ||
          guest is! String ||
          event.trim().isEmpty ||
          guest.trim().isEmpty ||
          event.length > 128 ||
          guest.length > 128) {
        return null;
      }
      return QrPayload(event.trim(), guest.trim());
    } on FormatException {
      return null;
    }
  }
}

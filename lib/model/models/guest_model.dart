class Guest {
  final int? id; // primary key
  final String guestId; // qr id
  final String name;
  final String location;
  final int companions;
  final bool verified;

  Guest({
    this.id,
    required this.guestId,
    required this.name,
    required this.location,
    required this.companions,
    this.verified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guestId': guestId,
      'name': name,
      'location': location,
      'companions': companions,
      'verified': verified ? 1 : 0,
    };
  }

  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(
      id: map['id'],
      guestId: map['guestId'],
      name: map['name'],
      location: map['location'],
      companions: map['companions'],
      verified: map['verified'] == 1,
    );
  }
}

import '../../domain/models/guest.dart';

class DemoGuestSource {
  static const eventId = 'demo-graduation';
  // Deliberately synthetic identifiers; not real national identity records.
  List<Guest> load() => const [
    Guest(
      eventId: eventId,
      id: 'GUEST-001',
      name: 'أحمد محمد علي',
      nationalId: '00000000000001',
      companions: 2,
      location: 'القاعة الرئيسية • طاولة 12',
    ),
    Guest(
      eventId: eventId,
      id: 'GUEST-002',
      name: 'سارة محمود حسن',
      nationalId: '00000000000002',
      companions: 1,
      location: 'القاعة الرئيسية • طاولة 8',
    ),
    Guest(
      eventId: eventId,
      id: 'GUEST-003',
      name: 'يوسف خالد إبراهيم',
      nationalId: '00000000000003',
      companions: 0,
      location: 'القاعة الثانية • طاولة 4',
    ),
    Guest(
      eventId: eventId,
      id: 'GUEST-004',
      name: 'مريم تامر أحمد',
      nationalId: '00000000000004',
      companions: 3,
    ),
  ];
}

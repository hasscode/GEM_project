import 'package:flutter/material.dart';
import '../../../demo_data/presentation/widgets/guest_ticket.dart';
import '../../domain/models/guest.dart';
import 'guest_details.dart';

class GuestCard extends StatelessWidget {
  const GuestCard({super.key, required this.guest});
  final Guest guest;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GuestDetails(guest: guest),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => GuestTicket(guest: guest),
            ),
            icon: const Icon(Icons.qr_code_rounded),
            label: const Text('عرض تذكرة QR'),
          ),
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_theme.dart';
import '../../../guests/domain/models/event_snapshot.dart';

class EventHero extends StatelessWidget {
  const EventHero({super.key, required this.snapshot});
  final EventSnapshot snapshot;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: AppTheme.navy,
      borderRadius: BorderRadius.circular(28),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.celebration_outlined, color: AppTheme.mint),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'كل ضيف، لحظة مميزة',
                style: TextStyle(color: AppTheme.mint),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          snapshot.event?.name ?? 'أهلًا بمناسبتك القادمة',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'استقبال منظم. حضور محفوظ. حتى بدون إنترنت.',
          style: TextStyle(color: Colors.white70, height: 1.6),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppTheme.mint,
            foregroundColor: AppTheme.navy,
          ),
          onPressed: snapshot.total == 0
              ? () => context.go('/demo')
              : () => context.push('/scan'),
          icon: Icon(
            snapshot.total == 0
                ? Icons.add_rounded
                : Icons.qr_code_scanner_rounded,
          ),
          label: Text(
            snapshot.total == 0
                ? 'ابدأ بالبيانات التجريبية'
                : 'مسح تذكرة الدخول',
          ),
        ),
        if (snapshot.total > 0) ...[
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: snapshot.checkedIn / snapshot.total,
            color: AppTheme.mint,
            backgroundColor: Colors.white12,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 10),
          Text(
            'حضر ${snapshot.checkedIn} من ${snapshot.total} ضيف',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ],
    ),
  );
}

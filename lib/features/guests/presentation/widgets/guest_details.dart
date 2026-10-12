import 'package:flutter/material.dart';
import '../../../../app/app_theme.dart';
import '../../domain/models/guest.dart';
import '../../../../core/widgets/status_pill.dart';

class GuestDetails extends StatelessWidget {
  const GuestDetails({super.key, required this.guest});
  final Guest guest;
  @override
  Widget build(BuildContext context) {
    final time = guest.checkedInAt?.toLocal();
    final timeLabel = time == null
        ? 'الوقت غير مسجل'
        : MaterialLocalizations.of(context).formatTimeOfDay(
            TimeOfDay.fromDateTime(time),
            alwaysUse24HourFormat: true,
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          guest.name.isEmpty ? 'اسم غير مسجل' : guest.name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.navy,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            StatusPill(
              text: guest.checkedIn ? 'حاضر • $timeLabel' : 'لم يحضر بعد',
              filled: guest.checkedIn,
            ),
            StatusPill(
              text: guest.isComplete ? 'بيانات مكتملة' : 'بيانات ناقصة',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'الرقم القومي: ${guest.nationalId ?? 'غير مسجل'}',
          style: const TextStyle(height: 1.8),
        ),
        Text(
          'المرافقون: ${guest.companions ?? 'غير مسجل'}',
          style: const TextStyle(height: 1.8),
        ),
        Text(
          'المكان: ${guest.location ?? 'غير مسجل'}',
          style: const TextStyle(height: 1.8),
        ),
        if (!guest.isComplete)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'يحتاج مراجعة: ${guest.missingFields.join('، ')}',
              style: const TextStyle(fontWeight: FontWeight.w600, height: 1.6),
            ),
          ),
      ],
    );
  }
}

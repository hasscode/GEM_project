import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_theme.dart';
import '../../../guests/presentation/widgets/guest_details.dart';
import '../../domain/check_in_result.dart';

class CheckInDialog extends StatelessWidget {
  const CheckInDialog({super.key, this.result, this.error});
  final CheckInResult? result;
  final String? error;
  @override
  Widget build(BuildContext context) {
    final title = switch (result?.status) {
      CheckInStatus.accepted => 'Accepted • تم قبول الدخول',
      CheckInStatus.alreadyCheckedIn => 'حاضر بالفعل',
      CheckInStatus.notFound => 'الضيف غير موجود',
      CheckInStatus.invalidQr => 'رمز غير صالح',
      CheckInStatus.wrongEvent => 'تذكرة لمناسبة أخرى',
      CheckInStatus.incomplete => 'البيانات تحتاج مراجعة',
      null => 'تعذر تسجيل الحضور',
    };
    final message = switch (result?.status) {
      CheckInStatus.accepted => 'تم حفظ الحضور بنجاح على هذا الجهاز.',
      CheckInStatus.alreadyCheckedIn =>
        'تم تسجيل دخول هذا الضيف سابقًا. لم يتم تسجيل حضور جديد.',
      CheckInStatus.notFound =>
        'التذكرة غير موجودة في قائمة هذه المناسبة. يمكنك البحث يدويًا للتأكد.',
      CheckInStatus.invalidQr =>
        'استخدم تذكرة EEM تحتوي على معرف الضيف والمناسبة.',
      CheckInStatus.wrongEvent => 'افتح المناسبة الصحيحة قبل مسح هذه التذكرة.',
      CheckInStatus.incomplete =>
        'لم يتم تسجيل الحضور. راجع الحقول الناقصة مع منظم المناسبة.',
      null => error ?? 'حاول مرة أخرى.',
    };
    return AlertDialog(
      icon: Icon(
        result?.status == CheckInStatus.accepted
            ? Icons.task_alt
            : Icons.info_outline,
        color: AppTheme.navy,
        size: 44,
      ),
      title: Text(title, textAlign: TextAlign.center),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: const TextStyle(height: 1.6)),
              if (result?.guest case final guest?) ...[
                const Divider(height: 32),
                GuestDetails(guest: guest),
              ],
            ],
          ),
        ),
      ),
      actions: [
        if (result?.status == CheckInStatus.incomplete ||
            result?.status == CheckInStatus.notFound)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/guests');
            },
            child: const Text('البحث في الضيوف'),
          ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('تم'),
        ),
      ],
    );
  }
}

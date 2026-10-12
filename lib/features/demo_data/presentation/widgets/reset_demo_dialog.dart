import 'package:flutter/material.dart';

class ResetDemoDialog extends StatelessWidget {
  const ResetDemoDialog({super.key});
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('إعادة التجربة من البداية؟'),
    content: const Text(
      'سيتم استبدال الضيوف التجريبيين الأربعة ومسح حضورهم المحلي، بما فيه الحضور غير المرفوع. القوائم الأخرى ستبقى محفوظة.',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: const Text('إلغاء'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text('إعادة توليد البيانات'),
      ),
    ],
  );
}

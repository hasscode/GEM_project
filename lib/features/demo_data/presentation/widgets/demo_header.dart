import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/page_heading.dart';
import '../../../../core/widgets/notice_card.dart';
import '../../../guests/presentation/cubit/event_state.dart';

class DemoHeader extends StatelessWidget {
  const DemoHeader({
    super.key,
    required this.state,
    required this.exists,
    required this.onGenerate,
  });
  final EventState state;
  final bool exists;
  final VoidCallback onGenerate;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const PageHeading(
        title: 'جرّب تجربة الاستقبال',
        subtitle: 'أربع تذاكر تجريبية، وجاهزية كاملة للعمل بدون إنترنت.',
      ),
      const NoticeCard(
        icon: Icons.auto_awesome_outlined,
        message:
            'التجربة تضم ٤ أسماء بأرقام وهمية: ٣ سجلات مكتملة وسجل مريم بدون مكان لاختبار مراجعة البيانات. يمكنك نسخ رمز التذكرة وتجربته من شاشة المسح على نفس الجهاز.',
      ),
      const SizedBox(height: 20),
      FilledButton.icon(
        onPressed: state.saving || state.loading ? null : onGenerate,
        icon: const Icon(Icons.add_circle_outline),
        label: Text(
          state.saving
              ? 'جارٍ تجهيز البيانات…'
              : exists
              ? 'إعادة توليد البيانات التجريبية'
              : 'توليد ٤ ضيوف تجريبيين',
        ),
      ),
      if (state.saving || state.loading)
        const Padding(
          padding: EdgeInsets.all(16),
          child: LinearProgressIndicator(),
        ),
      if (state.error != null) NoticeCard(message: state.error!),
      if ((state.snapshot?.total ?? 0) > 0) ...[
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.push('/scan'),
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('فتح ماسح التذاكر'),
        ),
        const SizedBox(height: 24),
        const Text(
          'تذاكر المناسبة الحالية',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ],
    ],
  );
}

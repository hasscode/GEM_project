import 'package:flutter/material.dart';
import '../../../guests/domain/models/event_snapshot.dart';
import 'stat_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key, required this.snapshot});
  final EventSnapshot snapshot;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = constraints.maxWidth > 760
          ? 4
          : constraints.maxWidth < 330
          ? 1
          : 2;
      final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
      final items = [
        ('إجمالي الضيوف', snapshot.total, Icons.people_outline),
        ('تم تسجيل حضورهم', snapshot.checkedIn, Icons.task_alt),
        ('في انتظار الوصول', snapshot.remaining, Icons.schedule),
        (
          'بيانات تحتاج مراجعة',
          snapshot.incomplete,
          Icons.person_search_outlined,
        ),
      ];
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final item in items)
            SizedBox(
              width: width,
              child: StatCard(title: item.$1, value: item.$2, icon: item.$3),
            ),
        ],
      );
    },
  );
}

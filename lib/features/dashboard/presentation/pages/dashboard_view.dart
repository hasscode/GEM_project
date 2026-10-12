import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/notice_card.dart';
import '../../../../core/widgets/page_heading.dart';
import '../../../guests/presentation/cubit/event_cubit.dart';
import '../../../guests/presentation/cubit/event_state.dart';
import '../widgets/event_hero.dart';
import '../widgets/stats_section.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key, required this.state});
  final EventState state;
  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () => context.read<EventCubit>().load(),
    child: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const PageHeading(
          title: 'حضور يليق بالمناسبة',
          subtitle: 'كل تفاصيل الاستقبال، في مكان واحد.',
        ),
        if (state.loading) const LinearProgressIndicator(),
        if (state.error != null)
          NoticeCard(
            message: state.error!,
            action: TextButton(
              onPressed: () => context.read<EventCubit>().load(),
              child: const Text('إعادة المحاولة'),
            ),
          ),
        if (state.snapshot case final snapshot?) ...[
          if (snapshot.events.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButtonFormField<String>(
                initialValue: snapshot.activeEventId,
                key: ValueKey(snapshot.activeEventId),
                decoration: const InputDecoration(labelText: 'المناسبة'),
                items: snapshot.events
                    .map(
                      (e) => DropdownMenuItem(value: e.id, child: Text(e.name)),
                    )
                    .toList(),
                onChanged: state.loading
                    ? null
                    : (id) => context.read<EventCubit>().load(eventId: id),
              ),
            ),
          EventHero(snapshot: snapshot),
          const SizedBox(height: 24),
          StatsSection(snapshot: snapshot),
          const SizedBox(height: 24),
          NoticeCard(
            icon: Icons.cloud_off_outlined,
            message:
                'الحضور محفوظ على هذا الجهاز • ${snapshot.pending} سجل بانتظار المزامنة.\nربط الخادم غير متاح بعد. لا تحتاج إلى الإنترنت أثناء الاستقبال.',
          ),
          if (snapshot.lastUpdatedAt?.toLocal() case final updated?)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'آخر تحديث محلي: ${MaterialLocalizations.of(context).formatCompactDate(updated)} • ${MaterialLocalizations.of(context).formatTimeOfDay(TimeOfDay.fromDateTime(updated), alwaysUse24HourFormat: true)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.go('/guests'),
            icon: const Icon(Icons.manage_search),
            label: const Text('البحث ومراجعة بيانات الضيوف'),
          ),
        ],
      ],
    ),
  );
}

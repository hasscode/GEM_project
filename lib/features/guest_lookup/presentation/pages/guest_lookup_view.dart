import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/guest_lookup_cubit.dart';
import '../cubit/guest_lookup_state.dart';
import '../../../../core/widgets/page_heading.dart';
import '../../../../core/widgets/notice_card.dart';
import '../../../guests/presentation/cubit/event_state.dart';
import '../../../guests/presentation/widgets/guest_card.dart';
import '../../domain/search_guests.dart';

class GuestLookupView extends StatelessWidget {
  const GuestLookupView({super.key, required this.state, required this.filter});
  final EventState state;
  final GuestLookupState filter;
  @override
  Widget build(BuildContext context) {
    final guests = searchGuests(
      state.snapshot?.guests ?? [],
      filter.query,
      filter.mode,
      incompleteOnly: filter.incompleteOnly,
    );
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          sliver: SliverList.list(
            children: [
              const PageHeading(
                title: 'اعرف ضيفك',
                subtitle: 'ابحث بالاسم أو الرقم القومي، وراجع أي بيانات ناقصة.',
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('الاسم'),
                    selected: filter.mode == SearchMode.name,
                    onSelected: (_) => context
                        .read<GuestLookupCubit>()
                        .changeMode(SearchMode.name),
                  ),
                  ChoiceChip(
                    label: const Text('الرقم القومي'),
                    selected: filter.mode == SearchMode.nationalId,
                    onSelected: (_) => context
                        .read<GuestLookupCubit>()
                        .changeMode(SearchMode.nationalId),
                  ),
                  FilterChip(
                    label: const Text('بيانات ناقصة فقط'),
                    selected: filter.incompleteOnly,
                    onSelected: (v) =>
                        context.read<GuestLookupCubit>().showIncomplete(v),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) =>
                    context.read<GuestLookupCubit>().search(value),
                keyboardType: filter.mode == SearchMode.nationalId
                    ? TextInputType.number
                    : TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  labelText: filter.mode == SearchMode.name
                      ? 'اكتب الاسم أو جزءًا منه'
                      : 'اكتب الرقم القومي كاملًا',
                ),
              ),
              const SizedBox(height: 16),
              if (state.loading) const LinearProgressIndicator(),
              if (state.error != null) NoticeCard(message: state.error!),
              Text('${guests.length} نتيجة'),
              const SizedBox(height: 16),
              if (guests.isEmpty)
                const NoticeCard(
                  icon: Icons.person_search,
                  message:
                      'لا توجد نتائج مطابقة. تأكد من الاسم أو الرقم، ومن تحميل بيانات المناسبة.',
                ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          sliver: SliverList.builder(
            itemCount: guests.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GuestCard(guest: guests[index]),
            ),
          ),
        ),
      ],
    );
  }
}

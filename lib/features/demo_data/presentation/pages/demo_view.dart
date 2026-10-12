import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../guests/presentation/cubit/event_cubit.dart';
import '../../../guests/presentation/cubit/event_state.dart';
import '../../../guests/presentation/widgets/guest_card.dart';
import '../widgets/demo_header.dart';
import '../widgets/reset_demo_dialog.dart';

class DemoView extends StatelessWidget {
  const DemoView({super.key, required this.state});
  final EventState state;
  Future<void> _generate(BuildContext context, bool exists) async {
    if (exists) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (_) => const ResetDemoDialog(),
      );
      if (confirmed != true || !context.mounted) return;
    }
    await context.read<EventCubit>().generateDemo(replace: exists);
  }

  @override
  Widget build(BuildContext context) {
    final guests = state.snapshot?.guests ?? [];
    final exists =
        state.snapshot?.events.any((e) => e.id == 'demo-graduation') ?? false;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverToBoxAdapter(
            child: DemoHeader(
              state: state,
              exists: exists,
              onGenerate: () => _generate(context, exists),
            ),
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

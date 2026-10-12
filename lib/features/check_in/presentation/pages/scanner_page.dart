import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/notice_card.dart';
import '../../../../core/widgets/page_heading.dart';
import '../../../guests/domain/repositories/guest_repository.dart';
import '../../../guests/presentation/cubit/event_cubit.dart';
import '../../domain/check_in_guest.dart';
import '../cubit/check_in_cubit.dart';
import 'scanner_view.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});
  @override
  Widget build(BuildContext context) {
    final eventId = context.read<EventCubit>().state.snapshot?.activeEventId;
    return Scaffold(
      appBar: AppBar(title: const Text('استقبال الضيوف')),
      body: SafeArea(
        child: eventId == null
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    PageHeading(
                      title: 'لا توجد مناسبة جاهزة',
                      subtitle: 'حمّل البيانات التجريبية أولًا.',
                    ),
                    NoticeCard(
                      message: 'ارجع إلى صفحة التجربة لتجهيز الضيوف والتذاكر.',
                    ),
                  ],
                ),
              )
            : BlocProvider(
                create: (context) =>
                    CheckInCubit(CheckInGuest(context.read<GuestRepository>())),
                child: ScannerView(eventId: eventId),
              ),
      ),
    );
  }
}

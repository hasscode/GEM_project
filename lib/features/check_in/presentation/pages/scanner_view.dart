import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../guests/presentation/cubit/event_cubit.dart';
import '../cubit/check_in_cubit.dart';
import '../cubit/check_in_state.dart';
import '../widgets/scanner_content.dart';
import '../widgets/check_in_dialog.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key, required this.eventId});
  final String eventId;
  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  bool _armed = true;
  void _scan(String raw) {
    if (!_armed) return;
    setState(() => _armed = false);
    context.read<CheckInCubit>().scan(raw, widget.eventId);
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<CheckInCubit, CheckInState>(
        listener: (context, state) async {
          if (state.result == null && state.error == null) return;
          // Refresh only after the attendance transaction has completed.
          context.read<EventCubit>().load();
          await showDialog<void>(
            context: context,
            builder: (_) =>
                CheckInDialog(result: state.result, error: state.error),
          );
          if (context.mounted) context.read<CheckInCubit>().reset();
        },
        builder: (context, state) => ScannerContent(
          state: state,
          armed: _armed,
          onScan: _scan,
          onResume: () => setState(() => _armed = true),
          onSubmit: (raw) {
            setState(() => _armed = false);
            context.read<CheckInCubit>().scan(raw, widget.eventId);
          },
        ),
      );
}

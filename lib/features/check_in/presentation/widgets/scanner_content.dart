import 'package:flutter/material.dart';
import '../../../../core/widgets/page_heading.dart';
import '../cubit/check_in_state.dart';
import 'camera_panel.dart';
import 'manual_ticket_input.dart';

class ScannerContent extends StatelessWidget {
  const ScannerContent({
    super.key,
    required this.state,
    required this.armed,
    required this.onScan,
    required this.onResume,
    required this.onSubmit,
  });
  final CheckInState state;
  final bool armed;
  final ValueChanged<String> onScan, onSubmit;
  final VoidCallback onResume;
  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !state.busy,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const PageHeading(
              title: 'كل تذكرة، ترحيب جديد',
              subtitle:
                  'وجّه الكاميرا نحو QR. يتم حفظ الحضور مباشرة على الجهاز.',
            ),
            CameraPanel(
              active: armed,
              onScan: onScan,
              onResume:
                  state.busy || state.result != null || state.error != null
                  ? null
                  : onResume,
            ),
            if (state.busy)
              const Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 24),
            ManualTicketInput(
              enabled:
                  !state.busy && state.result == null && state.error == null,
              onSubmit: onSubmit,
            ),
          ],
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

class ManualTicketInput extends StatefulWidget {
  const ManualTicketInput({
    super.key,
    required this.onSubmit,
    required this.enabled,
  });
  final ValueChanged<String> onSubmit;
  final bool enabled;
  @override
  State<ManualTicketInput> createState() => _ManualTicketInputState();
}

class _ManualTicketInputState extends State<ManualTicketInput> {
  final _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'تجربة التذكرة على نفس الجهاز',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'انسخ الرمز من صفحة التذكرة، ثم الصقه هنا. سيُسجَّل الحضور بنفس قواعد المسح.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            enabled: widget.enabled,
            maxLines: 3,
            textDirection: TextDirection.ltr,
            maxLength: 2048,
            decoration: const InputDecoration(
              labelText: 'رمز التذكرة',
              hintText: '{"eventId": "...", "guestId": "..."}',
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: widget.enabled
                ? () => widget.onSubmit(_controller.text)
                : null,
            child: const Text('التحقق وتسجيل الحضور'),
          ),
        ],
      ),
    ),
  );
}

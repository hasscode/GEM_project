import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../app/app_theme.dart';
import '../../../check_in/domain/qr_payload.dart';
import '../../../guests/domain/models/guest.dart';

class GuestTicket extends StatelessWidget {
  const GuestTicket({super.key, required this.guest});
  final Guest guest;
  @override
  Widget build(BuildContext context) {
    final raw = QrPayload(guest.eventId, guest.id).encode();
    return AlertDialog(
      title: const Text('تذكرة الدخول'),
      content: SizedBox(
        width: 320,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                guest.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: QrImageView(
                  data: raw,
                  size: 220,
                  padding: const EdgeInsets.all(12),
                  semanticsLabel: 'QR تذكرة ${guest.name}',
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: AppTheme.navy,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: AppTheme.navy,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(guest.id, textDirection: TextDirection.ltr),
              const SizedBox(height: 12),
              const Text(
                'افتح التذكرة على جهاز آخر أو التقط صورة للشاشة لمسحها. الرمز يحتوي معرف التذكرة والمناسبة فقط.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.muted, height: 1.6),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () async {
            await Clipboard.setData(ClipboardData(text: raw));
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم نسخ رمز التذكرة')),
              );
            }
          },
          icon: const Icon(Icons.copy_outlined),
          label: const Text('نسخ الرمز'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}

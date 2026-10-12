import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../app/app_theme.dart';
import '../../../../core/widgets/notice_card.dart';

class CameraPanel extends StatefulWidget {
  const CameraPanel({
    super.key,
    required this.onScan,
    required this.active,
    required this.onResume,
  });
  final ValueChanged<String> onScan;
  final bool active;
  final VoidCallback? onResume;
  @override
  State<CameraPanel> createState() => _CameraPanelState();
}

class _CameraPanelState extends State<CameraPanel> {
  int _revision = 0;
  @override
  Widget build(BuildContext context) {
    final supported =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS);
    if (!supported) {
      return const NoticeCard(
        icon: Icons.camera_alt_outlined,
        message:
            'مسح الكاميرا متاح على Android وiPhone وmacOS. على هذا الجهاز يمكنك تجربة التذكرة بنسخ رمزها ولصقه أدناه.',
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AspectRatio(
        aspectRatio: 1,
        child: widget.active
            ? MobileScanner(
                key: ValueKey(_revision),
                onDetect: (capture) {
                  for (final barcode in capture.barcodes) {
                    final raw = barcode.rawValue;
                    if (raw != null) {
                      widget.onScan(raw);
                      break;
                    }
                  }
                },
                errorBuilder: (_, _) => ColoredBox(
                  color: AppTheme.canvas,
                  child: Center(
                    child: NoticeCard(
                      icon: Icons.no_photography_outlined,
                      message:
                          'الكاميرا غير متاحة. اسمح بالوصول إليها من إعدادات الجهاز أو استخدم رمز التذكرة.',
                      action: OutlinedButton(
                        onPressed: () => setState(() => _revision++),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ),
                  ),
                ),
              )
            : ColoredBox(
                color: AppTheme.navy,
                child: Center(
                  child: FilledButton.icon(
                    onPressed: widget.onResume,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.mint,
                      foregroundColor: AppTheme.navy,
                    ),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('مسح تذكرة أخرى'),
                  ),
                ),
              ),
      ),
    );
  }
}

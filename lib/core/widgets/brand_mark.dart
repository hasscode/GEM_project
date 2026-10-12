import 'package:flutter/material.dart';
import '../../app/app_theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({super.key});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: AppTheme.navy,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.qr_code_rounded,
          color: AppTheme.mint,
          size: 24,
        ),
      ),
      const SizedBox(width: 12),
      const Flexible(
        child: Text(
          'EEM',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2),
        ),
      ),
      const SizedBox(width: 10),
      if (MediaQuery.sizeOf(context).width > 380)
        const Flexible(
          child: Text(
            'لحظات تستحق التنظيم',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: AppTheme.muted),
          ),
        ),
    ],
  );
}

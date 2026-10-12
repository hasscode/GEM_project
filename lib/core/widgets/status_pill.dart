import 'package:flutter/material.dart';
import '../../app/app_theme.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.text, this.filled = false});
  final String text;
  final bool filled;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: filled ? AppTheme.mint : AppTheme.canvas,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppTheme.navy,
      ),
    ),
  );
}

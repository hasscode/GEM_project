import 'package:flutter/material.dart';
import '../../app/app_theme.dart';

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.action,
  });
  final String message;
  final IconData icon;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppTheme.navy),
              const SizedBox(width: 12),
              Expanded(
                child: Text(message, style: const TextStyle(height: 1.6)),
              ),
            ],
          ),
          if (action != null)
            Padding(padding: const EdgeInsets.only(top: 12), child: action!),
        ],
      ),
    ),
  );
}

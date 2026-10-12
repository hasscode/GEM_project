import 'package:flutter/material.dart';
import '../../../../app/app_theme.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });
  final String title;
  final int value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.navy),
          const SizedBox(height: 18),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppTheme.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: AppTheme.muted)),
        ],
      ),
    ),
  );
}

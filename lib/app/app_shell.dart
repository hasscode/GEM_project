import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/brand_mark.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.path, required this.child});
  final String path;
  final Widget child;
  static const paths = ['/', '/guests', '/demo'];
  @override
  Widget build(BuildContext context) {
    final selected = paths.indexOf(path).clamp(0, 2);
    final wide = MediaQuery.sizeOf(context).width >= 850;
    return Scaffold(
      appBar: AppBar(
        title: const BrandMark(),
        actions: const [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 20),
            child: Tooltip(
              message: 'الحضور يُحفظ على هذا الجهاز',
              child: Icon(Icons.offline_bolt_outlined),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            if (wide)
              NavigationRail(
                selectedIndex: selected,
                labelType: NavigationRailLabelType.all,
                onDestinationSelected: (i) => context.go(paths[i]),
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.grid_view_rounded),
                    label: Text('نظرة عامة'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.people_outline_rounded),
                    label: Text('الضيوف'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.confirmation_number_outlined),
                    label: Text('التجربة والتذاكر'),
                  ),
                ],
              ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: selected,
              onDestinationSelected: (i) => context.go(paths[i]),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.grid_view_rounded),
                  label: 'نظرة عامة',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline_rounded),
                  label: 'الضيوف',
                ),
                NavigationDestination(
                  icon: Icon(Icons.confirmation_number_outlined),
                  label: 'التجربة',
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import '../features/check_in/presentation/pages/scanner_page.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/demo_data/presentation/pages/demo_page.dart';
import '../features/guest_lookup/presentation/pages/guest_lookup_page.dart';
import '../features/guests/domain/repositories/guest_repository.dart';
import '../features/guests/presentation/cubit/event_cubit.dart';
import 'app_shell.dart';
import 'app_theme.dart';

class GEMApp extends StatefulWidget {
  const GEMApp({super.key, required this.repository});
  final GuestRepository repository;
  @override
  State<GEMApp> createState() => _GEMAppState();
}

class _GEMAppState extends State<GEMApp> {
  late final GoRouter _router = GoRouter(
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(path: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/', builder: (_, _) => const DashboardPage()),
          GoRoute(path: '/guests', builder: (_, _) => const GuestLookupPage()),
          GoRoute(path: '/demo', builder: (_, _) => const DemoPage()),
        ],
      ),
      GoRoute(path: '/scan', builder: (_, _) => const ScannerPage()),
    ],
  );
  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RepositoryProvider.value(
    value: widget.repository,
    child: BlocProvider(
      create: (_) => EventCubit(widget.repository)..load(),
      child: MaterialApp.router(
        title: 'EEM • إدارة الحضور',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        routerConfig: _router,
      ),
    ),
  );
}

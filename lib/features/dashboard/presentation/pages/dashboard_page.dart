import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../guests/presentation/cubit/event_cubit.dart';
import '../../../guests/presentation/cubit/event_state.dart';
import 'dashboard_view.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  @override
  Widget build(BuildContext context) => BlocBuilder<EventCubit, EventState>(
    builder: (context, state) => DashboardView(state: state),
  );
}

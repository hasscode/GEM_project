import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../guests/presentation/cubit/event_cubit.dart';
import '../../../guests/presentation/cubit/event_state.dart';
import 'demo_view.dart';

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});
  @override
  Widget build(BuildContext context) => BlocBuilder<EventCubit, EventState>(
    builder: (context, state) => DemoView(state: state),
  );
}

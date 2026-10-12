import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../guests/presentation/cubit/event_cubit.dart';
import '../../../guests/presentation/cubit/event_state.dart';
import '../cubit/guest_lookup_cubit.dart';
import '../cubit/guest_lookup_state.dart';
import 'guest_lookup_view.dart';

class GuestLookupPage extends StatelessWidget {
  const GuestLookupPage({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => GuestLookupCubit(),
    child: BlocBuilder<EventCubit, EventState>(
      builder: (context, state) =>
          BlocBuilder<GuestLookupCubit, GuestLookupState>(
            builder: (context, filter) =>
                GuestLookupView(state: state, filter: filter),
          ),
    ),
  );
}

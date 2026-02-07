// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gem_project/view/screens/home_screen.dart';
import '../../core/styles/app_colors.dart';
import '../../view_model/initialization_cubit/initialization_cubit.dart';
import '../../view_model/initialization_cubit/initialization_state.dart';
import '../widgets/splash_screen_body_widget.dart';
import 'all_guests_screen.dart';
import 'data_initialization_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitializationCubit, InitializationState>(
      listener: (context, state) {
        if (state is InitializationEmpty) {

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (newContext) => BlocProvider.value(
                value: context.read<InitializationCubit>(),
                child: const DataInitializationPage(),
              ),
            ),
          );
        }

        if (state is InitializationReady) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: const SplashScreenBodyWidget(),
      ),
    );
  }
}
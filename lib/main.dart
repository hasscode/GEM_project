// main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gem_project/view/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gem_project/view_model/initialization_cubit/initialization_cubit.dart';
import 'model/repositories/guest_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF102A43),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await ScreenUtil.ensureScreenSize();
  runApp(const GEMApp());
}

class GEMApp extends StatelessWidget {
  const GEMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => GuestRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => InitializationCubit(
              context.read<GuestRepository>(),
            )..checkInitialization(),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, __) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),  // ✅ بدون BlocProvider هنا
            );
          },
        ),
      ),
    );
  }
}
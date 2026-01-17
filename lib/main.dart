import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/core.dart';
import 'core/routes/app_pages.dart';
import 'features/splash/bloc/splash_routing_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await StorageService.init();
  await HiveService.init();

  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Splash routing BLoC for authentication status checking
        BlocProvider(create: (_) => SplashRoutingBloc()),
        // Add other BLoCs here as needed
      ],
      child: MaterialApp.router(
        title: 'Parking Application',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appPages,
      ),
    );
  }
}

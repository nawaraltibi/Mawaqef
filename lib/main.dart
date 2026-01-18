import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'l10n/app_localizations.dart';
import 'core/core.dart';
import 'core/routes/app_pages.dart';
import 'data/datasources/network/api_config.dart';
import 'features/splash/bloc/splash_routing_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await StorageService.init();
  await HiveService.init();

  // Print API configuration for debugging
  if (kDebugMode) {
    print('🚀 API Configuration:');
    print('   Base URL: ${APIConfig.baseUrl}');
    print('   API Endpoint: ${APIConfig.appAPI}');
    print('   Host: ${APIConfig.host}');
    print('');
  }

  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
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
            // Localization support
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        );
      },
    );
  }
}

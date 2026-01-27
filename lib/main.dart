import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart';
import 'l10n/app_localizations.dart';
import 'core/core.dart';
import 'core/routes/app_pages.dart';
import 'core/services/language_service.dart';
import 'core/injection/service_locator.dart';
import 'data/datasources/network/api_config.dart';
import 'features/splash/bloc/splash_routing_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إخفاء الـ system navigation bar (أزرار الرجوع والـ home والـ layers)
  // مع إبقاء الـ status bar ظاهراً
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top], // إبقاء الـ status bar فقط، إخفاء الـ navigation bar
  );

  // Initialize services
  await StorageService.init();
  await HiveService.init();

  // Initialize Dependency Injection
  await setupServiceLocator();

  // Print API configuration for debugging
  if (kDebugMode) {
    print('🚀 API Configuration:');
    print('   Base URL: ${APIConfig.baseUrl}');
    print('   API Endpoint: ${APIConfig.appAPI}');
    print('   Host: ${APIConfig.host}');
    print('   Default Language: ${LanguageService.getLanguage()}');
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
            // Locale Cubit for language management - must be provided at app level
            BlocProvider(create: (_) => getIt<LocaleCubit>()),
            // Splash routing BLoC for authentication status checking
            BlocProvider(create: (_) => getIt<SplashRoutingBloc>()),
            // Add other app-wide BLoCs here as needed
          ],
          child: BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp.router(
                title: 'Parking Application',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                routerConfig: appPages,
                // Localization support with language persistence
                // Locale is controlled by LocaleCubit - MaterialApp rebuilds when state changes
                locale: localeState.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          ),
        );
      },
    );
  }
}

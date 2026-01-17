import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/splash_routing_bloc.dart';
import 'splash_screen.dart';

/// Splash Page
/// Wrapper page that initializes the splash routing check
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Trigger authentication status check when page loads
    context.read<SplashRoutingBloc>().add(const SplashCheckStatus());
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}


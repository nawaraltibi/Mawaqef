import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../bloc/splash_routing_bloc.dart';
import '../../../../core/routes/app_routes.dart';

/// Splash Screen Widget
/// Displays loading animation and handles navigation based on authentication status
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _showContent = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start animation after a short delay
    Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashRoutingBloc, SplashRoutingState>(
      listener: (context, state) async {
        if (state is SplashLoaded) {
          // Store references before async operations
          final route = () {
            switch (state.destination) {
              case SplashDestination.onboarding:
                return Routes.onboardingPath;
              case SplashDestination.authenticated:
                return Routes.mainScreenPath;
              case SplashDestination.unauthenticated:
                return Routes.loginPath;
            }
          }();
          final router = GoRouter.of(context);
          
          // Wait for animation to complete if needed
          if (!_showContent) {
            await Future.delayed(const Duration(milliseconds: 500));
          }
          await Future.delayed(const Duration(milliseconds: 200));
          
          if (!mounted) return;
          router.go(route);
        } else if (state is SplashError) {
          if (!mounted) return;
          // On error, retry checking status
          context.read<SplashRoutingBloc>().add(const SplashCheckStatus());
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: AnimatedOpacity(
            opacity: _showContent ? _fadeAnimation.value : 0.0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Icon placeholder
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.local_parking,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),
                // App Name
                Text(
                  'Parking App',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 48),
                // Loading indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


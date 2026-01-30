import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/server_host_input_dialog.dart';
import '../../../../data/datasources/network/api_config.dart';
import '../bloc/splash_routing_bloc.dart';
import 'splash_screen.dart';

/// Splash Page
/// Shows server host dialog on first launch if no host is saved, then runs splash routing check.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureHostThenCheckStatus());
  }

  /// If dynamic host is disabled, use fixed URL and skip dialog.
  /// Otherwise if a host is already saved, trigger splash check; else show IP dialog.
  Future<void> _ensureHostThenCheckStatus() async {
    if (!mounted) return;
    if (!APIConfig.useDynamicApiHost) {
      context.read<SplashRoutingBloc>().add(const SplashCheckStatus());
      return;
    }
    if (APIConfig.hasStoredHost) {
      context.read<SplashRoutingBloc>().add(const SplashCheckStatus());
      return;
    }
    final host = await ServerHostInputDialog.show(
      context,
      initialValue: APIConfig.host,
      hintText: '192.168.1.6',
    );
    if (!mounted) return;
    if (host != null && host.isNotEmpty) {
      await APIConfig.setHost(host);
      if (!mounted) return;
      context.read<SplashRoutingBloc>().add(const SplashCheckStatus());
    } else {
      // User cancelled; re-show dialog after a short delay so they can enter host
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _ensureHostThenCheckStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}

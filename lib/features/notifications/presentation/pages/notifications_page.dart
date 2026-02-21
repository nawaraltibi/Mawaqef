import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/notifications_bloc.dart';
import 'notifications_screen.dart';

/// Notifications Page
/// Provides NotificationsBloc (singleton) and triggers initial load
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use BlocProvider.value since NotificationsBloc is a singleton
    return BlocProvider<NotificationsBloc>.value(
      value: getIt<NotificationsBloc>(),
      child: const NotificationsScreen(),
    );
  }
}


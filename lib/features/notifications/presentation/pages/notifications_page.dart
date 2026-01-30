import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/notifications_bloc.dart';
import 'notifications_screen.dart';

/// Notifications Page
/// Provides NotificationsBloc and triggers initial load
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsBloc>(
      create: (_) => getIt<NotificationsBloc>(),
      child: const NotificationsScreen(),
    );
  }
}


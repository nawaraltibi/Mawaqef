import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/violations_bloc.dart';
import 'violations_screen.dart';

/// Violations Page
/// Provides ViolationsBloc and triggers initial load
class ViolationsPage extends StatelessWidget {
  const ViolationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ViolationsBloc>(
      create: (_) => getIt<ViolationsBloc>(),
      child: const ViolationsScreen(),
    );
  }
}


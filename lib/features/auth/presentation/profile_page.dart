import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/logout_cubit.dart';
import 'profile_screen.dart';

/// Profile Page
/// Provides BlocProvider for LogoutCubit
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(),
      child: const ProfileScreen(),
    );
  }
}


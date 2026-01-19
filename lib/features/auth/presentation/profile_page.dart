import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/logout/logout_bloc.dart';
import 'profile_screen.dart';

/// Profile Page
/// Provides BlocProvider for LogoutBloc
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutBloc(),
      child: const ProfileScreen(),
    );
  }
}


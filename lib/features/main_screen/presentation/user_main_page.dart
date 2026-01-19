import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_main/user_main_bloc.dart';
import 'user_main_screen.dart';

/// User Main Page
/// Provides BlocProvider for UserMainBloc
class UserMainPage extends StatelessWidget {
  const UserMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserMainBloc(),
      child: const UserMainScreen(),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/register_cubit.dart';
import 'register_screen.dart';

/// Register Page
/// Provides BlocProvider for RegisterScreen
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: const RegisterScreen(),
    );
  }
}


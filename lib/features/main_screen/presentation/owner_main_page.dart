import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/owner_main/owner_main_bloc.dart';
import 'owner_main_screen.dart';

/// Owner Main Page
/// Provides BlocProvider for OwnerMainBloc
class OwnerMainPage extends StatelessWidget {
  const OwnerMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OwnerMainBloc(),
      child: const OwnerMainScreen(),
    );
  }
}


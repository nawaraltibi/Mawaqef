part of 'user_main_bloc.dart';

/// User Main Bloc States
abstract class UserMainState {}

/// Initial state with selected tab index
class UserMainInitial extends UserMainState {
  final int selectedIndex;

  UserMainInitial({this.selectedIndex = 0});
}


part of 'owner_main_bloc.dart';

/// Owner Main Bloc States
abstract class OwnerMainState {}

/// Initial state with selected tab index
class OwnerMainInitial extends OwnerMainState {
  final int selectedIndex;

  OwnerMainInitial({this.selectedIndex = 0});
}


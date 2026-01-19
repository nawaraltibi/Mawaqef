part of 'user_main_bloc.dart';

/// User Main Bloc Events
abstract class UserMainEvent {}

/// Event to change tab
class ChangeUserTab extends UserMainEvent {
  final int index;

  ChangeUserTab(this.index);
}


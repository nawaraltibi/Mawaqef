part of 'owner_main_bloc.dart';

/// Owner Main Bloc Events
abstract class OwnerMainEvent {}

/// Event to change tab
class ChangeOwnerTab extends OwnerMainEvent {
  final int index;

  ChangeOwnerTab(this.index);
}


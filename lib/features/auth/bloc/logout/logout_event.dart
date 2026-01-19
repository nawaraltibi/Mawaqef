part of 'logout_bloc.dart';

/// Base class for logout events
abstract class LogoutEvent {}

/// Event to request logout
class LogoutRequested extends LogoutEvent {
  LogoutRequested();
}

/// Event to reset the logout state
class ResetState extends LogoutEvent {
  ResetState();
}

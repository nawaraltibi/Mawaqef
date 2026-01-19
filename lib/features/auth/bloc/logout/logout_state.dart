part of 'logout_bloc.dart';

/// Base class for logout states
abstract class LogoutState {}

/// Initial state - no logout attempt yet
class LogoutInitial extends LogoutState {}

/// Loading state - logout request in progress
class LogoutLoading extends LogoutState {}

/// Success state - logout completed successfully
class LogoutSuccess extends LogoutState {
  final LogoutResponse response;
  final String message;

  LogoutSuccess({
    required this.response,
    required this.message,
  });
}

/// Failure state - logout failed
class LogoutFailure extends LogoutState {
  final String error;
  final int statusCode;

  LogoutFailure({
    required this.error,
    required this.statusCode,
  });
}

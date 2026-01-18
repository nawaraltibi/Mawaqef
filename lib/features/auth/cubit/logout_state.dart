part of 'logout_cubit.dart';

/// Logout State
/// Represents different states of the logout process
abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no logout attempt yet
class LogoutInitial extends LogoutState {
  const LogoutInitial();
}

/// Loading state - logout request in progress
class LogoutLoading extends LogoutState {
  const LogoutLoading();
}

/// Success state - logout completed successfully
class LogoutSuccess extends LogoutState {
  final LogoutResponse response;
  final String message;

  const LogoutSuccess({
    required this.response,
    required this.message,
  });

  @override
  List<Object?> get props => [response, message];
}

/// Error state - logout failed
class LogoutError extends LogoutState {
  final String error;
  final int statusCode;

  const LogoutError({
    required this.error,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [error, statusCode];
}


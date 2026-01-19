part of 'login_bloc.dart';

/// Base class for login states
abstract class LoginState {
  final LoginRequest request;

  LoginState({required this.request});
}

/// Initial state with empty request
class LoginInitial extends LoginState {
  LoginInitial({required super.request});
}

/// Loading state - login request in progress
class LoginLoading extends LoginState {
  LoginLoading({required super.request});
}

/// Success state - login completed successfully
class LoginSuccess extends LoginState {
  final LoginResponse response;
  final String message;

  LoginSuccess({
    required this.response,
    required this.message,
    required super.request,
  });
}

/// Failure state - login failed
class LoginFailure extends LoginState {
  final String error;
  final int statusCode;
  final bool isInactiveUser;
  final String? userType;

  LoginFailure({
    required super.request,
    required this.error,
    required this.statusCode,
    this.isInactiveUser = false,
    this.userType,
  });
}

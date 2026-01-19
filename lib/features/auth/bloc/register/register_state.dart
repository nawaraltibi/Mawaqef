part of 'register_bloc.dart';

/// Base class for register states
abstract class RegisterState {
  final RegisterRequest request;

  RegisterState({required this.request});
}

/// Initial state with empty request
class RegisterInitial extends RegisterState {
  RegisterInitial({required super.request});
}

/// Loading state - registration request in progress
class RegisterLoading extends RegisterState {
  RegisterLoading({required super.request});
}

/// Success state - registration completed successfully
class RegisterSuccess extends RegisterState {
  final RegisterResponse response;
  final String message;

  RegisterSuccess({
    required this.response,
    required this.message,
    required super.request,
  });
}

/// Failure state - registration failed
class RegisterFailure extends RegisterState {
  final String error;
  final int statusCode;

  RegisterFailure({
    required super.request,
    required this.error,
    required this.statusCode,
  });
}

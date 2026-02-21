part of 'login_bloc.dart';

/// Validation error types for localization support
/// These are mapped to localized strings in the UI layer
enum ValidationErrorType {
  required,
  invalidFormat,
  tooShort,
  tooLong,
  mismatch,
}

/// Base class for login states
/// 
/// UX Validation Model:
/// - [emailError] and [passwordError] are nullable error types
/// - null = no error (show helper text)
/// - non-null = show red error text (localized in UI)
/// - Errors only appear on submit, not while typing
abstract class LoginState {
  final LoginRequest request;
  final ValidationErrorType? emailError;
  final ValidationErrorType? passwordError;

  LoginState({
    required this.request,
    this.emailError,
    this.passwordError,
  });
  
  /// Returns true if any field has a validation error
  bool get hasErrors => emailError != null || passwordError != null;
}

/// Initial state with empty request
class LoginInitial extends LoginState {
  LoginInitial({
    required super.request,
    super.emailError,
    super.passwordError,
  });
  
  /// Creates a copy with updated values
  LoginInitial copyWith({
    LoginRequest? request,
    ValidationErrorType? emailError,
    ValidationErrorType? passwordError,
    bool clearEmailError = false,
    bool clearPasswordError = false,
  }) {
    return LoginInitial(
      request: request ?? this.request,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
    );
  }
}

/// Loading state - login request in progress
class LoginLoading extends LoginState {
  LoginLoading({
    required super.request,
    super.emailError,
    super.passwordError,
  });
}

/// Success state - login completed successfully
class LoginSuccess extends LoginState {
  final LoginResponse response;
  final String message;

  LoginSuccess({
    required this.response,
    required this.message,
    required super.request,
    super.emailError,
    super.passwordError,
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
    super.emailError,
    super.passwordError,
  });
}

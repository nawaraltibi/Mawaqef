part of 'register_bloc.dart';

// Import ValidationErrorType from login_state.dart
// Note: ValidationErrorType is defined in login_state.dart and exported via login_bloc.dart

/// Base class for register states
/// 
/// UX Validation Model:
/// - All error fields are nullable ValidationErrorType
/// - null = no error (show helper text)
/// - non-null = show red error text (localized in UI)
/// - Errors only appear on submit, not while typing
abstract class RegisterState {
  final RegisterRequest request;
  final ValidationErrorType? fullNameError;
  final ValidationErrorType? emailError;
  final ValidationErrorType? phoneError;
  final ValidationErrorType? passwordError;
  final ValidationErrorType? passwordConfirmationError;

  RegisterState({
    required this.request,
    this.fullNameError,
    this.emailError,
    this.phoneError,
    this.passwordError,
    this.passwordConfirmationError,
  });
  
  /// Returns true if any field has a validation error
  bool get hasErrors => 
      fullNameError != null || 
      emailError != null || 
      phoneError != null || 
      passwordError != null || 
      passwordConfirmationError != null;
}

/// Initial state with empty request
class RegisterInitial extends RegisterState {
  RegisterInitial({
    required super.request,
    super.fullNameError,
    super.emailError,
    super.phoneError,
    super.passwordError,
    super.passwordConfirmationError,
  });
  
  /// Creates a copy with updated values
  RegisterInitial copyWith({
    RegisterRequest? request,
    ValidationErrorType? fullNameError,
    ValidationErrorType? emailError,
    ValidationErrorType? phoneError,
    ValidationErrorType? passwordError,
    ValidationErrorType? passwordConfirmationError,
    bool clearFullNameError = false,
    bool clearEmailError = false,
    bool clearPhoneError = false,
    bool clearPasswordError = false,
    bool clearPasswordConfirmationError = false,
  }) {
    return RegisterInitial(
      request: request ?? this.request,
      fullNameError: clearFullNameError ? null : (fullNameError ?? this.fullNameError),
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      phoneError: clearPhoneError ? null : (phoneError ?? this.phoneError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
      passwordConfirmationError: clearPasswordConfirmationError ? null : (passwordConfirmationError ?? this.passwordConfirmationError),
    );
  }
}

/// Loading state - registration request in progress
class RegisterLoading extends RegisterState {
  RegisterLoading({
    required super.request,
    super.fullNameError,
    super.emailError,
    super.phoneError,
    super.passwordError,
    super.passwordConfirmationError,
  });
}

/// Success state - registration completed successfully
class RegisterSuccess extends RegisterState {
  final RegisterResponse response;
  final String message;

  RegisterSuccess({
    required this.response,
    required this.message,
    required super.request,
    super.fullNameError,
    super.emailError,
    super.phoneError,
    super.passwordError,
    super.passwordConfirmationError,
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
    super.fullNameError,
    super.emailError,
    super.phoneError,
    super.passwordError,
    super.passwordConfirmationError,
  });
}

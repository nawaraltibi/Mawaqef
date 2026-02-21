part of 'register_bloc.dart';

/// Base class for register events
abstract class RegisterEvent {}

/// Event to update full name in the register request
/// Clears any existing full name error (no validation while typing)
class UpdateFullName extends RegisterEvent {
  final String fullName;

  UpdateFullName(this.fullName);
}

/// Event to update email in the register request
/// Clears any existing email error (no validation while typing)
class UpdateEmail extends RegisterEvent {
  final String email;

  UpdateEmail(this.email);
}

/// Event to update phone in the register request
/// Clears any existing phone error (no validation while typing)
class UpdatePhone extends RegisterEvent {
  final String phone;

  UpdatePhone(this.phone);
}

/// Event to update user type in the register request
class UpdateUserType extends RegisterEvent {
  final String userType;

  UpdateUserType(this.userType);
}

/// Event to update password in the register request
/// Clears any existing password error (no validation while typing)
class UpdatePassword extends RegisterEvent {
  final String password;

  UpdatePassword(this.password);
}

/// Event to update password confirmation in the register request
/// Clears any existing password confirmation error (no validation while typing)
class UpdatePasswordConfirmation extends RegisterEvent {
  final String passwordConfirmation;

  UpdatePasswordConfirmation(this.passwordConfirmation);
}

/// Event triggered when full name field loses focus (on blur)
/// Validates full name and sets error if invalid
class FullNameFieldUnfocused extends RegisterEvent {
  FullNameFieldUnfocused();
}

/// Event triggered when email field loses focus (on blur)
/// Validates email and sets error if invalid
class EmailFieldUnfocused extends RegisterEvent {
  EmailFieldUnfocused();
}

/// Event triggered when phone field loses focus (on blur)
/// Validates phone and sets error if invalid
class PhoneFieldUnfocused extends RegisterEvent {
  PhoneFieldUnfocused();
}

/// Event triggered when password field loses focus (on blur)
/// Validates password and sets error if invalid
class PasswordFieldUnfocused extends RegisterEvent {
  PasswordFieldUnfocused();
}

/// Event triggered when password confirmation field loses focus (on blur)
/// Validates password confirmation and sets error if invalid
class PasswordConfirmationFieldUnfocused extends RegisterEvent {
  PasswordConfirmationFieldUnfocused();
}

/// Event to send the register request to the server
class SendRegisterRequest extends RegisterEvent {
  SendRegisterRequest();
}

/// Event to reset the register state
class ResetState extends RegisterEvent {
  ResetState();
}

part of 'login_bloc.dart';

/// Base class for login events
abstract class LoginEvent {}

/// Event to update email in the login request
/// Clears any existing email error (no validation while typing)
class UpdateEmail extends LoginEvent {
  final String email;

  UpdateEmail(this.email);
}

/// Event to update password in the login request
/// Clears any existing password error (no validation while typing)
class UpdatePassword extends LoginEvent {
  final String password;

  UpdatePassword(this.password);
}

/// Event triggered when email field loses focus (on blur)
/// Validates email and sets error if invalid
class EmailFieldUnfocused extends LoginEvent {
  EmailFieldUnfocused();
}

/// Event triggered when password field loses focus (on blur)
/// Validates password and sets error if invalid
class PasswordFieldUnfocused extends LoginEvent {
  PasswordFieldUnfocused();
}

/// Event to send the login request to the server
class SendLoginRequest extends LoginEvent {
  SendLoginRequest();
}

/// Event to reset the login state
class ResetState extends LoginEvent {
  ResetState();
}

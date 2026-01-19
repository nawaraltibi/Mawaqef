part of 'login_bloc.dart';

/// Base class for login events
abstract class LoginEvent {}

/// Event to update email in the login request
class UpdateEmail extends LoginEvent {
  final String email;

  UpdateEmail(this.email);
}

/// Event to update password in the login request
class UpdatePassword extends LoginEvent {
  final String password;

  UpdatePassword(this.password);
}

/// Event to send the login request to the server
class SendLoginRequest extends LoginEvent {
  SendLoginRequest();
}

/// Event to reset the login state
class ResetState extends LoginEvent {
  ResetState();
}

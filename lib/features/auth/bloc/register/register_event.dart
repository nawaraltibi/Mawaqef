part of 'register_bloc.dart';

/// Base class for register events
abstract class RegisterEvent {}

/// Event to update full name in the register request
class UpdateFullName extends RegisterEvent {
  final String fullName;

  UpdateFullName(this.fullName);
}

/// Event to update email in the register request
class UpdateEmail extends RegisterEvent {
  final String email;

  UpdateEmail(this.email);
}

/// Event to update phone in the register request
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
class UpdatePassword extends RegisterEvent {
  final String password;

  UpdatePassword(this.password);
}

/// Event to update password confirmation in the register request
class UpdatePasswordConfirmation extends RegisterEvent {
  final String passwordConfirmation;

  UpdatePasswordConfirmation(this.passwordConfirmation);
}

/// Event to send the register request to the server
class SendRegisterRequest extends RegisterEvent {
  SendRegisterRequest();
}

/// Event to reset the register state
class ResetState extends RegisterEvent {
  ResetState();
}

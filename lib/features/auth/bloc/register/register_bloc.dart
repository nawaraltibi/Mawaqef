import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../models/register_request.dart';
import '../../models/register_response.dart';
import '../../repository/auth_repository.dart';
import '../mixins/auth_error_handler_mixin.dart';
import '../login/login_bloc.dart' show ValidationErrorType;

part 'register_event.dart';
part 'register_state.dart';

/// Register Bloc
/// Manages registration state and business logic using Bloc pattern with AsyncRunner
/// 
/// UX Validation Rules:
/// - No red errors while typing (errors cleared on value change)
/// - Errors shown only on blur (field unfocused) or submit
/// - Helper text displayed by default, replaced by error when validation fails
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> with AuthErrorHandlerMixin {
  final AsyncRunner<RegisterResponse> registerRunner =
      AsyncRunner<RegisterResponse>();

  RegisterBloc()
      : super(RegisterInitial(
          request: RegisterRequest(
            fullName: '',
            email: '',
            phone: '',
            userType: 'user',
            password: '',
            passwordConfirmation: '',
          ),
        )) {
    on<UpdateFullName>(_onUpdateFullName);
    on<UpdateEmail>(_onUpdateEmail);
    on<UpdatePhone>(_onUpdatePhone);
    on<UpdateUserType>(_onUpdateUserType);
    on<UpdatePassword>(_onUpdatePassword);
    on<UpdatePasswordConfirmation>(_onUpdatePasswordConfirmation);
    on<FullNameFieldUnfocused>(_onFullNameFieldUnfocused);
    on<EmailFieldUnfocused>(_onEmailFieldUnfocused);
    on<PhoneFieldUnfocused>(_onPhoneFieldUnfocused);
    on<PasswordFieldUnfocused>(_onPasswordFieldUnfocused);
    on<PasswordConfirmationFieldUnfocused>(_onPasswordConfirmationFieldUnfocused);
    on<SendRegisterRequest>(_onSendRegisterRequest);
    on<ResetState>(_onResetState);
  }

  /// Update full name in the request
  /// Clears full name error (no validation while typing)
  void _onUpdateFullName(
    UpdateFullName event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      fullName: event.fullName,
    );
    emit(RegisterInitial(
      request: updatedRequest,
      fullNameError: null,
      emailError: state.emailError,
      phoneError: state.phoneError,
      passwordError: state.passwordError,
      passwordConfirmationError: state.passwordConfirmationError,
    ));
  }

  /// Update email in the request
  /// Clears email error (no validation while typing)
  void _onUpdateEmail(
    UpdateEmail event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      email: event.email,
    );
    emit(RegisterInitial(
      request: updatedRequest,
      fullNameError: state.fullNameError,
      emailError: null,
      phoneError: state.phoneError,
      passwordError: state.passwordError,
      passwordConfirmationError: state.passwordConfirmationError,
    ));
  }

  /// Update phone in the request
  /// Clears phone error (no validation while typing)
  void _onUpdatePhone(
    UpdatePhone event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      phone: event.phone,
    );
    emit(RegisterInitial(
      request: updatedRequest,
      fullNameError: state.fullNameError,
      emailError: state.emailError,
      phoneError: null,
      passwordError: state.passwordError,
      passwordConfirmationError: state.passwordConfirmationError,
    ));
  }

  /// Update user type in the request
  void _onUpdateUserType(
    UpdateUserType event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      userType: event.userType,
    );
    emit(RegisterInitial(
      request: updatedRequest,
      fullNameError: state.fullNameError,
      emailError: state.emailError,
      phoneError: state.phoneError,
      passwordError: state.passwordError,
      passwordConfirmationError: state.passwordConfirmationError,
    ));
  }

  /// Update password in the request
  /// Clears password error (no validation while typing)
  void _onUpdatePassword(
    UpdatePassword event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      password: event.password,
    );
    emit(RegisterInitial(
      request: updatedRequest,
      fullNameError: state.fullNameError,
      emailError: state.emailError,
      phoneError: state.phoneError,
      passwordError: null,
      passwordConfirmationError: state.passwordConfirmationError,
    ));
  }

  /// Update password confirmation in the request
  /// Clears password confirmation error (no validation while typing)
  void _onUpdatePasswordConfirmation(
    UpdatePasswordConfirmation event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      passwordConfirmation: event.passwordConfirmation,
    );
    emit(RegisterInitial(
      request: updatedRequest,
      fullNameError: state.fullNameError,
      emailError: state.emailError,
      phoneError: state.phoneError,
      passwordError: state.passwordError,
      passwordConfirmationError: null,
    ));
  }

  /// Validate full name when field loses focus (on blur)
  /// Note: Currently not used - validation only happens on submit
  void _onFullNameFieldUnfocused(
    FullNameFieldUnfocused event,
    Emitter<RegisterState> emit,
  ) {
    final fullName = state.request.fullName;
    ValidationErrorType? fullNameError;
    
    if (fullName.trim().isEmpty) {
      fullNameError = ValidationErrorType.required;
    } else if (fullName.length > 255) {
      fullNameError = ValidationErrorType.tooLong;
    }
    
    emit(RegisterInitial(
      request: state.request,
      fullNameError: fullNameError,
      emailError: state.emailError,
      phoneError: state.phoneError,
      passwordError: state.passwordError,
      passwordConfirmationError: state.passwordConfirmationError,
    ));
  }

  /// Validate email when field loses focus (on blur)
  /// Note: Currently not used - validation only happens on submit
  void _onEmailFieldUnfocused(
    EmailFieldUnfocused event,
    Emitter<RegisterState> emit,
  ) {
    final email = state.request.email;
    ValidationErrorType? emailError;
    
    if (email.trim().isEmpty) {
      emailError = ValidationErrorType.required;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = ValidationErrorType.invalidFormat;
    }
    
    emit(RegisterInitial(
      request: state.request,
      fullNameError: state.fullNameError,
      emailError: emailError,
      phoneError: state.phoneError,
      passwordError: state.passwordError,
      passwordConfirmationError: state.passwordConfirmationError,
    ));
  }

  /// Validate phone when field loses focus (on blur)
  /// Note: Currently not used - validation only happens on submit
  void _onPhoneFieldUnfocused(
    PhoneFieldUnfocused event,
    Emitter<RegisterState> emit,
  ) {
    final phone = state.request.phone;
    ValidationErrorType? phoneError;
    
    if (phone.trim().isEmpty) {
      phoneError = ValidationErrorType.required;
    }
    
    emit(RegisterInitial(
      request: state.request,
      fullNameError: state.fullNameError,
      emailError: state.emailError,
      phoneError: phoneError,
      passwordError: state.passwordError,
      passwordConfirmationError: state.passwordConfirmationError,
    ));
  }

  /// Validate password when field loses focus (on blur)
  /// Note: Currently not used - validation only happens on submit
  void _onPasswordFieldUnfocused(
    PasswordFieldUnfocused event,
    Emitter<RegisterState> emit,
  ) {
    final password = state.request.password;
    ValidationErrorType? passwordError;
    
    if (password.isEmpty) {
      passwordError = ValidationErrorType.required;
    } else if (password.length < 8) {
      passwordError = ValidationErrorType.tooShort;
    }
    
    emit(RegisterInitial(
      request: state.request,
      fullNameError: state.fullNameError,
      emailError: state.emailError,
      phoneError: state.phoneError,
      passwordError: passwordError,
      passwordConfirmationError: state.passwordConfirmationError,
    ));
  }

  /// Validate password confirmation when field loses focus (on blur)
  /// Note: Currently not used - validation only happens on submit
  void _onPasswordConfirmationFieldUnfocused(
    PasswordConfirmationFieldUnfocused event,
    Emitter<RegisterState> emit,
  ) {
    final passwordConfirmation = state.request.passwordConfirmation;
    final password = state.request.password;
    ValidationErrorType? passwordConfirmationError;
    
    if (passwordConfirmation.isEmpty) {
      passwordConfirmationError = ValidationErrorType.required;
    } else if (passwordConfirmation != password) {
      passwordConfirmationError = ValidationErrorType.mismatch;
    }
    
    emit(RegisterInitial(
      request: state.request,
      fullNameError: state.fullNameError,
      emailError: state.emailError,
      phoneError: state.phoneError,
      passwordError: state.passwordError,
      passwordConfirmationError: passwordConfirmationError,
    ));
  }

  /// Reset state
  void _onResetState(
    ResetState event,
    Emitter<RegisterState> emit,
  ) {
    emit(RegisterInitial(
      request: RegisterRequest(
        fullName: '',
        email: '',
        phone: '',
        userType: 'user',
        password: '',
        passwordConfirmation: '',
      ),
    ));
  }

  /// Send register request to server
  /// Validates all fields on submit - shows red errors for invalid fields
  Future<void> _onSendRegisterRequest(
    SendRegisterRequest event,
    Emitter<RegisterState> emit,
  ) async {
    // Validate all fields on submit
    final fullName = state.request.fullName;
    final email = state.request.email;
    final phone = state.request.phone;
    final password = state.request.password;
    final passwordConfirmation = state.request.passwordConfirmation;
    
    ValidationErrorType? fullNameError;
    ValidationErrorType? emailError;
    ValidationErrorType? phoneError;
    ValidationErrorType? passwordError;
    ValidationErrorType? passwordConfirmationError;
    
    // Full name validation
    if (fullName.trim().isEmpty) {
      fullNameError = ValidationErrorType.required;
    } else if (fullName.length > 255) {
      fullNameError = ValidationErrorType.tooLong;
    }
    
    // Email validation
    if (email.trim().isEmpty) {
      emailError = ValidationErrorType.required;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = ValidationErrorType.invalidFormat;
    }
    
    // Phone validation
    if (phone.trim().isEmpty) {
      phoneError = ValidationErrorType.required;
    }
    
    // Password validation
    if (password.isEmpty) {
      passwordError = ValidationErrorType.required;
    } else if (password.length < 8) {
      passwordError = ValidationErrorType.tooShort;
    }
    
    // Password confirmation validation
    if (passwordConfirmation.isEmpty) {
      passwordConfirmationError = ValidationErrorType.required;
    } else if (passwordConfirmation != password) {
      passwordConfirmationError = ValidationErrorType.mismatch;
    }
    
    // If any validation errors, show them and stop submission
    if (fullNameError != null || emailError != null || phoneError != null || 
        passwordError != null || passwordConfirmationError != null) {
      emit(RegisterInitial(
        request: state.request,
        fullNameError: fullNameError,
        emailError: emailError,
        phoneError: phoneError,
        passwordError: passwordError,
        passwordConfirmationError: passwordConfirmationError,
      ));
      return;
    }

    emit(RegisterLoading(
      request: state.request,
      fullNameError: null,
      emailError: null,
      phoneError: null,
      passwordError: null,
      passwordConfirmationError: null,
    ));

    await registerRunner.run(
      onlineTask: (previousResult) async {
        final registerResponse = await AuthRepository.register(
          registerRequest: state.request,
        );
        return registerResponse;
      },
      onSuccess: (registerResponse) async {
        if (!emit.isDone) {
          emit(RegisterSuccess(
            request: state.request,
            response: registerResponse,
            message: registerResponse.message,
          ));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleRegisterError(error, emit, state.request);
        }
      },
    );
  }
}

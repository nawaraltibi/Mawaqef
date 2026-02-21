import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../../../data/repositories/auth_local_repository.dart';
import '../../models/login_request.dart';
import '../../models/login_response.dart';
import '../../repository/auth_repository.dart';
import '../../../../core/utils/app_exception.dart';
import '../mixins/auth_error_handler_mixin.dart';

part 'login_event.dart';
part 'login_state.dart';

/// Login Bloc
/// Manages login state and business logic using Bloc pattern with AsyncRunner
/// 
/// UX Validation Rules:
/// - No red errors while typing (errors cleared on value change)
/// - Errors shown only on blur (field unfocused) or submit
/// - Helper text displayed by default, replaced by error when validation fails
class LoginBloc extends Bloc<LoginEvent, LoginState> with AuthErrorHandlerMixin {
  final AsyncRunner<LoginResponse> loginRunner = AsyncRunner<LoginResponse>();

  LoginBloc() : super(LoginInitial(request: LoginRequest())) {
    on<UpdateEmail>(_onUpdateEmail);
    on<UpdatePassword>(_onUpdatePassword);
    on<EmailFieldUnfocused>(_onEmailFieldUnfocused);
    on<PasswordFieldUnfocused>(_onPasswordFieldUnfocused);
    on<SendLoginRequest>(_onSendLoginRequest);
    on<ResetState>(_onResetState);
  }

  /// Update email in the request
  /// Clears email error (no validation while typing)
  void _onUpdateEmail(
    UpdateEmail event,
    Emitter<LoginState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      email: event.email,
    );
    // Clear email error when user starts typing again
    emit(LoginInitial(
      request: updatedRequest,
      emailError: null,
      passwordError: state.passwordError,
    ));
  }

  /// Update password in the request
  /// Clears password error (no validation while typing)
  void _onUpdatePassword(
    UpdatePassword event,
    Emitter<LoginState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      password: event.password,
    );
    // Clear password error when user starts typing again
    emit(LoginInitial(
      request: updatedRequest,
      emailError: state.emailError,
      passwordError: null,
    ));
  }

  /// Validate email when field loses focus (on blur)
  /// Note: Currently not used - validation only happens on submit
  void _onEmailFieldUnfocused(
    EmailFieldUnfocused event,
    Emitter<LoginState> emit,
  ) {
    final email = state.request.email;
    ValidationErrorType? emailError;
    
    if (email.trim().isEmpty) {
      emailError = ValidationErrorType.required;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = ValidationErrorType.invalidFormat;
    }
    
    emit(LoginInitial(
      request: state.request,
      emailError: emailError,
      passwordError: state.passwordError,
    ));
  }

  /// Validate password when field loses focus (on blur)
  /// Note: Currently not used - validation only happens on submit
  void _onPasswordFieldUnfocused(
    PasswordFieldUnfocused event,
    Emitter<LoginState> emit,
  ) {
    final password = state.request.password;
    ValidationErrorType? passwordError;
    
    if (password.isEmpty) {
      passwordError = ValidationErrorType.required;
    } else if (password.length < 8) {
      passwordError = ValidationErrorType.tooShort;
    }
    
    emit(LoginInitial(
      request: state.request,
      emailError: state.emailError,
      passwordError: passwordError,
    ));
  }

  /// Reset state
  void _onResetState(
    ResetState event,
    Emitter<LoginState> emit,
  ) {
    emit(LoginInitial(request: LoginRequest()));
  }

  /// Send login request to server
  /// Validates all fields on submit - shows red errors for invalid fields
  Future<void> _onSendLoginRequest(
    SendLoginRequest event,
    Emitter<LoginState> emit,
  ) async {
    // Validate all fields on submit
    final email = state.request.email;
    final password = state.request.password;
    
    ValidationErrorType? emailError;
    ValidationErrorType? passwordError;
    
    // Email validation
    if (email.trim().isEmpty) {
      emailError = ValidationErrorType.required;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      emailError = ValidationErrorType.invalidFormat;
    }
    
    // Password validation
    if (password.isEmpty) {
      passwordError = ValidationErrorType.required;
    } else if (password.length < 8) {
      passwordError = ValidationErrorType.tooShort;
    }
    
    // If any validation errors, show them and stop submission
    if (emailError != null || passwordError != null) {
      emit(LoginInitial(
        request: state.request,
        emailError: emailError,
        passwordError: passwordError,
      ));
      return;
    }

    emit(LoginLoading(
      request: state.request,
      emailError: null,
      passwordError: null,
    ));

    await loginRunner.run(
      onlineTask: (previousResult) async {
        final loginResponse = await AuthRepository.login(
          loginRequest: state.request,
        );
        
        // Validate owner status before saving token
        // Block owner users with inactive status
        if (loginResponse.userType == 'owner' && loginResponse.user.status == 'inactive') {
          // Do not save token or user data
          // Throw exception to be caught in onError
          throw AppException(
            statusCode: 403,
            errorCode: 'owner_pending_approval',
            message: 'Your account is pending admin approval. Please wait until your account is activated.',
          );
        }
        
        // API returned 200 OK with token - login is successful
        // Save token and user data for active users
        await AuthLocalRepository.saveToken(loginResponse.token);
        final userJson = loginResponse.user.toJson();
        // Ensure user_type is saved from loginResponse (it may differ from user object)
        userJson['user_type'] = loginResponse.userType;
        await AuthLocalRepository.saveUser(userJson);
        
        return loginResponse;
      },
      onSuccess: (loginResponse) async {
        if (!emit.isDone) {
          emit(LoginSuccess(
            request: state.request,
            response: loginResponse,
            message: loginResponse.message,
          ));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleLoginError(error, emit, state.request);
        }
      },
    );
  }
}

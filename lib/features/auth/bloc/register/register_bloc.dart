import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../models/register_request.dart';
import '../../models/register_response.dart';
import '../../repository/auth_repository.dart';
import '../../../../core/utils/app_exception.dart';

part 'register_event.dart';
part 'register_state.dart';

/// Register Bloc
/// Manages registration state and business logic using Bloc pattern with AsyncRunner
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
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
    on<SendRegisterRequest>(_onSendRegisterRequest);
    on<ResetState>(_onResetState);
  }

  /// Update full name in the request
  void _onUpdateFullName(
    UpdateFullName event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      fullName: event.fullName,
    );
    emit(RegisterInitial(request: updatedRequest));
  }

  /// Update email in the request
  void _onUpdateEmail(
    UpdateEmail event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      email: event.email,
    );
    emit(RegisterInitial(request: updatedRequest));
  }

  /// Update phone in the request
  void _onUpdatePhone(
    UpdatePhone event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      phone: event.phone,
    );
    emit(RegisterInitial(request: updatedRequest));
  }

  /// Update user type in the request
  void _onUpdateUserType(
    UpdateUserType event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      userType: event.userType,
    );
    emit(RegisterInitial(request: updatedRequest));
  }

  /// Update password in the request
  void _onUpdatePassword(
    UpdatePassword event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      password: event.password,
    );
    emit(RegisterInitial(request: updatedRequest));
  }

  /// Update password confirmation in the request
  void _onUpdatePasswordConfirmation(
    UpdatePasswordConfirmation event,
    Emitter<RegisterState> emit,
  ) {
    final updatedRequest = state.request.copyWith(
      passwordConfirmation: event.passwordConfirmation,
    );
    emit(RegisterInitial(request: updatedRequest));
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
  Future<void> _onSendRegisterRequest(
    SendRegisterRequest event,
    Emitter<RegisterState> emit,
  ) async {
    // Validate request locally first
    final validationErrors = state.request.validate();
    if (validationErrors.isNotEmpty) {
      emit(RegisterFailure(
        request: state.request,
        error: validationErrors.join('\n'),
        statusCode: 422,
      ));
      return;
    }

    emit(RegisterLoading(request: state.request));

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
          String errorMessage = '';
          int statusCode = 500;

          if (error is AppException) {
            errorMessage = error.message;
            statusCode = error.statusCode;

            // Extract validation errors if available
            if (error.errors != null && error.errors!.isNotEmpty) {
              final errorList = <String>[];
              error.errors!.forEach((key, value) {
                errorList.addAll(value);
              });
              if (errorList.isNotEmpty) {
                errorMessage = errorList.join('\n');
              }
            }
          } else {
            errorMessage = error.toString();
          }

          emit(RegisterFailure(
            request: state.request,
            error: errorMessage,
            statusCode: statusCode,
          ));
        }
      },
    );
  }
}

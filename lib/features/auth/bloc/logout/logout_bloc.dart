import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../models/logout_response.dart';
import '../../repository/auth_repository.dart';
import '../../../../core/utils/app_exception.dart';
import '../../../../data/repositories/auth_local_repository.dart';

part 'logout_event.dart';
part 'logout_state.dart';

/// Logout Bloc
/// Manages logout state and business logic using Bloc pattern with AsyncRunner
class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AsyncRunner<LogoutResponse> logoutRunner =
      AsyncRunner<LogoutResponse>();

  LogoutBloc() : super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
    on<ResetState>(_onResetState);
  }

  /// Reset state
  void _onResetState(
    ResetState event,
    Emitter<LogoutState> emit,
  ) {
    emit(LogoutInitial());
  }

  /// Logout user
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutLoading());

    await logoutRunner.run(
      onlineTask: (previousResult) async {
        // Check if token exists before attempting logout
        final token = await AuthLocalRepository.retrieveToken();
        if (token.isEmpty) {
          throw AppException(
            statusCode: 401,
            errorCode: 'unauthenticated',
            message: 'Unauthenticated.',
          );
        }

        // Call logout API endpoint
        final response = await AuthRepository.logout();
        return response;
      },
      onSuccess: (logoutResponse) async {
        // On success, remove token and user data from local storage
        await AuthLocalRepository.clearAuthData();

        if (!emit.isDone) {
          emit(LogoutSuccess(
            response: logoutResponse,
            message: logoutResponse.message,
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

            // Handle 401 specifically (Unauthenticated)
            if (error.statusCode == 401) {
              // Error message will be translated in UI layer
              // Also clear local auth data if token is invalid
              AuthLocalRepository.clearAuthData();
            }
          } else {
            errorMessage = error.toString();
          }

          emit(LogoutFailure(
            error: errorMessage,
            statusCode: statusCode,
          ));
        }
      },
    );
  }
}

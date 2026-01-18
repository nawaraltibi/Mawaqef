import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/logout_response.dart';
import '../repository/auth_repository.dart';
import '../../../core/utils/app_exception.dart';
import '../../../data/repositories/auth_local_repository.dart';

part 'logout_state.dart';

/// Logout Cubit
/// Manages logout state and business logic
class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());

  /// Logout user
  /// 
  /// Calls the logout API endpoint, removes token from local storage on success,
  /// and handles all error cases (401 Unauthenticated, 500 Server errors)
  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      // Check if token exists before attempting logout
      final token = await AuthLocalRepository.retrieveToken();
      if (token.isEmpty) {
        emit(LogoutError(
          error: 'Unauthenticated.',
          statusCode: 401,
        ));
        return;
      }

      // Call logout API endpoint
      final response = await AuthRepository.logout();
      
      // On success, remove token and user data from local storage
      await AuthLocalRepository.clearAuthData();
      
      emit(LogoutSuccess(
        response: response,
        message: response.message,
      ));
    } on AppException catch (e) {
      // Handle API errors (401 Unauthenticated, 500 Server errors, etc.)
      String errorMessage = e.message;
      
      // Handle 401 specifically (Unauthenticated)
      if (e.statusCode == 401) {
        errorMessage = 'Unauthenticated.';
        // Also clear local auth data if token is invalid
        await AuthLocalRepository.clearAuthData();
      }
      
      emit(LogoutError(
        error: errorMessage,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      // Handle unexpected errors
      emit(LogoutError(
        error: 'An unexpected error occurred. Please try again.',
        statusCode: 500,
      ));
    }
  }

  /// Reset state to initial
  void reset() {
    emit(LogoutInitial());
  }
}


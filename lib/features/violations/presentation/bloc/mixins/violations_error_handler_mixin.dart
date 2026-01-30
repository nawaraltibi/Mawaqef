import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_exception.dart';
import '../violations_bloc.dart';

/// Mixin for handling errors in violations bloc
/// Note: This mixin must be used with a Bloc[ViolationsEvent, ViolationsState]
mixin ViolationsErrorHandlerMixin on Bloc<ViolationsEvent, ViolationsState> {
  /// Handle error and emit failure state for get violations
  void handleError(
    Object error,
    Emitter<ViolationsState> emit,
  ) {
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

    emit(ViolationsError(
      error: errorMessage,
      statusCode: statusCode,
    ));
  }

  /// Handle error and emit failure state for violation actions (pay violation)
  void handleViolationActionError(
    Object error,
    Emitter<ViolationsState> emit,
  ) {
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

    emit(ViolationActionFailure(
      error: errorMessage,
      statusCode: statusCode,
    ));
  }
}


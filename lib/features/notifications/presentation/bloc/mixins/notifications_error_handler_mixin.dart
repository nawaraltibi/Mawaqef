import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/app_exception.dart';
import '../notifications_bloc.dart';

/// Mixin for handling errors in notifications bloc
/// Note: This mixin must be used with a Bloc[NotificationsEvent, NotificationsState]
mixin NotificationsErrorHandlerMixin
    on Bloc<NotificationsEvent, NotificationsState> {
  /// Handle error and emit failure state for get notifications
  void handleError(
    Object error,
    Emitter<NotificationsState> emit,
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

    emit(NotificationsError(
      error: errorMessage,
      statusCode: statusCode,
    ));
  }

  /// Handle error and emit failure state for notification actions (mark as read)
  void handleNotificationActionError(
    Object error,
    Emitter<NotificationsState> emit,
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

    emit(NotificationActionFailure(
      error: errorMessage,
      statusCode: statusCode,
    ));
  }
}


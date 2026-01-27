import '../../../../core/utils/app_exception.dart';

/// Booking Error Handler Mixin
/// Provides common error handling logic for booking BLoCs
/// 
/// Reduces code duplication across booking-related BLoCs
mixin BookingErrorHandlerMixin {
  /// Handle AppException and convert to error state
  /// 
  /// This is a generic method that can be used by any booking BLoC
  /// to handle errors consistently
  void handleBookingError(
    AppException error, {
    required Function(String message, int? statusCode, String? errorCode, Map<String, List<String>>? validationErrors, Map<String, dynamic>? responseData) onError,
  }) {
    onError(
      error.message,
      error.statusCode,
      error.errorCode,
      error.errors,
      error.responseData,
    );
  }

  /// Handle generic exceptions
  void handleGenericError(
    dynamic error, {
    required Function(String message) onError,
  }) {
    onError(error.toString());
  }
}


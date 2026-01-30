import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'app_exception.dart';

/// Error Helper
/// Utility functions for error handling
class ErrorHelper {
  /// Extract error message from various error types
  /// Pass BuildContext to get localized error messages
  static String getErrorMessage(dynamic error, [BuildContext? context]) {
    if (error is AppException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString();
    } else if (error is String) {
      return error;
    }
    
    // Return localized error message if context is available
    if (context != null) {
      final l10n = AppLocalizations.of(context);
      return l10n?.errorUnexpected ?? 'An unexpected error occurred';
    }
    
    return 'An unexpected error occurred';
  }

  /// Check if error is network related
  static bool isNetworkError(dynamic error) {
    final message = getErrorMessage(error).toLowerCase();
    return message.contains('network') ||
        message.contains('شبكة') ||
        message.contains('connection') ||
        message.contains('اتصال') ||
        message.contains('timeout') ||
        message.contains('انتهت المهلة') ||
        message.contains('socket');
  }
}


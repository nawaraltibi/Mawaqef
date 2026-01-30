import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../routes/app_pages.dart';
import '../widgets/api_connection_error_dialog.dart';

/// Type of connection error
enum ConnectionErrorType {
  timeout,
  connectionError,
}

/// Result of showing the connection error dialog.
/// [retry] = user tapped Retry (same host).
/// [retryWithNewHost] = user tapped Change IP and entered a new host; caller should set host and retry.
/// [cancel] = user dismissed without retry.
sealed class ConnectionErrorResult {}

class ConnectionErrorRetry extends ConnectionErrorResult {}

class ConnectionErrorRetryWithNewHost extends ConnectionErrorResult {
  ConnectionErrorRetryWithNewHost(this.host);
  final String host;
}

class ConnectionErrorCancel extends ConnectionErrorResult {}

/// Shows the connection error dialog (Retry / Change IP) using the app navigator.
/// Call from DioProvider when a request fails with connection timeout or error.
/// Returns [ConnectionErrorRetry] or [ConnectionErrorRetryWithNewHost](host) or [ConnectionErrorCancel].
Future<ConnectionErrorResult> showConnectionErrorDialog(
  ConnectionErrorType errorType,
) async {
  final context = Pages.navigatorKey.currentContext;
  if (context == null || !context.mounted) return ConnectionErrorCancel();

  // Get localized error message
  final l10n = AppLocalizations.of(context);
  final message = switch (errorType) {
    ConnectionErrorType.timeout =>
      l10n?.errorConnectionTimeout ?? 'Connection timed out. Please check your network and try again.',
    ConnectionErrorType.connectionError =>
      l10n?.errorConnectionFailed ?? 'Could not connect to server. Please check your network or server address.',
  };

  final result = await showDialog<ConnectionErrorResult>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => ApiConnectionErrorDialog(message: message),
  );
  return result ?? ConnectionErrorCancel();
}

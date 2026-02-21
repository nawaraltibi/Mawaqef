import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'app_exception.dart';

/// Localized Error Messages
/// Translates error codes from AppException to user-friendly localized messages
/// 
/// Usage:
/// ```dart
/// final message = LocalizedErrorMessages.fromException(context, exception);
/// ```
/// 
/// Or for specific error codes:
/// ```dart
/// final message = LocalizedErrorMessages.fromErrorCode(context, 'no-internet');
/// ```
class LocalizedErrorMessages {
  // Private constructor to prevent instantiation
  LocalizedErrorMessages._();

  /// Get localized message from AppException
  /// Falls back to exception.message if no localized string found
  static String fromException(BuildContext context, AppException exception) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return exception.message;

    // First try to get message from error code
    final localizedMessage = fromErrorCode(context, exception.errorCode);
    
    // If localized message is the same as error code, use the exception message
    if (localizedMessage == exception.errorCode) {
      return exception.message;
    }
    
    return localizedMessage;
  }

  /// Get localized message from error code
  /// Returns the error code itself if no localized string found
  static String fromErrorCode(BuildContext context, String errorCode) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return errorCode;

    return switch (errorCode) {
      // Network errors
      'request-cancelled' => l10n.networkErrorRequestCancelled,
      'timeout' => l10n.networkErrorTimeout,
      'no-internet' => l10n.networkErrorNoInternet,
      'connection-error' => l10n.networkErrorConnection,
      'bad-certificate' => l10n.networkErrorBadCertificate,
      'bad-response' => l10n.networkErrorBadResponse,
      'unknown-error' => l10n.networkErrorUnknown,
      'unexpected-format' => l10n.networkErrorUnexpectedFormat,

      // Location errors
      'location-services-disabled' => l10n.locationErrorServicesDisabled,
      'location-permission-denied' => l10n.locationErrorPermissionDenied,
      'location-permission-permanently-denied' => l10n.locationErrorPermissionPermanentlyDenied,
      'location-failed' => l10n.locationErrorFailed,

      // Validation errors
      'plate-number-required' => l10n.validationErrorPlateNumberRequired,
      'car-make-required' => l10n.validationErrorCarMakeRequired,
      'car-model-required' => l10n.validationErrorCarModelRequired,
      'color-required' => l10n.validationErrorColorRequired,
      'invalid-vehicle-id' => l10n.validationErrorInvalidVehicleId,

      // Operation errors
      'failed-to-add-vehicle' => l10n.operationErrorFailedToAddVehicle,
      'failed-to-update-vehicle' => l10n.operationErrorFailedToUpdateVehicle,
      'failed-to-delete-vehicle' => l10n.operationErrorFailedToDeleteVehicle,
      'failed-to-get-vehicles' => l10n.operationErrorFailedToGetVehicles,
      'failed-to-get-parking-lots' => l10n.operationErrorFailedToParkingLots,
      'failed-to-get-parking-details' => l10n.operationErrorFailedToGetParkingDetails,
      'failed-to-search-nearby' => l10n.operationErrorFailedToSearchNearby,
      'parking-not-found' => l10n.operationErrorParkingNotFound,
      'failed-to-get-notifications' => l10n.operationErrorFailedToGetNotifications,
      'failed-to-mark-notification-read' => l10n.operationErrorFailedToMarkNotificationRead,
      'failed-to-pay-violation' => l10n.operationErrorFailedToPayViolation,
      'failed-to-get-violations' => l10n.operationErrorFailedToGetViolations,
      'booking-data-null' => l10n.operationErrorBookingDataNull,
      'failed-to-initialize-map' => l10n.operationErrorFailedToInitializeMap,
      'download-directory-error' => l10n.operationErrorDownloadDirectory,

      // Auth errors
      'invalid-credentials' => l10n.authErrorInvalidCredentials,
      'unauthenticated' => l10n.authErrorUnauthenticated,
      'account-pending' => l10n.authErrorAccountPending,
      'owner-pending-approval' => l10n.authErrorOwnerPendingApproval,
      'account-blocked' => l10n.authErrorAccountBlocked,

      // Booking errors
      'booking-not-found' => l10n.bookingNotFound,
      'booking-must-be-active' => l10n.bookingMustBeActive,
      'parking-lot-full' => l10n.parkingLotFull,
      'parking-lot-unavailable' => l10n.parkingLotUnavailable,
      'vehicle-not-owned' => l10n.vehicleNotOwned,
      'invalid-hours' => l10n.invalidHours,
      'booking-already-cancelled' => l10n.bookingAlreadyCancelled,
      'booking-cannot-be-cancelled' => l10n.bookingCannotBeCancelled,
      'invalid-amount' => l10n.paymentErrorInvalidAmount,
      'invalid-booking-id' => l10n.errorInvalidBookingId,
      'booking-id-missing' => l10n.errorBookingIdMissing,

      // Profile errors
      'incorrect-password' => l10n.profileErrorIncorrectPassword,
      'password-mismatch' => l10n.profileErrorPasswordMismatch,
      'email-exists' => l10n.profileErrorEmailExists,
      'unauthorized' => l10n.profileErrorUnauthorized,
      'profile-not-found' => l10n.profileErrorNotFound,

      // Connection errors
      'connection-timeout' => l10n.errorConnectionTimeout,
      'connection-failed' => l10n.errorConnectionFailed,

      // Generic
      'unexpected-error' => l10n.errorUnexpected,

      // Default: return the error code itself
      _ => errorCode,
    };
  }

  /// Get localized success message from operation type
  static String getSuccessMessage(BuildContext context, String operationType) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return operationType;

    return switch (operationType) {
      'vehicle-added' => l10n.successVehicleAdded,
      'vehicle-update-requested' => l10n.successVehicleUpdateRequested,
      'vehicle-deleted' => l10n.successVehicleDeleted,
      'violation-paid' => l10n.successViolationPaid,
      'login-success' => l10n.authLoginSuccess,
      'logout-success' => l10n.authSuccessLogout,
      'register-success' => l10n.authSuccessRegister,
      'register-owner-success' => l10n.authSuccessRegisterOwner,
      'profile-updated' => l10n.profileSuccessUpdate,
      'password-updated' => l10n.profileSuccessPasswordUpdate,
      'account-deleted' => l10n.profileSuccessDeleteAccount,
      'booking-created' => l10n.bookingCreatedSuccess,
      'booking-cancelled' => l10n.bookingCancelledSuccess,
      'booking-extended' => l10n.bookingExtendedSuccess,
      'payment-processed' => l10n.paymentProcessedSuccess,
      'parking-created' => l10n.parkingSuccessCreate,
      'parking-updated' => l10n.parkingSuccessUpdate,
      'invoice-downloaded' => l10n.invoiceDownloadSuccess,
      _ => operationType,
    };
  }
}

/// Extension on AppException for easy localized message access
extension AppExceptionLocalization on AppException {
  /// Get localized message for this exception
  String localizedMessage(BuildContext context) {
    return LocalizedErrorMessages.fromException(context, this);
  }
}

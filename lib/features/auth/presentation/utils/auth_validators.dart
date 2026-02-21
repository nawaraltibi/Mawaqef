import '../../../../l10n/app_localizations.dart';
import '../../bloc/login/login_bloc.dart' show ValidationErrorType;

/// Centralized validation logic for auth forms
class AuthValidators {
  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.authValidationEmailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return l10n.authValidationEmailInvalid;
    }
    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.authValidationPasswordRequired;
    }
    if (value.length < 8) {
      return l10n.authValidationPasswordShort;
    }
    return null;
  }

  static String? fullName(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.authValidationFullNameRequired;
    }
    if (value.length > 255) {
      return l10n.authValidationFullNameLong;
    }
    return null;
  }

  static String? phone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.authValidationPhoneRequired;
    }
    return null;
  }

  static String? passwordConfirmation(
    String? value,
    String password,
    AppLocalizations l10n,
  ) {
    if (value == null || value.isEmpty) {
      return l10n.authValidationPasswordConfirmationRequired;
    }
    if (value != password) {
      return l10n.authValidationPasswordMismatch;
    }
    return null;
  }
  
  /// Maps ValidationErrorType to localized error message for email field
  static String? getEmailErrorMessage(
    ValidationErrorType? errorType,
    AppLocalizations l10n,
  ) {
    if (errorType == null) return null;
    
    switch (errorType) {
      case ValidationErrorType.required:
        return l10n.authValidationEmailRequired;
      case ValidationErrorType.invalidFormat:
        return l10n.authValidationEmailInvalid;
      default:
        return l10n.authValidationEmailRequired;
    }
  }
  
  /// Maps ValidationErrorType to localized error message for password field
  static String? getPasswordErrorMessage(
    ValidationErrorType? errorType,
    AppLocalizations l10n,
  ) {
    if (errorType == null) return null;
    
    switch (errorType) {
      case ValidationErrorType.required:
        return l10n.authValidationPasswordRequired;
      case ValidationErrorType.tooShort:
        return l10n.authValidationPasswordShort;
      default:
        return l10n.authValidationPasswordRequired;
    }
  }
  
  /// Maps ValidationErrorType to localized error message for full name field
  static String? getFullNameErrorMessage(
    ValidationErrorType? errorType,
    AppLocalizations l10n,
  ) {
    if (errorType == null) return null;
    
    switch (errorType) {
      case ValidationErrorType.required:
        return l10n.authValidationFullNameRequired;
      case ValidationErrorType.tooLong:
        return l10n.authValidationFullNameLong;
      default:
        return l10n.authValidationFullNameRequired;
    }
  }
  
  /// Maps ValidationErrorType to localized error message for phone field
  static String? getPhoneErrorMessage(
    ValidationErrorType? errorType,
    AppLocalizations l10n,
  ) {
    if (errorType == null) return null;
    
    switch (errorType) {
      case ValidationErrorType.required:
        return l10n.authValidationPhoneRequired;
      default:
        return l10n.authValidationPhoneRequired;
    }
  }
  
  /// Maps ValidationErrorType to localized error message for password confirmation field
  static String? getPasswordConfirmationErrorMessage(
    ValidationErrorType? errorType,
    AppLocalizations l10n,
  ) {
    if (errorType == null) return null;
    
    switch (errorType) {
      case ValidationErrorType.required:
        return l10n.authValidationPasswordConfirmationRequired;
      case ValidationErrorType.mismatch:
        return l10n.authValidationPasswordMismatch;
      default:
        return l10n.authValidationPasswordConfirmationRequired;
    }
  }
}


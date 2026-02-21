import 'package:flutter/material.dart';
import 'app_colors.dart';

/// App Text Styles Helper
/// Provides easy access to theme-based text styles with optional color overrides
/// All styles inherit from Theme.of(context).textTheme to ensure consistent typography
class AppTextStyles {
  /// Get text theme from context
  static TextTheme _textTheme(BuildContext context) =>
      Theme.of(context).textTheme;

  /// Display Large - Largest display text
  static TextStyle displayLarge(BuildContext context, {Color? color}) =>
      _textTheme(context).displayLarge!.copyWith(color: color);

  /// Display Medium - Medium display text
  static TextStyle displayMedium(BuildContext context, {Color? color}) =>
      _textTheme(context).displayMedium!.copyWith(color: color);

  /// Display Small - Small display text
  static TextStyle displaySmall(BuildContext context, {Color? color}) =>
      _textTheme(context).displaySmall!.copyWith(color: color);

  /// Headline Large - Large section headers
  static TextStyle headlineLarge(BuildContext context, {Color? color}) =>
      _textTheme(context).headlineLarge!.copyWith(color: color);

  /// Headline Medium - Medium section headers
  static TextStyle headlineMedium(BuildContext context, {Color? color}) =>
      _textTheme(context).headlineMedium!.copyWith(color: color);

  /// Headline Small - Small section headers
  static TextStyle headlineSmall(BuildContext context, {Color? color}) =>
      _textTheme(context).headlineSmall!.copyWith(color: color);

  /// Title Large - Large titles (card titles, list headers)
  static TextStyle titleLarge(BuildContext context, {Color? color}) =>
      _textTheme(context).titleLarge!.copyWith(color: color);

  /// Title Medium - Medium titles
  static TextStyle titleMedium(BuildContext context, {Color? color}) =>
      _textTheme(context).titleMedium!.copyWith(color: color);

  /// Title Small - Small titles
  static TextStyle titleSmall(BuildContext context, {Color? color}) =>
      _textTheme(context).titleSmall!.copyWith(color: color);

  /// Body Large - Large body text
  static TextStyle bodyLarge(BuildContext context, {Color? color}) =>
      _textTheme(context).bodyLarge!.copyWith(color: color);

  /// Body Medium - Medium body text (default)
  static TextStyle bodyMedium(BuildContext context, {Color? color}) =>
      _textTheme(context).bodyMedium!.copyWith(color: color);

  /// Body Small - Small body text
  static TextStyle bodySmall(BuildContext context, {Color? color}) =>
      _textTheme(context).bodySmall!.copyWith(color: color);

  /// Label Large - Large labels (buttons, captions)
  static TextStyle labelLarge(BuildContext context, {Color? color}) =>
      _textTheme(context).labelLarge!.copyWith(color: color);

  /// Label Medium - Medium labels
  static TextStyle labelMedium(BuildContext context, {Color? color}) =>
      _textTheme(context).labelMedium!.copyWith(color: color);

  /// Label Small - Small labels
  static TextStyle labelSmall(BuildContext context, {Color? color}) =>
      _textTheme(context).labelSmall!.copyWith(color: color);

  // Common text style helpers for specific use cases

  /// Field Label - For form field labels
  static TextStyle fieldLabel(BuildContext context) =>
      _textTheme(context).labelSmall!.copyWith(
            color: AppColors.secondaryText,
          );

  /// Field Input - For text input fields
  static TextStyle fieldInput(BuildContext context, {bool enabled = true}) =>
      _textTheme(context).bodyMedium!.copyWith(
            color: enabled ? AppColors.primaryText : AppColors.secondaryText,
          );

  /// Field Hint - For placeholder/hint text
  static TextStyle fieldHint(BuildContext context) =>
      _textTheme(context).bodyMedium!.copyWith(
            color: AppColors.secondaryText.withValues(alpha: 0.6),
          );

  /// Field Error - For validation error messages
  static TextStyle fieldError(BuildContext context) =>
      _textTheme(context).bodySmall!.copyWith(
            color: AppColors.error,
          );

  /// Field Helper - For instructional helper text below fields
  /// Uses muted gray color (not red) to provide guidance without stress
  static TextStyle fieldHelper(BuildContext context) =>
      _textTheme(context).bodySmall!.copyWith(
            color: AppColors.secondaryText.withValues(alpha: 0.8),
          );

  /// Button Text - For button labels
  static TextStyle buttonText(BuildContext context, {Color? color}) =>
      _textTheme(context).labelLarge!.copyWith(color: color);

  /// Card Title - For card headers
  static TextStyle cardTitle(BuildContext context) =>
      _textTheme(context).titleLarge!.copyWith(
            color: AppColors.primaryText,
          );

  /// Card Subtitle - For card secondary text
  static TextStyle cardSubtitle(BuildContext context) =>
      _textTheme(context).bodyMedium!.copyWith(
            color: AppColors.secondaryText,
          );
}


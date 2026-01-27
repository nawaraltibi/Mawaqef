import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Date Time Formatter Helper
/// Centralized date/time formatting for booking feature
class DateTimeFormatter {
  /// Format date string to display format
  /// Returns formatted date based on locale
  static String formatDate(String? dateString, BuildContext context) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final date = DateTime.parse(dateString);
      final locale = Localizations.localeOf(context);
      final isArabic = locale.languageCode == 'ar';
      final formatter = DateFormat('d MMMM yyyy', isArabic ? 'ar' : 'en');
      return formatter.format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Format time string to display format
  /// Returns formatted time based on locale
  static String formatTime(String? timeString, BuildContext context) {
    if (timeString == null || timeString.isEmpty) return '';

    try {
      final time = DateTime.parse(timeString);
      final locale = Localizations.localeOf(context);
      final isArabic = locale.languageCode == 'ar';
      final formatter = DateFormat('h:mm a', isArabic ? 'ar' : 'en');
      return formatter.format(time);
    } catch (e) {
      return timeString;
    }
  }

  /// Format date and time together
  static String formatDateTime(String? dateTimeString, BuildContext context) {
    if (dateTimeString == null || dateTimeString.isEmpty) return '';

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final locale = Localizations.localeOf(context);
      final isArabic = locale.languageCode == 'ar';
      final dateFormatter = DateFormat('d MMMM yyyy', isArabic ? 'ar' : 'en');
      final timeFormatter = DateFormat('h:mm a', isArabic ? 'ar' : 'en');
      return '${dateFormatter.format(dateTime)} ${timeFormatter.format(dateTime)}';
    } catch (e) {
      return dateTimeString;
    }
  }

  /// Parse date string to DateTime
  static DateTime? parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}


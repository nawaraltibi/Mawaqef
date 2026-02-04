import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Date Time Formatter Helper
/// Centralized date/time formatting for booking feature
class DateTimeFormatter {
  /// فرق التوقيت بين الـ API والتوقيت المحلي (السعودية UTC+3)
  static const int apiTimezoneOffsetHours = 3;

  /// Parse API date string: assumes UTC if no timezone (Z or ±HH:MM).
  /// When no timezone in string, adds [apiTimezoneOffsetHours] (3 hours) for Arabia (UTC+3).
  /// Handles both ISO (2025-02-02T13:00:00.000000Z) and DB-style (2025-02-02 13:00:00).
  static DateTime? _parseToLocal(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      final trimmed = dateString.trim();
      final hasTimezone = trimmed.endsWith('Z') ||
          RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(trimmed);
      String toParse = hasTimezone ? trimmed : trimmed + 'Z';
      if (!hasTimezone && toParse.contains(' ') && !toParse.contains('T')) {
        toParse = toParse.replaceFirst(' ', 'T');
      }
      final dt = DateTime.parse(toParse);
      // When API has no timezone, treat as UTC and add 3 hours for Arabia (UTC+3)
      if (!hasTimezone) {
        return dt.add(Duration(hours: apiTimezoneOffsetHours));
      }
      return dt.toLocal();
    } catch (e) {
      return null;
    }
  }

  /// Format date string to display format (always in local timezone)
  static String formatDate(String? dateString, BuildContext context) {
    final localDate = _parseToLocal(dateString);
    if (localDate == null) return dateString ?? '';

    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final formatter = DateFormat('d MMMM yyyy', isArabic ? 'ar' : 'en');
    return formatter.format(localDate);
  }

  /// Format time string to display format (always in local timezone)
  static String formatTime(String? timeString, BuildContext context) {
    final localTime = _parseToLocal(timeString);
    if (localTime == null) return timeString ?? '';

    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final formatter = DateFormat('h:mm a', isArabic ? 'ar' : 'en');
    return formatter.format(localTime);
  }

  /// Format date and time together (always in local timezone)
  static String formatDateTime(String? dateTimeString, BuildContext context) {
    final localDateTime = _parseToLocal(dateTimeString);
    if (localDateTime == null) return dateTimeString ?? '';

    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final dateFormatter = DateFormat('d MMMM yyyy', isArabic ? 'ar' : 'en');
    final timeFormatter = DateFormat('h:mm a', isArabic ? 'ar' : 'en');
    return '${dateFormatter.format(localDateTime)} ${timeFormatter.format(localDateTime)}';
  }

  /// Parse date string to DateTime (local time)
  /// API returns UTC - converts to local for correct display.
  static DateTime? parseDateTime(String? dateString) {
    return _parseToLocal(dateString);
  }
}


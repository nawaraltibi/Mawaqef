part of 'notifications_bloc.dart';

/// Base class for notifications states
/// Uses Equatable for efficient state comparison and preventing unnecessary rebuilds
abstract class NotificationsState extends Equatable {
  const NotificationsState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

/// Loading state - notifications operation in progress
class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

/// Loaded state - notifications loaded successfully
/// Contains separate lists for unread and read notifications
class NotificationsLoaded extends NotificationsState {
  /// List of unread notifications (isRead = false)
  final List<NotificationEntity> unreadNotifications;
  
  /// List of read notifications (isRead = true)
  final List<NotificationEntity> readNotifications;
  
  /// Unread count from server (used for badge)
  final int unreadCount;

  const NotificationsLoaded({
    required this.unreadNotifications,
    required this.readNotifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [unreadNotifications, readNotifications, unreadCount];

  /// Legacy getter for backward compatibility
  /// Returns all notifications (unread first, then read)
  List<NotificationEntity> get notifications => 
      [...unreadNotifications, ...readNotifications];

  /// Check if there are any notifications
  bool get hasNotifications => 
      unreadNotifications.isNotEmpty || readNotifications.isNotEmpty;

  /// Check if there are any unread notifications
  bool get hasUnreadNotifications => unreadNotifications.isNotEmpty;

  /// Check if there are any read notifications
  bool get hasReadNotifications => readNotifications.isNotEmpty;

  /// Create a copy with updated fields
  NotificationsLoaded copyWith({
    List<NotificationEntity>? unreadNotifications,
    List<NotificationEntity>? readNotifications,
    int? unreadCount,
  }) {
    return NotificationsLoaded(
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      readNotifications: readNotifications ?? this.readNotifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

/// Empty state - no notifications found (both read and unread)
class NotificationsEmpty extends NotificationsState {
  const NotificationsEmpty();
}

/// Error state - notifications operation failed
class NotificationsError extends NotificationsState {
  final String error;
  final int statusCode;

  const NotificationsError({
    required this.error,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [error, statusCode];
}

/// Loading state for notification actions (mark as read)
class NotificationActionLoading extends NotificationsState {
  const NotificationActionLoading();
}

/// Success state for notification actions
class NotificationActionSuccess extends NotificationsState {
  final String message;
  final int? notificationId; // ID of the notification that was marked as read

  const NotificationActionSuccess({
    required this.message,
    this.notificationId,
  });

  @override
  List<Object?> get props => [message, notificationId];
}

/// Failure state for notification actions
class NotificationActionFailure extends NotificationsState {
  final String error;
  final int statusCode;

  const NotificationActionFailure({
    required this.error,
    required this.statusCode,
  });

  @override
  List<Object?> get props => [error, statusCode];
}


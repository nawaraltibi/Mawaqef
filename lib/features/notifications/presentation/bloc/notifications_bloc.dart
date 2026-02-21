import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../../../core/utils/app_exception.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/notifications_result.dart';
import '../../domain/usecases/get_all_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';
import 'mixins/notifications_error_handler_mixin.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// Notifications Bloc
/// Manages notifications state and business logic using Bloc pattern with AsyncRunner
/// 
/// Handles both read and unread notifications with optimistic updates
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState>
    with NotificationsErrorHandlerMixin {
  final GetAllNotificationsUseCase getAllNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;

  final AsyncRunner<NotificationsResult> getAllNotificationsRunner =
      AsyncRunner<NotificationsResult>();
  final AsyncRunner<NotificationEntity> markNotificationAsReadRunner =
      AsyncRunner<NotificationEntity>();

  NotificationsBloc({
    required this.getAllNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
  }) : super(const NotificationsInitial()) {
    on<GetAllNotificationsRequested>(_onGetAllNotificationsRequested);
    on<NotificationClickedEvent>(_onNotificationClickedEvent);
    on<ResetNotificationsState>(_onResetNotificationsState);
  }

  /// Get all notifications (read and unread) for the authenticated user
  Future<void> _onGetAllNotificationsRequested(
    GetAllNotificationsRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());

    await getAllNotificationsRunner.run(
      onlineTask: (previousResult) async {
        return await getAllNotificationsUseCase();
      },
      onSuccess: (result) async {
        if (!emit.isDone) {
          if (result.isEmpty) {
            emit(const NotificationsEmpty());
          } else {
            emit(NotificationsLoaded(
              unreadNotifications: result.unreadNotifications,
              readNotifications: result.readNotifications,
              unreadCount: result.unreadCount,
            ));
          }
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleError(error, emit);
        }
      },
    );
  }

  /// Handle notification click - mark as read and move from unread to read section
  Future<void> _onNotificationClickedEvent(
    NotificationClickedEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    // Save current state for potential rollback
    final previousState = state;

    // Optimistically move notification from unread to read if we're in loaded state
    if (previousState is NotificationsLoaded) {
      // Find the notification in unread list
      final clickedNotification = previousState.unreadNotifications
          .where((n) => n.notificationId == event.notificationId)
          .firstOrNull;

      if (clickedNotification != null) {
        // Remove from unread list
        final updatedUnread = previousState.unreadNotifications
            .where((n) => n.notificationId != event.notificationId)
            .toList();

        // Add to read list (at the beginning, marked as read)
        final updatedRead = [
          clickedNotification.copyWith(isRead: true),
          ...previousState.readNotifications,
        ];

        // Calculate new unread count
        final newUnreadCount = previousState.unreadCount > 0 
            ? previousState.unreadCount - 1 
            : 0;

        // Emit updated state (optimistic update)
        if (updatedUnread.isEmpty && updatedRead.isEmpty) {
          emit(const NotificationsEmpty());
        } else {
          emit(NotificationsLoaded(
            unreadNotifications: updatedUnread,
            readNotifications: updatedRead,
            unreadCount: newUnreadCount,
          ));
        }
      }
    } else if (previousState is! NotificationsLoading &&
        previousState is! NotificationActionLoading) {
      // Only emit loading if we're not already in a loading state
      emit(const NotificationActionLoading());
    }

    await markNotificationAsReadRunner.run(
      onlineTask: (previousResult) async {
        return await markNotificationAsReadUseCase(
          notificationId: event.notificationId,
        );
      },
      onSuccess: (notification) async {
        if (!emit.isDone) {
          // Success - state should already be updated optimistically
          // If we're not in the expected state, reload to sync
          if (previousState is! NotificationsLoaded) {
            // If we weren't in loaded state, reload to get fresh data
            add(GetAllNotificationsRequested());
          }
          // Otherwise, state is already correct from optimistic update
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          // For 405 errors (Method Not Allowed), the server might have processed it
          // but returned wrong status. Try reloading instead of rolling back.
          if (error is AppException && error.statusCode == 405) {
            // Reload notifications to sync with server state
            add(GetAllNotificationsRequested());
            return;
          }

          // Rollback to previous state on other errors
          if (previousState is NotificationsLoaded) {
            emit(previousState);
          } else {
            handleNotificationActionError(error, emit);
          }
        }
      },
    );
  }

  /// Reset notifications state
  void _onResetNotificationsState(
    ResetNotificationsState event,
    Emitter<NotificationsState> emit,
  ) {
    if (state is NotificationsLoaded) {
      final loadedState = state as NotificationsLoaded;
      emit(NotificationsLoaded(
        unreadNotifications: loadedState.unreadNotifications,
        readNotifications: loadedState.readNotifications,
        unreadCount: loadedState.unreadCount,
      ));
    } else {
      emit(const NotificationsInitial());
    }
  }
}

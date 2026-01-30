import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../../../core/utils/app_exception.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_all_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import 'mixins/notifications_error_handler_mixin.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

/// Notifications Bloc
/// Manages notifications state and business logic using Bloc pattern with AsyncRunner
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState>
    with NotificationsErrorHandlerMixin {
  final GetAllNotificationsUseCase getAllNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;

  final AsyncRunner<List<NotificationEntity>> getAllNotificationsRunner =
      AsyncRunner<List<NotificationEntity>>();
  final AsyncRunner<NotificationEntity> markNotificationAsReadRunner =
      AsyncRunner<NotificationEntity>();

  NotificationsBloc({
    required this.getAllNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
  }) : super(NotificationsInitial()) {
    on<GetAllNotificationsRequested>(_onGetAllNotificationsRequested);
    on<NotificationClickedEvent>(_onNotificationClickedEvent);
    on<ResetNotificationsState>(_onResetNotificationsState);
  }

  /// Get all unread notifications for the authenticated user
  Future<void> _onGetAllNotificationsRequested(
    GetAllNotificationsRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());

    await getAllNotificationsRunner.run(
      onlineTask: (previousResult) async {
        return await getAllNotificationsUseCase();
      },
      onSuccess: (notifications) async {
        if (!emit.isDone) {
          if (notifications.isEmpty) {
            emit(NotificationsEmpty());
          } else {
            emit(NotificationsLoaded(notifications: notifications));
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

  /// Handle notification click - mark as read and remove from list
  Future<void> _onNotificationClickedEvent(
    NotificationClickedEvent event,
    Emitter<NotificationsState> emit,
  ) async {
    // Save current state for potential rollback
    final previousState = state;

    // Optimistically remove notification from list if we're in loaded state
    if (previousState is NotificationsLoaded) {
      final currentNotifications = previousState.notifications;
      final updatedNotifications = currentNotifications
          .where((n) => n.notificationId != event.notificationId)
          .toList();

      // Update UI immediately (optimistic update)
      if (updatedNotifications.isEmpty) {
        emit(NotificationsEmpty());
      } else {
        emit(NotificationsLoaded(notifications: updatedNotifications));
      }
    } else if (previousState is! NotificationsLoading &&
        previousState is! NotificationActionLoading) {
      // Only emit loading if we're not already in a loading state
      emit(NotificationActionLoading());
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
      emit(
        NotificationsLoaded(
          notifications: (state as NotificationsLoaded).notifications,
        ),
      );
    } else {
      emit(NotificationsInitial());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notifications_bloc.dart';
import '../widgets/notification_card.dart';
import '../widgets/notifications_empty_state.dart';
import '../widgets/notifications_error_state.dart';

/// Notifications Screen
/// Displays list of unread notifications
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationEntity>? _cachedNotifications;
  bool _cachedEmpty = false;

  @override
  void initState() {
    super.initState();
    // Load notifications on init
    context.read<NotificationsBloc>().add(GetAllNotificationsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          l10n.notificationsTitle,
          style: AppTextStyles.titleLarge(context),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: BlocListener<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            // Handle notification click success
            if (state is NotificationActionSuccess) {
              // Notification was marked as read, state already updated
              // No need to show snackbar as it's handled optimistically
            }
          },
          child: BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) {
              Widget child;

              if (state is NotificationsLoaded) {
                _cachedNotifications = state.notifications;
                _cachedEmpty = state.notifications.isEmpty;
                child = _NotificationsList(
                  key: const ValueKey('notifications_loaded'),
                  notifications: state.notifications,
                  onRefresh: () async {
                    context.read<NotificationsBloc>().add(
                      GetAllNotificationsRequested(),
                    );
                  },
                );
              } else if (state is NotificationsEmpty && _cachedEmpty) {
                child = const NotificationsEmptyState(
                  key: ValueKey('notifications_empty'),
                );
              } else if (state is NotificationsError) {
                child = NotificationsErrorState(
                  key: const ValueKey('notifications_error'),
                  error: state.error,
                  onRetry: () => context.read<NotificationsBloc>().add(
                    GetAllNotificationsRequested(),
                  ),
                );
              } else if (state is NotificationsLoading ||
                  state is NotificationsInitial) {
                child = const _NotificationsSkeleton(
                  key: ValueKey('notifications_loading'),
                );
              } else if (state is NotificationActionLoading ||
                  state is NotificationActionSuccess ||
                  state is NotificationActionFailure) {
                // Keep showing cached list while actions are running
                if (_cachedNotifications != null &&
                    _cachedNotifications!.isNotEmpty) {
                  child = _NotificationsList(
                    key: const ValueKey('notifications_cached'),
                    notifications: _cachedNotifications!,
                    onRefresh: () async {
                      context.read<NotificationsBloc>().add(
                        GetAllNotificationsRequested(),
                      );
                    },
                  );
                } else if (_cachedEmpty) {
                  child = const NotificationsEmptyState(
                    key: ValueKey('notifications_empty_cached'),
                  );
                } else {
                  child = const _NotificationsSkeleton(
                    key: ValueKey('notifications_loading_cached'),
                  );
                }
              } else {
                child = const _NotificationsSkeleton(
                  key: ValueKey('notifications_default'),
                );
              }

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NotificationsList extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final Future<void> Function() onRefresh;

  const _NotificationsList({
    super.key,
    required this.notifications,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const NotificationsEmptyState();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 16.h,
          top: 12.h,
        ),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          if (index >= notifications.length) {
            return const SizedBox.shrink();
          }
          final notification = notifications[index];
          if (notification == null) {
            return const SizedBox.shrink();
          }
          return NotificationCard(
            key: ValueKey(notification.notificationId),
            notification: notification,
            onTap: () {
              // Mark as read when clicked
              context.read<NotificationsBloc>().add(
                NotificationClickedEvent(
                  notificationId: notification.notificationId,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationsSkeleton extends StatelessWidget {
  const _NotificationsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        const Center(child: LoadingWidget()),
        SizedBox(height: 16.h),
        Expanded(
          child: ListView.builder(
            shrinkWrap: false,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _NotificationCardSkeleton(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NotificationCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(flex: 15, child: _SkeletonLine(height: 8.h)),
                  SizedBox(width: 12.w),
                  Expanded(flex: 85, child: _SkeletonLine()),
                ],
              ),
              SizedBox(height: 12.h),
              _SkeletonLine(widthFactor: 0.9),
              SizedBox(height: 8.h),
              _SkeletonLine(widthFactor: 0.7),
              SizedBox(height: 12.h),
              _SkeletonLine(widthFactor: 0.4, height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double? widthFactor;
  final double height;

  const _SkeletonLine({this.widthFactor, this.height = 12});

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      height: height.h,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );

    if (widthFactor != null) {
      return FractionallySizedBox(widthFactor: widthFactor!, child: child);
    }

    return child;
  }
}

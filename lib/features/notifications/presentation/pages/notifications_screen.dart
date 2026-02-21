import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notifications_bloc.dart';
import '../widgets/notification_card.dart';
import '../widgets/notifications_error_state.dart';

/// Notifications Screen - Optimized for 60fps swipe performance
/// 
/// Key optimizations:
/// - TabBarView with ClampingScrollPhysics (lighter than Bouncing)
/// - BlocSelector per tab for granular rebuilds
/// - AutomaticKeepAliveClientMixin to preserve tab state
/// - Cached decorations and dimensions
/// - RepaintBoundary around expensive widgets
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  
  // Pre-computed dimensions - avoid .w/.h calls during build
  late final double _tabBarHeight;
  late final double _horizontalMargin;
  late final double _badgePaddingH;
  late final double _badgePaddingV;
  late final double _badgeRadius;
  late final double _containerRadius;
  late final double _badgeFontSize;
  
  // Pre-computed decorations - avoid recreation during swipe
  late final BoxDecoration _tabBarContainerDecoration;
  late final BoxDecoration _indicatorDecoration;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load notifications on page open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsBloc>().add(GetAllNotificationsRequested());
    });
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache ScreenUtil values after context is available
    _tabBarHeight = 50.h;
    _horizontalMargin = 20.w;
    _badgePaddingH = 6.w;
    _badgePaddingV = 2.h;
    _badgeRadius = 10.r;
    _containerRadius = 12.r;
    _badgeFontSize = 11.sp;
    
    // Pre-build decorations
    _tabBarContainerDecoration = BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(_containerRadius),
    );
    _indicatorDecoration = BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(_containerRadius),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          preferredSize: Size.fromHeight(_tabBarHeight),
          child: _OptimizedTabBar(
            tabController: _tabController,
            containerDecoration: _tabBarContainerDecoration,
            indicatorDecoration: _indicatorDecoration,
            horizontalMargin: _horizontalMargin,
            badgePaddingH: _badgePaddingH,
            badgePaddingV: _badgePaddingV,
            badgeRadius: _badgeRadius,
            badgeFontSize: _badgeFontSize,
            l10n: l10n,
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: TabBarView(
          controller: _tabController,
          // ClampingScrollPhysics is lighter than BouncingScrollPhysics
          physics: const ClampingScrollPhysics(),
          children: const [
            _KeepAliveTab(child: _OptimizedNotificationsTab(isUnreadTab: true)),
            _KeepAliveTab(child: _OptimizedNotificationsTab(isUnreadTab: false)),
          ],
        ),
      ),
    );
  }
}

/// Optimized TabBar that only rebuilds badge counts, not during swipe
class _OptimizedTabBar extends StatelessWidget {
  final TabController tabController;
  final BoxDecoration containerDecoration;
  final BoxDecoration indicatorDecoration;
  final double horizontalMargin;
  final double badgePaddingH;
  final double badgePaddingV;
  final double badgeRadius;
  final double badgeFontSize;
  final AppLocalizations l10n;

  const _OptimizedTabBar({
    required this.tabController,
    required this.containerDecoration,
    required this.indicatorDecoration,
    required this.horizontalMargin,
    required this.badgePaddingH,
    required this.badgePaddingV,
    required this.badgeRadius,
    required this.badgeFontSize,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
      decoration: containerDecoration,
      child: BlocSelector<NotificationsBloc, NotificationsState, (int, int)>(
        selector: (state) {
          if (state is NotificationsLoaded) {
            return (state.unreadNotifications.length, state.readNotifications.length);
          }
          return (0, 0);
        },
        builder: (context, counts) {
          final (unreadCount, readCount) = counts;
          
          return TabBar(
            controller: tabController,
            indicator: indicatorDecoration,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: AppColors.textOnPrimary,
            unselectedLabelColor: AppColors.secondaryText,
            // Use AnimatedBuilder for badge colors that depend on tab index
            // This prevents full TabBar rebuild during swipe
            tabs: [
              _AnimatedBadgeTab(
                tabController: tabController,
                tabIndex: 0,
                label: l10n.notificationsUnread,
                count: unreadCount,
                activeColor: AppColors.primary,
                badgePaddingH: badgePaddingH,
                badgePaddingV: badgePaddingV,
                badgeRadius: badgeRadius,
                badgeFontSize: badgeFontSize,
              ),
              _AnimatedBadgeTab(
                tabController: tabController,
                tabIndex: 1,
                label: l10n.notificationsRead,
                count: readCount,
                activeColor: AppColors.secondaryText,
                badgePaddingH: badgePaddingH,
                badgePaddingV: badgePaddingV,
                badgeRadius: badgeRadius,
                badgeFontSize: badgeFontSize,
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Tab with animated badge that smoothly transitions colors
/// Uses AnimatedBuilder to only rebuild the badge, not the entire tab
class _AnimatedBadgeTab extends StatelessWidget {
  final TabController tabController;
  final int tabIndex;
  final String label;
  final int count;
  final Color activeColor;
  final double badgePaddingH;
  final double badgePaddingV;
  final double badgeRadius;
  final double badgeFontSize;

  const _AnimatedBadgeTab({
    required this.tabController,
    required this.tabIndex,
    required this.label,
    required this.count,
    required this.activeColor,
    required this.badgePaddingH,
    required this.badgePaddingV,
    required this.badgeRadius,
    required this.badgeFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 6),
            // AnimatedBuilder only rebuilds badge during tab animation
            AnimatedBuilder(
              animation: tabController.animation!,
              builder: (context, child) {
                // Calculate selection progress for this tab
                final double progress;
                if (tabIndex == 0) {
                  progress = 1.0 - tabController.animation!.value;
                } else {
                  progress = tabController.animation!.value;
                }
                
                // Interpolate colors based on selection
                final isSelected = progress > 0.5;
                final badgeColor = isSelected
                    ? AppColors.textOnPrimary.withOpacity(0.2)
                    : activeColor.withOpacity(0.2);
                final textColor = isSelected
                    ? AppColors.textOnPrimary
                    : activeColor;

                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: badgePaddingH,
                    vertical: badgePaddingV,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(badgeRadius),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      fontSize: badgeFontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Wrapper to keep tab content alive during swipes
class _KeepAliveTab extends StatefulWidget {
  final Widget child;

  const _KeepAliveTab({required this.child});

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

/// Optimized notification tab using BlocSelector for granular updates
class _OptimizedNotificationsTab extends StatefulWidget {
  final bool isUnreadTab;

  const _OptimizedNotificationsTab({required this.isUnreadTab});

  @override
  State<_OptimizedNotificationsTab> createState() => _OptimizedNotificationsTabState();
}

class _OptimizedNotificationsTabState extends State<_OptimizedNotificationsTab> {
  // Cache dimensions
  late final EdgeInsets _listPadding;
  late final double _itemExtent;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _listPadding = EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);
    // Approximate item height for better scroll performance
    _itemExtent = 120.h;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return BlocSelector<NotificationsBloc, NotificationsState, _TabState>(
      selector: (state) {
        if (state is NotificationsLoading || state is NotificationsInitial) {
          return const _TabState.loading();
        }
        if (state is NotificationsError) {
          return _TabState.error(state.error);
        }
        if (state is NotificationsEmpty) {
          return const _TabState.empty();
        }
        if (state is NotificationsLoaded) {
          final list = widget.isUnreadTab 
              ? state.unreadNotifications 
              : state.readNotifications;
          return _TabState.loaded(list);
        }
        return const _TabState.loading();
      },
      builder: (context, tabState) {
        if (tabState.isLoading) {
          return const _NotificationsSkeleton();
        }

        if (tabState.isError) {
          return NotificationsErrorState(
            error: tabState.errorMessage ?? '',
            onRetry: () => context.read<NotificationsBloc>().add(
              GetAllNotificationsRequested(),
            ),
          );
        }

        if (tabState.isEmpty || (tabState.notifications?.isEmpty ?? true)) {
          return _EmptyTabContent(isUnreadTab: widget.isUnreadTab, l10n: l10n);
        }

        final notifications = tabState.notifications!;

        return RefreshIndicator(
          onRefresh: () async {
            context.read<NotificationsBloc>().add(GetAllNotificationsRequested());
          },
          child: ListView.builder(
            padding: _listPadding,
            itemCount: notifications.length,
            // Fixed item extent improves scroll performance significantly
            itemExtent: _itemExtent,
            // Increase cache for smoother scrolling during swipe
            cacheExtent: 500,
            // Disable automatic keep alives - we handle this manually
            addAutomaticKeepAlives: false,
            // Enable repaint boundaries for each item
            addRepaintBoundaries: true,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              // RepaintBoundary prevents card repaints during swipe
              return RepaintBoundary(
                child: NotificationCard(
                  key: ValueKey(notification.notificationId),
                  notification: notification,
                  onTap: () => _navigateToDetails(context, notification),
                  onMarkAsRead: widget.isUnreadTab 
                      ? () => _onMarkAsReadOnly(context, notification)
                      : null,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _onMarkAsReadOnly(BuildContext context, NotificationEntity notification) {
    if (notification.isUnread) {
      context.read<NotificationsBloc>().add(
        NotificationClickedEvent(notificationId: notification.notificationId),
      );
    }
  }

  void _navigateToDetails(BuildContext context, NotificationEntity notification) {
    if (notification.isUnread) {
      context.read<NotificationsBloc>().add(
        NotificationClickedEvent(notificationId: notification.notificationId),
      );
    }
    context.push(
      Routes.notificationDetailsPath.replaceAll(
        ':id',
        notification.notificationId.toString(),
      ),
      extra: notification,
    );
  }
}

/// Immutable state class with optimized equality check
class _TabState {
  final bool isLoading;
  final bool isError;
  final bool isEmpty;
  final String? errorMessage;
  final List<NotificationEntity>? notifications;
  // Cache hash for faster equality checks
  final int _cachedHash;

  const _TabState._({
    this.isLoading = false,
    this.isError = false,
    this.isEmpty = false,
    this.errorMessage,
    this.notifications,
  }) : _cachedHash = 0;
  
  _TabState._withHash({
    this.isLoading = false,
    this.isError = false,
    this.isEmpty = false,
    this.errorMessage,
    this.notifications,
  }) : _cachedHash = Object.hash(
    isLoading,
    isError,
    isEmpty,
    errorMessage,
    notifications?.length,
    notifications?.firstOrNull?.notificationId,
    notifications?.lastOrNull?.notificationId,
  );

  const _TabState.loading() : this._(isLoading: true);
  const _TabState.empty() : this._(isEmpty: true);
  factory _TabState.error(String message) => _TabState._withHash(isError: true, errorMessage: message);
  factory _TabState.loaded(List<NotificationEntity> list) => _TabState._withHash(notifications: list);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! _TabState) return false;
    
    // Fast path: compare cached hashes first
    if (_cachedHash != 0 && other._cachedHash != 0 && _cachedHash != other._cachedHash) {
      return false;
    }
    
    if (isLoading != other.isLoading) return false;
    if (isError != other.isError) return false;
    if (isEmpty != other.isEmpty) return false;
    if (errorMessage != other.errorMessage) return false;
    
    if (notifications == null && other.notifications == null) return true;
    if (notifications == null || other.notifications == null) return false;
    if (notifications!.length != other.notifications!.length) return false;
    
    // Compare first and last IDs for quick check
    if (notifications!.isNotEmpty) {
      if (notifications!.first.notificationId != other.notifications!.first.notificationId) {
        return false;
      }
      if (notifications!.last.notificationId != other.notifications!.last.notificationId) {
        return false;
      }
    }
    
    return true;
  }

  @override
  int get hashCode => _cachedHash != 0 ? _cachedHash : Object.hash(
    isLoading, isError, isEmpty, errorMessage, notifications?.length,
  );
}

/// Empty state widget
class _EmptyTabContent extends StatelessWidget {
  final bool isUnreadTab;
  final AppLocalizations l10n;

  const _EmptyTabContent({
    required this.isUnreadTab,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NotificationsBloc>().add(GetAllNotificationsRequested());
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isUnreadTab 
                        ? Icons.notifications_active_outlined
                        : Icons.notifications_none_outlined,
                    size: 64.sp,
                    color: AppColors.secondaryText,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    isUnreadTab 
                        ? l10n.noUnreadNotifications
                        : l10n.noReadNotifications,
                    style: AppTextStyles.bodyLarge(
                      context,
                      color: AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton loading state
class _NotificationsSkeleton extends StatelessWidget {
  const _NotificationsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        const Center(child: LoadingWidget()),
        SizedBox(height: 16.h),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: const _NotificationCardSkeleton(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NotificationCardSkeleton extends StatelessWidget {
  const _NotificationCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
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
                Expanded(flex: 85, child: _SkeletonLine(height: 12.h)),
              ],
            ),
            SizedBox(height: 12.h),
            _SkeletonLine(widthFactor: 0.9, height: 12.h),
            SizedBox(height: 8.h),
            _SkeletonLine(widthFactor: 0.7, height: 12.h),
            SizedBox(height: 12.h),
            _SkeletonLine(widthFactor: 0.4, height: 10.h),
          ],
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double? widthFactor;
  final double height;

  const _SkeletonLine({this.widthFactor, required this.height});

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: SizedBox(height: height),
    );

    if (widthFactor != null) {
      return FractionallySizedBox(
        widthFactor: widthFactor!,
        alignment: AlignmentDirectional.centerStart,
        child: child,
      );
    }

    return child;
  }
}

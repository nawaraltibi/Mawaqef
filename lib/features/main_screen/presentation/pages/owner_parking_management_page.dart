import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../parking/bloc/parking_list/parking_list_bloc.dart';
import '../../../parking/bloc/parking_stats/parking_stats_bloc.dart';
import '../../../parking/presentation/pages/parking_list_screen.dart';
import '../../../parking/presentation/pages/parking_dashboard_screen.dart';

/// Owner Parking Management Page
/// Main page for parking management with tabs for list and dashboard
class OwnerParkingManagementPage extends StatefulWidget {
  const OwnerParkingManagementPage({super.key});

  @override
  State<OwnerParkingManagementPage> createState() =>
      _OwnerParkingManagementPageState();
}

class _OwnerParkingManagementPageState
    extends State<OwnerParkingManagementPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider<ParkingListBloc>(
          create: (context) {
            final bloc = ParkingListBloc();
            debugPrint('🏗️ OwnerParkingManagementPage: Created ParkingListBloc instance: ${bloc.hashCode}');
            return bloc;
          },
        ),
        BlocProvider<ParkingStatsBloc>(
          create: (context) {
            final bloc = ParkingStatsBloc();
            debugPrint('🏗️ OwnerParkingManagementPage: Created ParkingStatsBloc instance: ${bloc.hashCode}');
            return bloc;
          },
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // App Bar with Title and Notifications
            Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 8.w,
                top: 8.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.ownerTabParkingManagement,
                    style: AppTextStyles.headlineSmall(context),
                  ),
                  const _OwnerNotificationsIconButton(),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            // Modern TabBar with smooth design
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: LinearGradient(
                    colors: AppColors.buttonGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.all(4.w),
                dividerColor: Colors.transparent,
                labelColor: AppColors.textOnPrimary,
                unselectedLabelColor: AppColors.secondaryText,
                labelStyle: AppTextStyles.labelMedium(context),
                unselectedLabelStyle: AppTextStyles.labelMedium(context),
                tabs: [
                  Tab(
                    height: 48.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          EvaIcons.gridOutline,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            l10n.parkingTitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    height: 48.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          EvaIcons.pieChartOutline,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            l10n.parkingDashboardTitle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: const [
                  ParkingListScreen(),
                  ParkingDashboardScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Owner Notifications Icon Button Widget
/// Displays notification icon with unread count badge for owner
class _OwnerNotificationsIconButton extends StatefulWidget {
  const _OwnerNotificationsIconButton();

  @override
  State<_OwnerNotificationsIconButton> createState() =>
      _OwnerNotificationsIconButtonState();
}

class _OwnerNotificationsIconButtonState extends State<_OwnerNotificationsIconButton> {
  late NotificationsBloc _notificationsBloc;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _notificationsBloc = getIt<NotificationsBloc>();
    // Load notifications once
    if (!_hasLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notificationsBloc.add(GetAllNotificationsRequested());
        _hasLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notificationsBloc,
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          // Use unreadCount from server for accurate badge count
          int unreadCount = 0;
          if (state is NotificationsLoaded) {
            unreadCount = state.unreadCount;
          }

          final l10n = AppLocalizations.of(context);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(
                  EvaIcons.bellOutline,
                  size: 24.sp,
                ),
                tooltip: l10n?.notificationsTitle ?? 'Notifications',
                onPressed: () {
                  context.push(Routes.notificationsPath);
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

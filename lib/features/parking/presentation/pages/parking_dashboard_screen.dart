import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/parking_stats/parking_stats_bloc.dart';
import '../../models/owner_dashboard_stats_response.dart';
import '../widgets/dashboard_card.dart';

/// Helper function to format currency based on current language
/// Converts backend format (e.g., "100.00 ر.س" or "1,234.56 ر.س") to localized format
String formatCurrency(String? value, AppLocalizations l10n) {
  if (value == null || value.isEmpty) {
    return '0.00 ${l10n.currencySymbol}';
  }
  
  // Remove currency symbols (both old and new) and any whitespace
  String cleaned = value
      .replaceAll('ر.س', '')
      .replaceAll('ل.س', '')
      .replaceAll('SAR', '')
      .replaceAll('SYP', '')
      .trim();
  
  // Extract numeric value (preserve decimal formatting, remove commas for parsing)
  final numericValue = cleaned.replaceAll(',', '').trim();
  
  // If no numeric value found, return default
  if (numericValue.isEmpty) {
    return '0.00 ${l10n.currencySymbol}';
  }
  
  // Validate it's a valid number
  final parsedValue = double.tryParse(numericValue);
  if (parsedValue == null) {
    return '0.00 ${l10n.currencySymbol}';
  }
  
  // Format with 2 decimal places and localized currency symbol
  return '${parsedValue.toStringAsFixed(2)} ${l10n.currencySymbol}';
}

/// Parking Dashboard Screen
/// Modern, data-driven dashboard with welcome header, KPI cards, and occupancy indicators
/// 
/// Safety Features:
/// - Strict state-based rendering (only renders when data is loaded)
/// - No unsafe null assertions
/// - Validated percent calculations
/// - Safe string operations
/// - Proper layout constraints (no unbounded errors)
class ParkingDashboardScreen extends StatelessWidget {
  const ParkingDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Safe localization access
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ParkingStatsBloc, ParkingStatsState>(
        builder: (context, state) {
          // Loading State
          if (state is ParkingStatsLoading) {
            return const Center(
              child: LoadingWidget(),
            );
          }

          // Error State
          if (state is ParkingStatsError) {
            String errorMessage = state.message;
            if (state.statusCode == 403) {
              errorMessage = l10n.parkingErrorUnauthorized;
            }

            return ErrorStateWidget(
              message: errorMessage,
              onRetry: () {
                context.read<ParkingStatsBloc>().add(const LoadParkingStats());
              },
            );
          }

          // Loaded State
          if (state is ParkingStatsLoaded) {
            final data = state.response.data;
            
            // Validate data before rendering
            if (!_isValidDashboardData(data)) {
              return ErrorStateWidget(
                message: l10n.parkingDashboardErrorInvalidData,
                onRetry: () {
                  context.read<ParkingStatsBloc>().add(const LoadParkingStats());
                },
              );
            }

            return DashboardContent(data: data);
          }

          // Initial state - trigger load
          if (state is ParkingStatsInitial) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ParkingStatsBloc>().add(const LoadParkingStats());
            });
          }

          // Default fallback
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Validate dashboard data integrity
  bool _isValidDashboardData(DashboardData data) {
    try {
      // Check all required fields exist
      if (data.summary.ownerName.isEmpty) return false;
      if (data.occupancyStats.totalSpaces < 0) return false;
      if (data.occupancyStats.occupiedSpaces < 0) return false;
      if (data.occupancyStats.occupiedSpaces > data.occupancyStats.totalSpaces) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Dashboard Content Widget
/// Assumes data is fully loaded and validated
/// No null assertions - all data is guaranteed to be present
/// 
/// Layout Safety:
/// - Column uses mainAxisSize.min to prevent unbounded height
/// - All nested widgets have proper constraints
class DashboardContent extends StatelessWidget {
  final DashboardData data;

  const DashboardContent({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ParkingStatsBloc>().add(const LoadParkingStats());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Header
            _WelcomeHeader(ownerName: data.summary.ownerName),
            SizedBox(height: 24.h),

            // Primary KPI Card - Today's Revenue (Hero Section)
            _HeroKPICard(
              todayRevenue: data.financialStats.revenueByPeriod.today,
            ),
            SizedBox(height: 24.h),

            // Live Occupancy Indicator
            _OccupancyIndicator(stats: data.occupancyStats),
            SizedBox(height: 24.h),

            // Summary Stats Grid (2x2)
            _SummaryStatsGrid(data: data),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}

/// Welcome Header Widget
/// Layout Safety: Column uses mainAxisSize.min
class _WelcomeHeader extends StatelessWidget {
  final String ownerName;

  const _WelcomeHeader({required this.ownerName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    // Safe owner name with fallback
    final displayName = ownerName.isNotEmpty ? ownerName : l10n.parkingDashboardUserFallback;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.parkingDashboardWelcome(displayName),
          style: AppTextStyles.headlineMedium(context).copyWith(height: 1.2),
        ),
        SizedBox(height: 4.h),
        Text(
          l10n.parkingDashboardOverview,
          style: AppTextStyles.bodyMedium(
            context,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}

/// Primary KPI Card - Today's Revenue (Hero Section)
/// Layout Safety: Column uses mainAxisSize.min, Expanded properly constrained in Row
class _HeroKPICard extends StatelessWidget {
  final String todayRevenue;

  const _HeroKPICard({required this.todayRevenue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    // Format revenue with localized currency
    final displayRevenue = formatCurrency(todayRevenue, l10n);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20.r,
            offset: Offset(0, 8.h),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  EvaIcons.creditCard,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.parkingDashboardTodayRevenue,
                      style: AppTextStyles.bodyMedium(
                        context,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      displayRevenue,
                      style: AppTextStyles.displaySmall(
                        context,
                        color: Colors.white,
                      ).copyWith(height: 1.2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Live Occupancy Indicator with CircularPercentIndicator
/// Layout Safety: Column uses mainAxisSize.min, nested Column in center also uses mainAxisSize.min
class _OccupancyIndicator extends StatelessWidget {
  final OccupancyStats stats;

  const _OccupancyIndicator({required this.stats});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    // Safe percent calculation with validation
    final totalSpaces = stats.totalSpaces > 0 ? stats.totalSpaces : 1;
    
    // Use display values directly (backend computes from vacant_spaces)
    final displayOccupied = stats.displayOccupiedSpaces.clamp(0, totalSpaces);
    final displayAvailable = stats.displayAvailableSpaces;
    
    // Calculate percent safely
    final occupancyPercent = (displayOccupied / totalSpaces).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.parkingDashboardCurrentOccupancyRate,
            style: AppTextStyles.titleMedium(context),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular Percent Indicator - Safe with clamped values
              CircularPercentIndicator(
                radius: 80.r,
                lineWidth: 12.w,
                percent: occupancyPercent,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$displayOccupied',
                      style: AppTextStyles.headlineSmall(
                        context,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '/ $totalSpaces',
                      style: AppTextStyles.bodyMedium(
                        context,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                progressColor: AppColors.primary,
                backgroundColor: AppColors.backgroundSecondary,
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 1000,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            '$displayOccupied / $totalSpaces ${l10n.parkingDashboardOccupied}',
            style: AppTextStyles.bodyMedium(
              context,
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.event_available,
                  size: 16.sp,
                  color: AppColors.success,
                ),
                SizedBox(width: 6.w),
                Text(
                  '${l10n.parkingDashboardBookingAvailable}: $displayAvailable',
                  style: AppTextStyles.labelMedium(
                    context,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Summary Stats Grid (2x2)
/// Layout Safety: Column uses mainAxisSize.min, Rows properly constrained with Expanded
class _SummaryStatsGrid extends StatelessWidget {
  final DashboardData data;

  const _SummaryStatsGrid({required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    // Format revenue with localized currency
    final totalRevenue = formatCurrency(data.financialStats.formattedTotalRevenue, l10n);
    
    final totalBookings = data.bookingStats.totalBookings;
    final activeParkings = data.summary.activeParkings;
    final pendingCount = data.summary.pendingParkings + data.summary.rejectedParkings;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.parkingDashboardStatistics,
          style: AppTextStyles.titleLarge(context),
        ),
        SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: l10n.parkingDashboardTotalRevenue,
                  value: totalRevenue,
                  icon: EvaIcons.creditCard,
                  color: AppColors.success,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: DashboardCard(
                  title: l10n.parkingDashboardTotalBookings,
                  value: '$totalBookings',
                  icon: EvaIcons.calendar,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: l10n.parkingDashboardActiveParkings,
                  value: '$activeParkings',
                  icon: EvaIcons.checkmarkCircle2,
                  color: AppColors.success,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: DashboardCard(
                  title: l10n.parkingDashboardUnderReview,
                  value: '$pendingCount',
                  icon: EvaIcons.alertCircle,
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

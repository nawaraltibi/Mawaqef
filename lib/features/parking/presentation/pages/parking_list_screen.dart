import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/services/parking_list_refresh_notifier.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/parking_list/parking_list_bloc.dart';
import '../../core/enums/parking_filter.dart';
import '../../models/parking_model.dart';
import '../utils/parking_error_handler.dart';
import '../widgets/parking_empty_state.dart';
import '../widgets/parking_filter_chips.dart';
import '../widgets/parking_no_results_state.dart';
import '../widgets/parking_search_bar.dart';
import '../widgets/parking_status_badge.dart';

/// Parking List Screen
/// Modern parking list with search, filters, and interactive cards
class ParkingListScreen extends StatefulWidget {
  const ParkingListScreen({super.key});

  @override
  State<ParkingListScreen> createState() => _ParkingListScreenState();
}

class _ParkingListScreenState extends State<ParkingListScreen> {
  ParkingFilter _selectedFilter = ParkingFilter.all;
  String _searchQuery = '';

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onFilterChanged(ParkingFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load parkings when screen is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<ParkingListBloc>();
      if (bloc.state is! ParkingListLoaded) {
        bloc.add(const LoadOwnerParkings());
      }
    });

    // استماع لطلب التحديث (بعد إضافة/تحديث موقف) لاستدعاء الـ API وعرض آخر موقف
    getIt<ParkingListRefreshNotifier>().addListener(_onRefreshRequested);
  }

  void _onRefreshRequested() {
    if (!mounted) return;
    context.read<ParkingListBloc>().add(const RefreshParkings());
  }

  @override
  void dispose() {
    getIt<ParkingListRefreshNotifier>().removeListener(_onRefreshRequested);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Safe localization access
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ParkingListBloc, ParkingListState>(
        builder: (context, state) {
          // Loading state
          if (state is ParkingListLoading) {
            return const Center(child: LoadingWidget());
          }

          // Error state
          if (state is ParkingListError) {
            final errorMessage = ParkingErrorHandler.handleErrorState(
              state.message,
              state.statusCode ?? 500,
              l10n,
            );
            return ErrorStateWidget(
              message: errorMessage,
              onRetry: () {
                context.read<ParkingListBloc>().add(const LoadOwnerParkings());
              },
            );
          }

          // Empty state
          if (state is ParkingListLoaded && state.isEmpty) {
            return ParkingEmptyState(
              onCreateTap: () => context.push(Routes.parkingAddPath),
            );
          }

          // Loaded state
          if (state is! ParkingListLoaded) {
            return const Center(child: LoadingWidget());
          }

          // Update filter
          if (_selectedFilter != state.filter) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ParkingListBloc>().add(
                FilterParkings(_selectedFilter),
              );
            });
          }

          // Update search
          if (_searchQuery != (state.searchQuery ?? '')) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ParkingListBloc>().add(SearchParkings(_searchQuery));
            });
          }

          final filteredParkings = state.filteredParkings;

          return Stack(
            children: [
              Column(
                children: [
                  // Search Bar
                  ParkingSearchBar(onChanged: _onSearchChanged),
                  SizedBox(height: 12.h),

                  // Filter Chips
                  ParkingFilterChips(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: _onFilterChanged,
                  ),
                  SizedBox(height: 12.h),

                  // Parking List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<ParkingListBloc>().add(
                          const RefreshParkings(),
                        );
                      },
                      child: filteredParkings.isEmpty
                          ? const ParkingNoResultsState()
                          : ListView.builder(
                              padding: EdgeInsets.only(
                                left: 16.w,
                                right: 16.w,
                                bottom: 50
                                    .h, // Space for FAB (95.h) + bottom nav (58) + extra padding (27.h)
                              ),
                              itemCount: filteredParkings.length,
                              itemBuilder: (context, index) {
                                final parking = filteredParkings[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: ModernParkingCard(
                                    key: ValueKey(parking.lotId),
                                    parking: parking,
                                    onTap: () {
                                      context.push(
                                        Routes.parkingUpdatePath,
                                        extra: parking,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
              // Custom FloatingActionButton positioned with Stack
              _CustomFloatingActionButton(
                onPressed: () => context.push(Routes.parkingAddPath),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Modern Parking Card Widget
/// Redesigned parking card with occupancy indicator and modern UI
///
/// Layout Safety:
/// - Column uses mainAxisSize.min to prevent unbounded height
/// - All Rows have proper constraints
/// - No nested scrollables
class ModernParkingCard extends StatelessWidget {
  final ParkingModel parking;
  final VoidCallback onTap;

  const ModernParkingCard({
    super.key,
    required this.parking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    // Use backend-provided values (no frontend calculations)
    final totalSpaces = parking.totalSpaces > 0 ? parking.totalSpaces : 1;
    // Use camera-based vacant_spaces for display, fallback to booking-based
    final availableSpaces = parking.displayAvailableSpaces;
    // Use display occupied spaces (camera-based if available)
    final occupiedSpaces = parking.displayOccupiedSpaces;
    final occupancyPercent = (occupiedSpaces / totalSpaces).clamp(0.0, 1.0);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.r),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with name and status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        parking.lotName,
                        style: AppTextStyles.cardTitle(context),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ParkingStatusBadge(parking: parking),
                    SizedBox(width: 8.w),
                    PopupMenuButton(
                      icon: Icon(
                        EvaIcons.moreVertical,
                        color: AppColors.secondaryText,
                        size: 20.sp,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 8,
                      color: AppColors.brightWhite,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              color: AppColors.primary.withValues(alpha: 0.08),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  EvaIcons.edit,
                                  size: 18.sp,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  l10n.parkingUpdateTitle,
                                  style: AppTextStyles.labelLarge(
                                    context,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () =>
                              Future.delayed(Duration.zero, () => onTap()),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Occupancy Indicator with Available Spaces
                _buildOccupancyIndicator(
                  context,
                  occupancyPercent,
                  occupiedSpaces,
                  availableSpaces,
                  parking.totalSpaces,
                  l10n,
                ),
                SizedBox(height: 16.h),

                // Footer with location and price
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(
                        context,
                        icon: EvaIcons.pin,
                        text: parking.address,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildInfoRow(
                        context,
                        icon: EvaIcons.creditCard,
                        text:
                            '${parking.hourlyRate.toStringAsFixed(2)} ${l10n.parkingStatusActive == 'Active' ? 'SYP/hour' : '${l10n.currencySymbol}/ساعة'}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOccupancyIndicator(
    BuildContext context,
    double percent,
    int occupied,
    int available,
    int total,
    AppLocalizations l10n,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.parkingDashboardOccupancyRate,
              style: AppTextStyles.bodySmall(
                context,
                color: AppColors.secondaryText,
              ),
            ),
            Text(
              '${(percent * 100).toStringAsFixed(0)}%',
              style: AppTextStyles.labelSmall(
                context,
                color: AppColors.primaryText,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        LinearPercentIndicator(
          lineHeight: 8.h,
          percent: percent.clamp(0.0, 1.0),
          backgroundColor: AppColors.backgroundSecondary,
          progressColor: AppColors.primary,
          barRadius: Radius.circular(8.r),
          padding: EdgeInsets.zero,
        ),
        SizedBox(height: 8.h),
        // Display available spaces prominently
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  EvaIcons.checkmarkCircle2,
                  size: 16.sp,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6.w),
                Text(
                  '$available ${l10n.parkingStatusActive == 'Active' ? 'Available' : 'متاح'}',
                  style: AppTextStyles.labelMedium(
                    context,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            Text(
              '$occupied / $total ${l10n.parkingDashboardOccupiedSpaces}',
              style: AppTextStyles.bodySmall(
                context,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: AppColors.secondaryText),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall(
              context,
              color: AppColors.secondaryText,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Custom FloatingActionButton that responds to keyboard visibility
/// Uses Stack + Positioned instead of Scaffold.floatingActionButton
/// to allow dynamic positioning based on MediaQuery.viewInsets.bottom
class _CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CustomFloatingActionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      right: 15,
      child: Container(
        width: 56.0,
        height: 56.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: AppColors.buttonGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(28.0),
            child: Center(
              child: Icon(
                EvaIcons.plusCircle,
                color: AppColors.textOnPrimary,
                size: 28.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

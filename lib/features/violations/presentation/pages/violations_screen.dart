import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/violation_entity.dart';
import '../bloc/violations_bloc.dart';
import '../widgets/violation_card.dart';
import '../widgets/violations_empty_state.dart';
import '../widgets/violations_error_state.dart';
import '../widgets/pay_violation_dialog.dart';

/// Violations Screen
/// Displays violations with TabBar for Unpaid/Paid
class ViolationsScreen extends StatefulWidget {
  const ViolationsScreen({super.key});

  @override
  State<ViolationsScreen> createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ViolationEntity>? _cachedUnpaidViolations;
  List<ViolationEntity>? _cachedPaidViolations;
  bool _cachedUnpaidEmpty = false;
  bool _cachedPaidEmpty = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Load initial data
    context.read<ViolationsBloc>().add(GetUnpaidViolationsRequested());
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      final bloc = context.read<ViolationsBloc>();
      if (_tabController.index == 0) {
        // Unpaid tab - always reload to ensure fresh data
        bloc.add(GetUnpaidViolationsRequested());
      } else {
        // Paid tab - always reload to ensure fresh data
        bloc.add(GetPaidViolationsRequested());
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
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
          l10n.violationsTitle,
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
        child: Column(
          children: [
            // Tab Bar
            Container(
              margin: EdgeInsetsDirectional.only(
                start: 16.w,
                end: 16.w,
                top: 8.h,
                bottom: 8.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.textOnPrimary,
                unselectedLabelColor: AppColors.secondaryText,
                labelStyle: AppTextStyles.labelLarge(context),
                unselectedLabelStyle: AppTextStyles.labelMedium(context),
                tabs: [
                  Tab(text: l10n.violationsTabUnpaid),
                  Tab(text: l10n.violationsTabPaid),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: BlocListener<ViolationsBloc, ViolationsState>(
                listener: (context, state) {
                  if (state is ViolationActionSuccess) {
                    // Refresh unpaid violations after payment
                    if (_tabController.index == 0) {
                      context.read<ViolationsBloc>().add(
                        GetUnpaidViolationsRequested(),
                      );
                    }
                  }
                  // Update cache after state changes
                  if (state is UnpaidViolationsLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _cachedUnpaidViolations = state.violations;
                          _cachedUnpaidEmpty = state.violations.isEmpty;
                        });
                      }
                    });
                  } else if (state is ViolationsEmpty &&
                      _tabController.index == 0) {
                    // Update cache when empty state is emitted for unpaid tab
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _cachedUnpaidViolations = [];
                          _cachedUnpaidEmpty = true;
                        });
                      }
                    });
                  } else if (state is PaidViolationsLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _cachedPaidViolations = state.violations;
                          _cachedPaidEmpty = state.violations.isEmpty;
                        });
                      }
                    });
                  }
                },
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _UnpaidViolationsTab(
                      cachedViolations: _cachedUnpaidViolations,
                      cachedEmpty: _cachedUnpaidEmpty,
                    ),
                    _PaidViolationsTab(
                      cachedViolations: _cachedPaidViolations,
                      cachedEmpty: _cachedPaidEmpty,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnpaidViolationsTab extends StatelessWidget {
  final List<ViolationEntity>? cachedViolations;
  final bool cachedEmpty;

  const _UnpaidViolationsTab({
    required this.cachedViolations,
    required this.cachedEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationsBloc, ViolationsState>(
      builder: (context, state) {
        Widget child;

        if (state is UnpaidViolationsLoaded) {
          // Show list or empty state based on violations count
          if (state.violations.isEmpty) {
            child = const ViolationsEmptyState(isPaidTab: false);
          } else {
            child = _ViolationsList(
              violations: state.violations,
              isPaidTab: false,
              onRefresh: () async {
                context.read<ViolationsBloc>().add(
                  GetUnpaidViolationsRequested(),
                );
              },
            );
          }
        } else if (state is ViolationsEmpty) {
          // Always show empty state when ViolationsEmpty is emitted
          child = const ViolationsEmptyState(isPaidTab: false);
        } else if (state is ViolationsError) {
          child = ViolationsErrorState(
            error: state.error,
            onRetry: () => context.read<ViolationsBloc>().add(
              GetUnpaidViolationsRequested(),
            ),
          );
        } else if (state is ViolationsLoading || state is ViolationsInitial) {
          child = const _ViolationsSkeleton();
        } else if (state is ViolationActionLoading) {
          // Show loading while action is in progress
          if (cachedViolations != null && cachedViolations!.isNotEmpty) {
            child = _ViolationsList(
              violations: cachedViolations!,
              isPaidTab: false,
              onRefresh: () async {
                context.read<ViolationsBloc>().add(
                  GetUnpaidViolationsRequested(),
                );
              },
            );
          } else if (cachedEmpty ||
              (cachedViolations != null && cachedViolations!.isEmpty)) {
            child = const ViolationsEmptyState(isPaidTab: false);
          } else {
            child = const _ViolationsSkeleton();
          }
        } else if (state is ViolationActionSuccess ||
            state is ViolationActionFailure) {
          // After action, wait for reload - show skeleton briefly
          // The reload will trigger UnpaidViolationsLoaded state
          child = const _ViolationsSkeleton();
        } else {
          child = const _ViolationsSkeleton();
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: child,
        );
      },
    );
  }
}

class _PaidViolationsTab extends StatelessWidget {
  final List<ViolationEntity>? cachedViolations;
  final bool cachedEmpty;

  const _PaidViolationsTab({
    required this.cachedViolations,
    required this.cachedEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationsBloc, ViolationsState>(
      builder: (context, state) {
        Widget child;

        if (state is PaidViolationsLoaded) {
          child = _ViolationsList(
            violations: state.violations,
            isPaidTab: true,
            onRefresh: () async {
              context.read<ViolationsBloc>().add(GetPaidViolationsRequested());
            },
          );
        } else if (state is ViolationsEmpty && cachedEmpty) {
          child = const ViolationsEmptyState(isPaidTab: true);
        } else if (state is ViolationsError) {
          child = ViolationsErrorState(
            error: state.error,
            onRetry: () => context.read<ViolationsBloc>().add(
              GetPaidViolationsRequested(),
            ),
          );
        } else if (state is ViolationsLoading || state is ViolationsInitial) {
          child = const _ViolationsSkeleton();
        } else if (cachedViolations != null && cachedViolations!.isNotEmpty) {
          child = _ViolationsList(
            violations: cachedViolations!,
            isPaidTab: true,
            onRefresh: () async {
              context.read<ViolationsBloc>().add(GetPaidViolationsRequested());
            },
          );
        } else if (cachedEmpty) {
          child = const ViolationsEmptyState(isPaidTab: true);
        } else {
          child = const _ViolationsSkeleton();
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: child,
        );
      },
    );
  }
}

class _ViolationsList extends StatelessWidget {
  final List<ViolationEntity> violations;
  final bool isPaidTab;
  final Future<void> Function() onRefresh;

  const _ViolationsList({
    required this.violations,
    required this.isPaidTab,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (violations.isEmpty) {
      return ViolationsEmptyState(isPaidTab: isPaidTab);
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.only(
          start: 16.w,
          end: 16.w,
          bottom: 16.h,
          top: 12.h,
        ),
        itemCount: violations.length,
        itemBuilder: (context, index) {
          final violation = violations[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ViolationCard(
              key: ValueKey(violation.violationId),
              violation: violation,
              showPayButton: !isPaidTab,
              onPayTap: isPaidTab
                  ? null
                  : () {
                      PayViolationDialog.show(context, violation);
                    },
            ),
          );
        },
      ),
    );
  }
}

class _ViolationsSkeleton extends StatelessWidget {
  const _ViolationsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        const Center(child: LoadingWidget()),
        SizedBox(height: 16.h),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _ViolationCardSkeleton(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ViolationCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
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
        child: Padding(
          padding: EdgeInsetsDirectional.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonLine(widthFactor: 0.65),
              SizedBox(height: 12.h),
              _SkeletonLine(widthFactor: 0.9),
              SizedBox(height: 8.h),
              _SkeletonLine(widthFactor: 0.55),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double widthFactor;

  const _SkeletonLine({required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 12.h,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}

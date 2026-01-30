import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/violation_entity.dart';

/// Violation Card Widget
/// Displays violation information in a modern card design
class ViolationCard extends StatelessWidget {
  final ViolationEntity violation;
  final VoidCallback? onPayTap;
  final bool showPayButton;

  const ViolationCard({
    super.key,
    required this.violation,
    this.onPayTap,
    this.showPayButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final isPaid = violation.isPaid;
    final statusColor = isPaid ? AppColors.success : AppColors.error;
    final statusIcon = isPaid
        ? EvaIcons.checkmarkCircle2
        : EvaIcons.alertCircle;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      shadowColor: Colors.black.withValues(alpha: 0.08),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: statusColor.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Column(
            children: [
              // Status bar with gradient
              Container(
                height: 6.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [statusColor, statusColor.withValues(alpha: 0.7)],
                  ),
                ),
              ),
              // Main content
              Padding(
                padding: EdgeInsetsDirectional.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Status and Amount
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Status badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 16.sp, color: statusColor),
                              SizedBox(width: 6.w),
                              Text(
                                isPaid
                                    ? l10n.violationsStatusPaid
                                    : l10n.violationsStatusUnpaid,
                                style: AppTextStyles.labelMedium(
                                  context,
                                  color: statusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Amount
                        Text(
                          violation.amount.toStringAsFixed(2),
                          style: AppTextStyles.titleLarge(
                            context,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    // Violation Type
                    Row(
                      children: [
                        Icon(
                          EvaIcons.fileTextOutline,
                          size: 18.sp,
                          color: AppColors.secondaryText,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            violation.violationType,
                            style: AppTextStyles.titleMedium(context),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (violation.description != null &&
                        violation.description!.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Text(
                        violation.description!,
                        style: AppTextStyles.bodySmall(
                          context,
                          color: AppColors.secondaryText,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    SizedBox(height: 16.h),
                    // Divider
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: 16.h),
                    // Vehicle Info
                    if (violation.vehicle != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 16.sp,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              '${violation.vehicle!.carMake} ${violation.vehicle!.carModel}',
                              style: AppTextStyles.bodyMedium(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          SizedBox(width: 24.w), // Align with icon above
                          Icon(
                            Icons.credit_card,
                            size: 14.sp,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            violation.vehicle!.platNumber,
                            style: AppTextStyles.bodySmall(
                              context,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                    ],
                    // Parking Lot Info
                    if (violation.parkingLot != null &&
                        violation.parkingLot!.address != null) ...[
                      Row(
                        children: [
                          Icon(
                            EvaIcons.mapOutline,
                            size: 16.sp,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              violation.parkingLot!.address!,
                              style: AppTextStyles.bodyMedium(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                    ],
                    // Date Info
                    Row(
                      children: [
                        Icon(
                          EvaIcons.calendarOutline,
                          size: 16.sp,
                          color: AppColors.secondaryText,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (violation.violationDate != null)
                                Text(
                                  '${l10n.violationsViolationDate}: ${_formatDate(context, violation.violationDate!)}',
                                  style: AppTextStyles.bodySmall(
                                    context,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              if (violation.paidDate != null) ...[
                                SizedBox(height: 4.h),
                                Text(
                                  '${l10n.violationsPaidDate}: ${_formatDate(context, violation.paidDate!)}',
                                  style: AppTextStyles.bodySmall(
                                    context,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Pay Button (only for unpaid violations)
                    if (!isPaid && showPayButton && onPayTap != null) ...[
                      SizedBox(height: 20.h),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.primary.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onPayTap,
                            borderRadius: BorderRadius.circular(16.r),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.textOnPrimary.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      EvaIcons.creditCard,
                                      size: 20.sp,
                                      color: AppColors.textOnPrimary,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        l10n.violationsPayButton,
                                        style: AppTextStyles.labelLarge(
                                          context,
                                          color: AppColors.textOnPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        '${violation.amount.toStringAsFixed(2)} ${l10n.currencySymbol}',
                                        style: AppTextStyles.bodySmall(
                                          context,
                                          color: AppColors.textOnPrimary
                                              .withValues(alpha: 0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    EvaIcons.arrowForward,
                                    size: 18.sp,
                                    color: AppColors.textOnPrimary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(BuildContext context, String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final locale = Localizations.localeOf(context);
      return DateFormat.yMd(locale.toString()).format(date);
    } catch (e) {
      return dateString;
    }
  }
}

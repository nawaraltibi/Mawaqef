import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/booking_model.dart';
import '../../models/remaining_time_response.dart';
import '../../../vehicles/presentation/utils/vehicle_translations.dart';

/// Active Booking Card Widget
/// Displays an active booking with remaining time, floating card design
class ActiveBookingCard extends StatelessWidget {
  final BookingModel booking;
  final RemainingTimeResponse? remainingTime;

  const ActiveBookingCard({
    super.key,
    required this.booking,
    this.remainingTime,
  });

  /// Calculate progress (0.0 to 1.0) based on remaining time
  double _calculateProgress() {
    if (remainingTime == null || remainingTime!.remainingSeconds == null) {
      return 0.0;
    }

    final remainingSeconds = remainingTime!.remainingSeconds!;
    if (remainingSeconds <= 0) return 0.0;

    try {
      final startTime = DateTime.parse(booking.startTime);
      final endTime = DateTime.parse(booking.endTime);
      final totalDuration = endTime.difference(startTime).inSeconds;
      
      if (totalDuration <= 0) return 0.0;
      
      final progress = remainingSeconds / totalDuration;
      return progress.clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      if (kDebugMode) {
        print('🔴 [ActiveBookingCard] l10n is null');
      }
      return const SizedBox.shrink();
    }

    final vehicle = booking.vehicle;
    final parkingLot = booking.parkingLot;
    final progress = _calculateProgress();

    if (kDebugMode) {
      print('🔵 [ActiveBookingCard] Building card for booking ${booking.bookingId}');
      print('🔵 [ActiveBookingCard] Vehicle: ${vehicle?.platNumber ?? 'null'}');
      print('🔵 [ActiveBookingCard] Remaining time: ${remainingTime?.remainingSeconds ?? 'null'}');
    }

    return Container(
      width: 240.w,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(
              Routes.bookingDetailsPath,
              extra: {'bookingId': booking.bookingId},
            );
          },
          borderRadius: BorderRadius.circular(14.r),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Remaining time with progress bar
                if (remainingTime != null && remainingTime!.remainingSeconds != null) ...[
                  // Remaining time text and parking icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Parking icon
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.local_parking,
                          color: AppColors.primary,
                          size: 16.sp,
                        ),
                      ),
                      // Remaining time text
                      Expanded(
                        child: Text(
                          _formatRemainingTime(remainingTime!, l10n),
                          textAlign: TextAlign.end,
                          style: AppTextStyles.bodyLarge(
                            context,
                            color: AppColors.primary,
                          ).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 3.h,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress > 0.2
                            ? AppColors.primary
                            : AppColors.warning,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],
                // Vehicle info
                Row(
                  children: [
                    // Vehicle icon
                    Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.directions_car,
                        color: AppColors.primary,
                        size: 18.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Vehicle details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plate number
                          if (vehicle != null)
                            Text(
                              vehicle.platNumber,
                              style: AppTextStyles.bodyMedium(
                                context,
                                color: AppColors.primaryText,
                              ).copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                          SizedBox(height: 1.h),
                          // Car make and model
                          if (vehicle != null &&
                              (vehicle.carMake != null || vehicle.carModel != null))
                            Text(
                              _getVehicleType(vehicle, context),
                              style: AppTextStyles.bodySmall(
                                context,
                                color: AppColors.secondaryText,
                              ).copyWith(
                                fontSize: 11.sp,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Expiration time
                if (booking.endTime.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12.sp,
                        color: AppColors.secondaryText,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${l10n.expiresAt} ${_formatEndTime(booking.endTime)}',
                          style: AppTextStyles.bodySmall(
                            context,
                            color: AppColors.secondaryText,
                          ).copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                // Parking lot address and ticket number
                if (parkingLot != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    '${parkingLot.address ?? ''} - ${l10n.ticketNumber} ${booking.bookingId}',
                    style: AppTextStyles.bodySmall(
                      context,
                      color: AppColors.secondaryText,
                    ).copyWith(
                      fontSize: 10.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getVehicleType(VehicleInfo vehicle, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final parts = <String>[];
    if (vehicle.carMake != null && vehicle.carMake!.isNotEmpty) {
      final carMakeTranslated = VehicleTranslations.getCarMakeTranslation(
        vehicle.carMake!,
        l10n,
      );
      parts.add(carMakeTranslated);
    }
    if (vehicle.carModel != null && vehicle.carModel!.isNotEmpty) {
      parts.add(vehicle.carModel!);
    }
    return parts.join(' ');
  }

  String _formatRemainingTime(RemainingTimeResponse remainingTime, AppLocalizations l10n) {
    final seconds = remainingTime.remainingSeconds ?? 0;
    if (seconds <= 0) {
      return l10n.expired;
    }

    final minutes = (seconds / 60).round();

    return '$minutes ${l10n.minutes} ${l10n.remaining}';
  }

  String _formatEndTime(String endTimeString) {
    try {
      final endTime = DateTime.parse(endTimeString);
      final formatter = DateFormat('hh:mm a', 'ar');
      return formatter.format(endTime);
    } catch (e) {
      return endTimeString;
    }
  }
}


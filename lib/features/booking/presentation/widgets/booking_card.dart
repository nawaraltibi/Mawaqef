import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/booking_model.dart';
import 'shared/shared_widgets.dart';

/// Booking Card Widget
/// Displays a single booking in the list with enhanced design
class BookingCard extends StatelessWidget {
  final BookingModel booking;

  const BookingCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final parkingLot = booking.parkingLot;
    final vehicle = booking.vehicle;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          // Soft primary-colored shadow
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          // Standard soft shadow for depth
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to booking details
            context.push(
              Routes.bookingDetailsPath,
              extra: {'bookingId': booking.bookingId},
            );
          },
          borderRadius: BorderRadius.circular(16.r),
          splashColor: AppColors.primary.withValues(alpha: 0.06),
          highlightColor: AppColors.primary.withValues(alpha: 0.03),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Parking lot image placeholder with enhanced design
                Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.15),
                        AppColors.primary.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.local_parking,
                    color: AppColors.primary,
                    size: 44.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                // Booking details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Parking lot name
                      if (parkingLot != null)
                        Text(
                          parkingLot.lotName,
                          style: AppTextStyles.titleMedium(
                            context,
                            color: AppColors.primaryText,
                          ).copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      SizedBox(height: 6.h),
                      // Address
                      if (parkingLot?.address != null)
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 14.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                parkingLot!.address!,
                                style: AppTextStyles.bodySmall(
                                  context,
                                  color: AppColors.secondaryText,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 8.h),
                      // Date
                      IconWithText(
                        icon: Icons.calendar_today,
                        text: DateTimeFormatter.formatDate(booking.startTime, context),
                        iconSize: 14.sp,
                        spacing: 4.w,
                      ),
                      SizedBox(height: 8.h),
                      // Vehicle info with enhanced design
                      if (vehicle != null)
                        VehicleDisplayWidget(
                          vehicle: vehicle,
                          compact: true,
                        ),
                      SizedBox(height: 10.h),
                      // Amount with enhanced design
                      PriceDisplayWidget(
                        amount: booking.totalAmount,
                        label: l10n.amount,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

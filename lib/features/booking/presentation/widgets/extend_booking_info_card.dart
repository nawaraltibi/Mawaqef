import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/booking_model.dart';
import 'shared/shared_widgets.dart';

/// Extend Booking Info Card Widget
/// Displays current booking information
class ExtendBookingInfoCard extends StatelessWidget {
  final BookingModel booking;

  const ExtendBookingInfoCard({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    final parkingLot = booking.parkingLot;
    final vehicle = booking.vehicle;

    return InfoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              l10n.currentBooking,
              style: AppTextStyles.titleMedium(
                context,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 16.h),

            // Parking Lot Name
            if (parkingLot != null) ...[
              IconWithText(
                icon: Icons.location_on,
                text: parkingLot.lotName,
                iconColor: AppColors.primary,
                iconSize: 20.sp,
                spacing: 8.w,
                textStyle: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.primaryText,
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(left: 28.w),
                child: Text(
                  parkingLot.address ?? '',
                  style: AppTextStyles.bodySmall(
                    context,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Vehicle Info
            if (vehicle != null) ...[
              VehicleDisplayWidget(
                vehicle: booking.vehicle,
                compact: false,
                showIcon: true,
                showMakeModel: true,
                showPlateNumber: true,
              ),
            ],
          ],
        ),
    );
  }
}


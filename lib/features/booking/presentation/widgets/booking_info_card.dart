import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/booking_model.dart';
import 'shared/shared_widgets.dart';

/// Booking Info Card Widget
/// Displays parking location and booking ID
class BookingInfoCard extends StatelessWidget {
  final BookingModel booking;

  const BookingInfoCard({
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
    final parkingName = parkingLot?.lotName ?? '';
    final parkingAddress = parkingLot?.address ?? '';

    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parking Name
          Text(
            parkingName,
            style: AppTextStyles.titleLarge(
              context,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 12.h),
          
          // Location with icon
          IconWithText(
            icon: EvaIcons.pin,
            text: parkingAddress,
            expandText: true,
            textStyle: AppTextStyles.bodyMedium(
              context,
              color: AppColors.secondaryText,
            ),
          ),
          SizedBox(height: 20.h),
          
          // Divider
          Divider(
            color: AppColors.border,
            height: 1,
          ),
          SizedBox(height: 16.h),
          
          // Booking ID / Ticket Number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.bookingId,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.secondaryText,
                ),
              ),
              Text(
                booking.bookingId.toString(),
                style: AppTextStyles.titleMedium(
                  context,
                  color: AppColors.primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


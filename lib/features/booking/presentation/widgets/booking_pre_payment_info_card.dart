import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../parking/models/parking_model.dart';
import 'shared/shared_widgets.dart';

/// Booking Pre-Payment Info Card Widget
/// Displays parking location, availability, and status
class BookingPrePaymentInfoCard extends StatelessWidget {
  final ParkingModel parking;

  const BookingPrePaymentInfoCard({
    super.key,
    required this.parking,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    final availableSpaces = parking.availableSpaces ?? parking.totalSpaces;
    final totalSpaces = parking.totalSpaces;

    return InfoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parking Name
            Text(
              parking.lotName,
              style: AppTextStyles.titleLarge(
                context,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 8.h),
            
            // Location
            IconWithText(
              icon: EvaIcons.pin,
              text: parking.address,
              expandText: true,
              iconSize: 16.sp,
              spacing: 6.w,
              textStyle: AppTextStyles.bodyMedium(
                context,
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 16.h),
            
            // Availability Info
            Row(
              children: [
                // Available Spaces
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.local_parking,
                          size: 24.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$availableSpaces / $totalSpaces',
                              style: AppTextStyles.titleMedium(
                                context,
                                color: AppColors.primaryText,
                              ),
                            ),
                            Text(
                              l10n.bookingPrePaymentTotalAvailable,
                              style: AppTextStyles.bodySmall(
                                context,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(width: 12.w),
                
                // Status Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    l10n.available,
                    style: AppTextStyles.labelSmall(
                      context,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}


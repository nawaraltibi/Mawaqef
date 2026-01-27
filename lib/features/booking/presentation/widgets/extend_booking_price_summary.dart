import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import 'shared/shared_widgets.dart';

/// Extend Booking Price Summary Widget
/// Displays price breakdown for booking extension
class ExtendBookingPriceSummary extends StatelessWidget {
  final int selectedHours;
  final double hourlyRate;
  final double totalPrice;

  const ExtendBookingPriceSummary({
    super.key,
    required this.selectedHours,
    required this.hourlyRate,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return InfoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              l10n.extensionPrice,
              style: AppTextStyles.titleMedium(
                context,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 16.h),

            // Hourly Rate
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${l10n.hourlyRate} × $selectedHours ${selectedHours == 1 ? l10n.hour : l10n.hours}',
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.secondaryText,
                  ),
                ),
                PriceDisplayWidget(
                  amount: hourlyRate,
                  showCurrencySymbol: true,
                  amountStyle: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.primaryText,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Divider
            Divider(
              color: AppColors.border,
              height: 1,
            ),
            SizedBox(height: 12.h),

            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.totalAmount,
                  style: AppTextStyles.titleMedium(
                    context,
                    color: AppColors.primaryText,
                  ),
                ),
                PriceDisplayWidget(
                  amount: totalPrice,
                  showCurrencySymbol: true,
                  amountStyle: AppTextStyles.titleLarge(
                    context,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
    );
  }
}


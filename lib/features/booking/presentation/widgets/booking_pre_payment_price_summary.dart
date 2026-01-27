import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import 'shared/shared_widgets.dart';

/// Booking Pre-Payment Price Summary Widget
/// Displays total price with VAT information
class BookingPrePaymentPriceSummary extends StatelessWidget {
  final double hourlyRate;
  final int hours;
  final double totalPrice;

  const BookingPrePaymentPriceSummary({
    super.key,
    required this.hourlyRate,
    required this.hours,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Amount Label
        Text(
          l10n.bookingPrePaymentAmountValue,
          style: AppTextStyles.bodyMedium(
            context,
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: 6.h),
        
        // Total Price
        PriceDisplayWidget(
          amount: totalPrice,
          showCurrencySymbol: true,
          amountStyle: AppTextStyles.titleLarge(
            context,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 2.h),
        
        // VAT Note
        Text(
          l10n.bookingPrePaymentVatIncluded,
          style: AppTextStyles.bodySmall(
            context,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }
}


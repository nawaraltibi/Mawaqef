import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';
import '../../models/booking_model.dart';
import 'shared/shared_widgets.dart';

/// Payment Summary Card Widget
/// Displays hourly rate and total amount paid
class PaymentSummaryCard extends StatelessWidget {
  final BookingModel booking;

  const PaymentSummaryCard({
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
    final hourlyRate = parkingLot?.hourlyRate ?? 0.0;
    final totalAmount = booking.totalAmount;

    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            l10n.totalAmount,
            style: AppTextStyles.titleMedium(
              context,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Hourly Rate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  l10n.hourlyRate,
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
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
          
          // Total Amount (including tax)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.totalAmount,
                      style: AppTextStyles.titleMedium(
                        context,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      l10n.bookingPrePaymentVatIncluded,
                      style: AppTextStyles.bodySmall(
                        context,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              PriceDisplayWidget(
                amount: totalAmount,
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


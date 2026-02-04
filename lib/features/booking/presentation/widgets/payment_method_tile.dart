import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../l10n/app_localizations.dart';

/// Payment Method Tile Widget
/// Displays a payment method option with radio button
class PaymentMethodTile extends StatelessWidget {
  final String paymentMethod; // 'cash', 'credit', 'online', 'sham_cash'
  final bool isSelected;
  final VoidCallback onTap;
  final String? cardNumber; // For credit card (last 4 digits)
  final String? expiryDate; // For credit card

  const PaymentMethodTile({
    super.key,
    required this.paymentMethod,
    required this.isSelected,
    required this.onTap,
    this.cardNumber,
    this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio Button
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : AppColors.surface,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16.sp,
                      color: AppColors.textOnPrimary,
                    )
                  : null,
            ),
            SizedBox(width: 16.w),

            // Payment Method Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Method Name
                  Text(
                    _getPaymentMethodName(l10n),
                    style: AppTextStyles.titleMedium(
                      context,
                      color: AppColors.primaryText,
                    ),
                  ),

                  // Additional Info (for credit card)
                  if (paymentMethod == 'credit' && cardNumber != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      '${l10n.paymentCardEnding} $cardNumber',
                      style: AppTextStyles.bodySmall(
                        context,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    if (expiryDate != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        '${l10n.paymentExpiryDate} $expiryDate',
                        style: AppTextStyles.bodySmall(
                          context,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ],
                  ],

                  // Add Card Info (for add new card option)
                  if (paymentMethod == 'add_card') ...[
                    SizedBox(height: 4.h),
                    Text(
                      l10n.paymentAcceptCards,
                      style: AppTextStyles.bodySmall(
                        context,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Payment Method Icons/Logos
            _buildPaymentLogos(),
          ],
        ),
      ),
    );
  }

  String _getPaymentMethodName(AppLocalizations l10n) {
    switch (paymentMethod) {
      case 'cash':
        return l10n.paymentMethodCash;
      case 'credit':
        return l10n.paymentMethodCredit;
      case 'online':
        return l10n.paymentMethodOnline;
      case 'sham_cash':
        return l10n.paymentMethodShamCash;
      case 'add_card':
        return l10n.paymentAddCard;
      default:
        return paymentMethod;
    }
  }

  Widget _buildPaymentLogos() {
    if (paymentMethod == 'cash') {
      // Show payments icon for cash payment
      return Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(Icons.payments, size: 32.sp, color: AppColors.success),
      );
    } else if (paymentMethod == 'online') {
      // دفع إلكتروني: شعار PayPal
      return Container(
        constraints: BoxConstraints(maxWidth: 50.w, maxHeight: 36.h),
        child: Image.asset(
          'assets/images/paypal.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  'PayPal',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else if (paymentMethod == 'sham_cash') {
      // شام كاش: لوغو sham_cash فقط
      return Container(
        constraints: BoxConstraints(maxWidth: 50.w, maxHeight: 36.h),
        child: Image.asset(
          'assets/images/sham_cash.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 50.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  'Sham Cash',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else if (paymentMethod == 'credit' || paymentMethod == 'add_card') {
      // Show Visa and Mastercard logos for credit card
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 50.w, maxHeight: 32.h),
            child: Image.asset(
              'assets/images/visa.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Center(
                    child: Text(
                      'VISA',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            constraints: BoxConstraints(maxWidth: 50.w, maxHeight: 32.h),
            child: Image.asset(
              'assets/images/master_card.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Center(
                    child: Text(
                      'MC',
                      style: TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

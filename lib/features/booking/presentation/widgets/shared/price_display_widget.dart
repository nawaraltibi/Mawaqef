import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/core.dart';
import '../../../../../l10n/app_localizations.dart';

/// Price Display Widget
/// Reusable component for displaying prices with currency
class PriceDisplayWidget extends StatelessWidget {
  final double amount;
  final String? label;
  final TextStyle? amountStyle;
  final TextStyle? labelStyle;
  final bool showCurrencySymbol;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const PriceDisplayWidget({
    super.key,
    required this.amount,
    this.label,
    this.amountStyle,
    this.labelStyle,
    this.showCurrencySymbol = true,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final formattedAmount = amount.toStringAsFixed(2);
    final currencySymbol = showCurrencySymbol ? l10n.currencySymbol : '';

    if (label != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label!,
            style: labelStyle ??
                AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.secondaryText,
                ),
          ),
          if (backgroundColor != null || padding != null)
            Container(
              padding: padding ??
                  EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(
                  borderRadius ?? 8.r,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showCurrencySymbol) ...[
                    Text(
                      currencySymbol,
                      style: amountStyle ??
                          AppTextStyles.titleMedium(
                            context,
                            color: AppColors.primary,
                          ).copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Text(
                    formattedAmount,
                    style: amountStyle ??
                        AppTextStyles.titleMedium(
                          context,
                          color: AppColors.primary,
                        ).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCurrencySymbol) ...[
                  Text(
                    currencySymbol,
                    style: amountStyle ??
                        AppTextStyles.titleMedium(
                          context,
                          color: AppColors.primary,
                        ),
                  ),
                  SizedBox(width: 4.w),
                ],
                Text(
                  formattedAmount,
                  style: amountStyle ??
                      AppTextStyles.titleMedium(
                        context,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
        ],
      );
    }

    // Just amount without label
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showCurrencySymbol) ...[
          Text(
            currencySymbol,
            style: amountStyle ??
                AppTextStyles.titleMedium(
                  context,
                  color: AppColors.primary,
                ),
          ),
          SizedBox(width: 4.w),
        ],
        Text(
          formattedAmount,
          style: amountStyle ??
              AppTextStyles.titleMedium(
                context,
                color: AppColors.primary,
              ),
        ),
      ],
    );
  }
}


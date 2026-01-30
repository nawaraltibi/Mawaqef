import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../booking/presentation/widgets/payment_method_tile.dart';
import '../../domain/entities/violation_entity.dart';
import '../bloc/violations_bloc.dart';

/// Pay Violation Dialog
/// Dialog for paying a violation
class PayViolationDialog extends StatefulWidget {
  final ViolationEntity violation;

  const PayViolationDialog({super.key, required this.violation});

  static Future<void> show(
    BuildContext context,
    ViolationEntity violation,
  ) async {
    // Get the bloc from parent context
    final bloc = context.read<ViolationsBloc>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: bloc,
        child: PayViolationDialog(violation: violation),
      ),
    );
  }

  @override
  State<PayViolationDialog> createState() => _PayViolationDialogState();
}

class _PayViolationDialogState extends State<PayViolationDialog> {
  /// API allowed: cash | credit | online. Default cash.
  String _selectedPaymentMethod = 'cash';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return BlocListener<ViolationsBloc, ViolationsState>(
      listener: (context, state) {
        if (state is ViolationActionSuccess) {
          Navigator.of(context).pop();
          UnifiedSnackbar.success(
            context,
            message: l10n.violationsPaySuccess,
          );
        } else if (state is ViolationActionFailure) {
          UnifiedSnackbar.error(context, message: state.error);
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Container(
          padding: EdgeInsetsDirectional.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.violationsPayDialogTitle,
                    style: AppTextStyles.titleLarge(context),
                  ),
                  IconButton(
                    icon: Icon(
                      EvaIcons.close,
                      size: 24.sp,
                      color: AppColors.secondaryText,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Violation Info
              Container(
                padding: EdgeInsetsDirectional.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.violation.violationType,
                      style: AppTextStyles.titleMedium(context),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${l10n.violationsAmount}:',
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        Text(
                          '${widget.violation.amount.toStringAsFixed(2)} ${l10n.currencySymbol}',
                          style: AppTextStyles.titleMedium(
                            context,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              // Payment Method Selection (API: cash, credit, online)
              Text(
                l10n.violationsPaymentMethod,
                style: AppTextStyles.labelLarge(context),
              ),
              SizedBox(height: 12.h),
              PaymentMethodTile(
                paymentMethod: 'cash',
                isSelected: _selectedPaymentMethod == 'cash',
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'cash');
                },
              ),
              SizedBox(height: 12.h),
              PaymentMethodTile(
                paymentMethod: 'credit',
                isSelected: _selectedPaymentMethod == 'credit',
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'credit');
                },
              ),
              SizedBox(height: 12.h),
              PaymentMethodTile(
                paymentMethod: 'online',
                isSelected: _selectedPaymentMethod == 'online',
                onTap: () {
                  setState(() => _selectedPaymentMethod = 'online');
                },
              ),
              SizedBox(height: 24.h),
              // Pay Button
              BlocBuilder<ViolationsBloc, ViolationsState>(
                builder: (context, state) {
                  final isLoading = state is ViolationActionLoading;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.85),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isLoading
                            ? null
                            : () {
                                context.read<ViolationsBloc>().add(
                                  PayViolationRequested(
                                    violationId: widget.violation.violationId,
                                    paymentMethod:
                                        _selectedPaymentMethod, // cash | credit | online
                                  ),
                                );
                              },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: isLoading
                              ? Center(
                                  child: SizedBox(
                                    height: 24.h,
                                    width: 24.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.textOnPrimary,
                                      ),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.textOnPrimary
                                            .withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Icon(
                                        EvaIcons.checkmarkCircle,
                                        size: 22.sp,
                                        color: AppColors.textOnPrimary,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          l10n.violationsPayButton,
                                          style: AppTextStyles.titleMedium(
                                            context,
                                            color: AppColors.textOnPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          '${widget.violation.amount.toStringAsFixed(2)} ${l10n.currencySymbol}',
                                          style: AppTextStyles.bodySmall(
                                            context,
                                            color: AppColors.textOnPrimary
                                                .withValues(alpha: 0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 12.w),
                                    Icon(
                                      EvaIcons.arrowForward,
                                      size: 20.sp,
                                      color: AppColors.textOnPrimary,
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

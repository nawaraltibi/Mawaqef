import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../l10n/app_localizations.dart';

/// Violations Error State
class ViolationsErrorState extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;

  const ViolationsErrorState({
    super.key,
    required this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              EvaIcons.alertCircleOutline,
              size: 64.sp,
              color: AppColors.error,
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.violationsErrorTitle,
              style: AppTextStyles.titleMedium(
                context,
                color: AppColors.error,
              ),
              softWrap: true,
            ),
            SizedBox(height: 8.h),
            Text(
              error,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              CustomElevatedButton(
                title: l10n.violationsRetryButton,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}


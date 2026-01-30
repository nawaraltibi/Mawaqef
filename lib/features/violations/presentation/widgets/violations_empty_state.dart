import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// Violations Empty State
/// Modern empty state with icon and message
class ViolationsEmptyState extends StatelessWidget {
  final bool isPaidTab;

  const ViolationsEmptyState({
    super.key,
    this.isPaidTab = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height - 300.h,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsetsDirectional.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPaidTab
                      ? EvaIcons.checkmarkCircle2
                      : EvaIcons.alertCircleOutline,
                  size: 80.sp,
                  color: AppColors.secondaryText.withValues(alpha: 0.6),
                ),
                SizedBox(height: 24.h),
                Text(
                  isPaidTab
                      ? l10n.violationsEmptyPaid
                      : l10n.violationsEmptyUnpaid,
                  style: AppTextStyles.titleLarge(context),
                  softWrap: true,
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.violationsEmptySubtitle,
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


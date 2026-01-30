import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

/// Notifications Empty State
/// Modern empty state with icon and message
class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

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
            padding: EdgeInsets.all(32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  EvaIcons.bellOffOutline,
                  size: 80.sp,
                  color: AppColors.secondaryText.withValues(alpha: 0.6),
                ),
                SizedBox(height: 24.h),
                Text(
                  l10n.notificationsEmpty,
                  style: AppTextStyles.titleLarge(context),
                ),
                SizedBox(height: 8.h),
                Text(
                  l10n.notificationsEmptySubtitle,
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.secondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


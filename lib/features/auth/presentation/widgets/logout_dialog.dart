import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/widgets/custom_elevated_button.dart';

/// Logout Confirmation Dialog
/// Confirmation dialog for logout action
class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(height: 16.h),
            // Content
            Text(
              'Are you sure you want to logout?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.secondaryText,
              ),
            ),
            SizedBox(height: 24.h),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel Button
                Expanded(
                  child: CustomElevatedButton(
                    title: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.primary,
                    useGradient: false,
                  ),
                ),
                SizedBox(width: 12.w),
                // Logout Button
                Expanded(
                  child: CustomElevatedButton(
                    title: 'Logout',
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                    },
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.textOnPrimary,
                    useGradient: false,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Show logout confirmation dialog
  static void show(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => LogoutDialog(onConfirm: onConfirm),
    );
  }
}


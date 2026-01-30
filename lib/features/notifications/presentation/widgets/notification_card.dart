import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/notification_entity.dart';
import '../../../../core/routes/app_routes.dart';

/// Notification Card Widget
/// Displays notification information in a modern card design
class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;

  const NotificationCard({super.key, required this.notification, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    final isUnread = notification.isUnread;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      shadowColor: Colors.black.withValues(alpha: 0.08),
      margin: EdgeInsets.only(bottom: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isUnread
                ? AppColors.primary.withValues(alpha: 0.2)
                : AppColors.border.withValues(alpha: 0.3),
            width: isUnread ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                onTap ??
                () {
                  context.push(
                    Routes.notificationDetailsPath.replaceAll(
                      ':id',
                      notification.notificationId.toString(),
                    ),
                    extra: notification,
                  );
                },
            borderRadius: BorderRadius.circular(16.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Unread indicator dot (RTL-aware margin)
                  if (isUnread) ...[
                    Container(
                      width: 8.w,
                      height: 8.h,
                      margin: EdgeInsetsDirectional.only(
                        top: 6.h,
                        end: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ] else
                    SizedBox(width: 20.w),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          notification.title,
                          style: AppTextStyles.titleMedium(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        // Message
                        Text(
                          notification.message,
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: AppColors.secondaryText,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        // Date and time
                        Row(
                          children: [
                            Icon(
                              EvaIcons.clockOutline,
                              size: 14.sp,
                              color: AppColors.secondaryText,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              _formatDateTime(context, notification.createdAt),
                              style: AppTextStyles.bodySmall(
                                context,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Mark as read / done icon (read & remove from list)
                  Icon(
                    EvaIcons.checkmarkCircle2Outline,
                    size: 22.sp,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDateTime(BuildContext context, String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      final locale = Localizations.localeOf(context);
      final isArabic = locale.languageCode == 'ar';

      if (difference.inDays == 0) {
        final timeFormat = DateFormat('HH:mm', isArabic ? 'ar' : 'en');
        return timeFormat.format(date);
      } else if (difference.inDays == 1) {
        final l10n = AppLocalizations.of(context);
        return l10n?.commonYesterday ?? 'Yesterday';
      } else if (difference.inDays < 7) {
        final dayFormat = DateFormat('EEE', isArabic ? 'ar' : 'en');
        return dayFormat.format(date);
      } else {
        final dateTimeFormat = DateFormat(
          isArabic ? 'd MMM yyyy • HH:mm' : 'MMM d, yyyy • HH:mm',
          isArabic ? 'ar' : 'en',
        );
        return dateTimeFormat.format(date);
      }
    } catch (e) {
      return dateString;
    }
  }
}

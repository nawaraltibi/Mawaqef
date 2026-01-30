import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notifications_bloc.dart';

/// Notification Details Screen
/// Displays full notification details
class NotificationDetailsScreen extends StatefulWidget {
  final NotificationEntity notification;

  const NotificationDetailsScreen({
    super.key,
    required this.notification,
  });

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  bool _markAsReadFired = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_markAsReadFired) return;
      if (widget.notification.isUnread && mounted) {
        _markAsReadFired = true;
        context.read<NotificationsBloc>().add(
              NotificationClickedEvent(
                notificationId: widget.notification.notificationId,
              ),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.notificationsDetailsTitle,
          style: AppTextStyles.titleLarge(context),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            EvaIcons.arrowBack,
            size: 24.sp,
            color: AppColors.primaryText,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.notification.title,
                      style: AppTextStyles.titleLarge(context),
                    ),
                    SizedBox(height: 16.h),
                    // Date and time
                    Row(
                      children: [
                        Icon(
                          EvaIcons.clockOutline,
                          size: 16.sp,
                          color: AppColors.secondaryText,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _formatFullDateTime(context, widget.notification.createdAt),
                          style: AppTextStyles.bodySmall(
                            context,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    // Divider
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: 24.h),
                    // Message content
                    Text(
                      widget.notification.message,
                      style: AppTextStyles.bodyLarge(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatFullDateTime(BuildContext context, String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final locale = Localizations.localeOf(context);
      final isArabic = locale.languageCode == 'ar';
      final dateFormat = DateFormat(
        isArabic ? 'd MMMM yyyy • HH:mm' : 'MMM d, yyyy • HH:mm',
        isArabic ? 'ar' : 'en',
      );
      return dateFormat.format(date);
    } catch (e) {
      return dateString;
    }
  }
}


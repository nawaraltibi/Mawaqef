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

/// Optimized Notification Card Widget
/// 
/// Performance optimizations applied:
/// - No AnimatedOpacity (causes full subtree rebuild)
/// - Pre-computed decorations cached statically
/// - Minimal widget depth
/// - No BoxShadow during swipe (GPU expensive)
/// - Uses DecoratedBox instead of Container where possible
class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const NotificationCard({
    super.key, 
    required this.notification, 
    this.onTap,
    this.onMarkAsRead,
  });

  // Static cached decorations - created once, reused forever
  static final _unreadDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16.r),
    border: Border.all(
      color: AppColors.primary.withOpacity(0.2),
      width: 1.5,
    ),
  );

  static final _readDecoration = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16.r),
    border: Border.all(
      color: AppColors.border.withOpacity(0.15),
      width: 1,
    ),
  );

  static final _borderRadius = BorderRadius.circular(16.r);
  
  // Cached dimensions
  static final _cardPadding = EdgeInsets.all(16.w);
  static final _cardMargin = EdgeInsets.only(bottom: 12.h);
  static final _indicatorSize = 8.w;
  static final _indicatorMargin = EdgeInsetsDirectional.only(top: 6.h, end: 12.w);
  static final _iconSize = 22.sp;
  static final _clockIconSize = 14.sp;
  
  // Cached colors
  static final _unreadIndicatorColor = AppColors.primary;
  static final _readIndicatorColor = AppColors.secondaryText.withOpacity(0.3);
  static final _unreadIconColor = AppColors.primary;
  static final _readIconColor = AppColors.secondaryText.withOpacity(0.5);

  @override
  Widget build(BuildContext context) {
    final isUnread = notification.isUnread;
    
    return Padding(
      padding: _cardMargin,
      child: DecoratedBox(
        decoration: isUnread ? _unreadDecoration : _readDecoration,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap ?? _defaultOnTap(context),
            borderRadius: _borderRadius,
            child: Padding(
              padding: _cardPadding,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status indicator dot
                  _StatusIndicator(isUnread: isUnread),
                  // Content
                  Expanded(
                    child: _CardContent(
                      notification: notification,
                      isUnread: isUnread,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Action button
                  _ActionButton(
                    isUnread: isUnread,
                    onTap: isUnread ? onMarkAsRead : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback _defaultOnTap(BuildContext context) {
    return () {
      context.push(
        Routes.notificationDetailsPath.replaceAll(
          ':id',
          notification.notificationId.toString(),
        ),
        extra: notification,
      );
    };
  }
}

/// Lightweight status indicator
class _StatusIndicator extends StatelessWidget {
  final bool isUnread;
  
  const _StatusIndicator({required this.isUnread});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: NotificationCard._indicatorSize,
      height: NotificationCard._indicatorSize,
      margin: NotificationCard._indicatorMargin,
      decoration: BoxDecoration(
        color: isUnread 
            ? NotificationCard._unreadIndicatorColor 
            : NotificationCard._readIndicatorColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Card content with cached text styles
class _CardContent extends StatelessWidget {
  final NotificationEntity notification;
  final bool isUnread;
  
  const _CardContent({
    required this.notification,
    required this.isUnread,
  });

  @override
  Widget build(BuildContext context) {
    // Apply opacity via color alpha instead of Opacity widget (GPU friendly)
    final textOpacity = isUnread ? 1.0 : 0.7;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          notification.title,
          style: AppTextStyles.titleMedium(context).copyWith(
            fontWeight: isUnread ? FontWeight.w600 : FontWeight.w400,
            color: AppColors.primaryText.withOpacity(textOpacity),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        // Message
        Text(
          notification.message,
          style: AppTextStyles.bodyMedium(
            context,
            color: AppColors.secondaryText.withOpacity(textOpacity),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        // Date row
        _DateRow(
          dateString: notification.createdAt,
          opacity: textOpacity,
        ),
      ],
    );
  }
}

/// Optimized date row with cached formatting
class _DateRow extends StatelessWidget {
  final String? dateString;
  final double opacity;
  
  const _DateRow({
    required this.dateString,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          EvaIcons.clockOutline,
          size: NotificationCard._clockIconSize,
          color: AppColors.secondaryText.withOpacity(opacity),
        ),
        const SizedBox(width: 6),
        Text(
          _formatDateTime(context, dateString),
          style: AppTextStyles.bodySmall(
            context,
            color: AppColors.secondaryText.withOpacity(opacity),
          ),
        ),
      ],
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
        return DateFormat('HH:mm', isArabic ? 'ar' : 'en').format(date);
      } else if (difference.inDays == 1) {
        final l10n = AppLocalizations.of(context);
        return l10n?.commonYesterday ?? 'Yesterday';
      } else if (difference.inDays < 7) {
        return DateFormat('EEE', isArabic ? 'ar' : 'en').format(date);
      } else {
        return DateFormat(
          isArabic ? 'd MMM yyyy' : 'MMM d, yyyy',
          isArabic ? 'ar' : 'en',
        ).format(date);
      }
    } catch (e) {
      return dateString;
    }
  }
}

/// Lightweight action button
class _ActionButton extends StatelessWidget {
  final bool isUnread;
  final VoidCallback? onTap;
  
  const _ActionButton({
    required this.isUnread,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          isUnread 
              ? EvaIcons.checkmarkCircle2Outline 
              : EvaIcons.checkmarkCircle2,
          size: NotificationCard._iconSize,
          color: isUnread 
              ? NotificationCard._unreadIconColor 
              : NotificationCard._readIconColor,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles/app_colors.dart';

/// Unified Snackbar Types
enum SnackbarType { success, error, info, warning }

/// Snackbar Configuration
class SnackbarConfig {
  final Duration duration;
  final SnackBarBehavior behavior;
  final EdgeInsets margin;
  final double? width;
  final bool showCloseButton;
  final VoidCallback? onTap;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const SnackbarConfig({
    this.duration = const Duration(seconds: 3),
    this.behavior = SnackBarBehavior.floating,
    this.margin = const EdgeInsets.all(16),
    this.width,
    this.showCloseButton = false,
    this.onTap,
    this.actionLabel,
    this.onActionTap,
  });
}

/// Unified Snackbar Service
class UnifiedSnackbar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Overlay entry for showing snackbar above everything
  static OverlayEntry? _currentOverlayEntry;

  static void show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    SnackbarConfig? config,
  }) {
    final snackbarConfig = config ??
        const SnackbarConfig(
          duration: Duration(seconds: 2),
          showCloseButton: false,
        );

    // Use Overlay to show above everything (dialogs, bottom sheets, etc.)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOverlaySnackbar(
        context,
        message: message,
        type: type,
        config: snackbarConfig,
      );
    });
  }

  static void _showOverlaySnackbar(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    required SnackbarConfig config,
  }) {
    // Remove previous overlay if exists
    _removeOverlay();

    try {
      // Check if context is still mounted/valid
      if (!context.mounted) {
        return;
      }

      // Get overlay from root navigator to ensure it's above everything
      final overlay = Overlay.maybeOf(context, rootOverlay: true);
      if (overlay == null) {
        return;
      }

      // Create overlay entry
      _currentOverlayEntry = OverlayEntry(
        builder: (context) => _OverlaySnackbarWidget(
          message: message,
          type: type,
          config: config,
          onDismiss: _removeOverlay,
        ),
      );

      // Insert overlay
      overlay.insert(_currentOverlayEntry!);

      // Auto remove after duration
      Future.delayed(config.duration, () {
        _removeOverlay();
      });
    } catch (e) {
      // If context is deactivated or overlay is not available, silently fail
      // This prevents crashes when widget is disposed
      _removeOverlay();
    }
  }

  static void _removeOverlay() {
    _currentOverlayEntry?.remove();
    _currentOverlayEntry = null;
  }

  /// Show using global key (safe across navigation)
  static void showGlobal({
    required String message,
    SnackbarType type = SnackbarType.info,
    SnackbarConfig? config,
  }) {
    final snackbarConfig = config ?? const SnackbarConfig();
    final messenger = scaffoldMessengerKey.currentState;
    if (messenger == null) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: snackbarConfig.behavior,
        duration: snackbarConfig.duration,
        margin: snackbarConfig.margin,
        width: snackbarConfig.width,
      ),
    );
  }

  /// Quick success snackbar
  static void success(
    BuildContext context, {
    required String message,
    SnackbarConfig? config,
  }) {
    show(context, message: message, type: SnackbarType.success, config: config);
  }

  static void successGlobal(String message, {SnackbarConfig? config}) {
    showGlobal(message: message, type: SnackbarType.success, config: config);
  }

  /// Quick error snackbar
  static void error(
    BuildContext context, {
    required String message,
    SnackbarConfig? config,
  }) {
    show(context, message: message, type: SnackbarType.error, config: config);
  }

  static void errorGlobal(String message, {SnackbarConfig? config}) {
    showGlobal(message: message, type: SnackbarType.error, config: config);
  }

  /// Quick info snackbar
  static void info(
    BuildContext context, {
    required String message,
    SnackbarConfig? config,
  }) {
    show(context, message: message, type: SnackbarType.info, config: config);
  }

  /// Quick warning snackbar
  static void warning(
    BuildContext context, {
    required String message,
    SnackbarConfig? config,
  }) {
    show(context, message: message, type: SnackbarType.warning, config: config);
  }

  /// Hide current snackbar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Clear all snackbars
  static void clear(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

/// Custom Snackbar Content Widget
class _SnackbarContent extends StatelessWidget {
  final String message;
  final SnackbarType type;
  final bool showCloseButton;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final bool isRTL;
  final VoidCallback? onClose;

  const _SnackbarContent({
    required this.message,
    required this.type,
    required this.showCloseButton,
    required this.isRTL,
    this.actionLabel,
    this.onActionTap,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _getBorderColor(), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryText.withValues(alpha: 0.1), // Use theme color instead of hardcoded black
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          _buildIcon(),
          SizedBox(width: 12.w),

          // Message
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: _getTextColor(),
              ),
            ),
          ),

          // Action Button
          if (actionLabel != null && onActionTap != null) ...[
            SizedBox(width: 8.w),
            _buildActionButton(context),
          ],

          // Close Button
          if (showCloseButton) ...[
            SizedBox(width: 8.w),
            _buildCloseButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 24.w,
      height: 24.h,
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(),
        shape: BoxShape.circle,
      ),
      child: Icon(_getIcon(), size: 16.sp, color: _getIconColor()),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return GestureDetector(
      onTap: onActionTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: _getActionButtonColor(),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          actionLabel!,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: _getActionButtonTextColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return GestureDetector(
      onTap:
          onClose ?? () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      child: Container(
        width: 20.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: _getCloseButtonColor(),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close,
          size: 12.sp,
          color: _getCloseButtonIconColor(),
        ),
      ),
    );
  }

  // Color and Icon Getters
  Color _getBackgroundColor() {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFFF0F9F4);
      case SnackbarType.error:
        return const Color(0xFFFEF2F2);
      case SnackbarType.warning:
        return const Color(0xFFFEFBF0);
      case SnackbarType.info:
        return AppColors.lightBlue;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFFD1FAE5);
      case SnackbarType.error:
        return const Color(0xFFFECACA);
      case SnackbarType.warning:
        return const Color(0xFFFDE68A);
      case SnackbarType.info:
        return AppColors.mediumBlue;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF065F46);
      case SnackbarType.error:
        return const Color(0xFF991B1B);
      case SnackbarType.warning:
        return const Color(0xFF92400E);
      case SnackbarType.info:
        return AppColors.primaryDark;
    }
  }

  Color _getIconBackgroundColor() {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF10B981);
      case SnackbarType.error:
        return AppColors.error;
      case SnackbarType.warning:
        return const Color(0xFFF59E0B);
      case SnackbarType.info:
        return AppColors.primary;
    }
  }

  Color _getIconColor() {
    return AppColors.textOnPrimary; // Use theme color instead of hardcoded white
  }

  IconData _getIcon() {
    switch (type) {
      case SnackbarType.success:
        return Icons.check;
      case SnackbarType.error:
        return Icons.error_outline;
      case SnackbarType.warning:
        return Icons.warning_outlined;
      case SnackbarType.info:
        return Icons.info_outline;
    }
  }

  Color _getActionButtonColor() {
    switch (type) {
      case SnackbarType.success:
        return const Color(0xFF10B981);
      case SnackbarType.error:
        return AppColors.error;
      case SnackbarType.warning:
        return const Color(0xFFF59E0B);
      case SnackbarType.info:
        return AppColors.primary;
    }
  }

  Color _getActionButtonTextColor() {
    return AppColors.textOnPrimary; // Use theme color instead of hardcoded white
  }

  Color _getCloseButtonColor() {
    return _getTextColor().withValues(alpha: 0.1);
  }

  Color _getCloseButtonIconColor() {
    return _getTextColor().withValues(alpha: 0.6);
  }
}

/// Overlay Snackbar Widget - Shows above everything
class _OverlaySnackbarWidget extends StatefulWidget {
  final String message;
  final SnackbarType type;
  final SnackbarConfig config;
  final VoidCallback onDismiss;

  const _OverlaySnackbarWidget({
    required this.message,
    required this.type,
    required this.config,
    required this.onDismiss,
  });

  @override
  State<_OverlaySnackbarWidget> createState() => _OverlaySnackbarWidgetState();
}

class _OverlaySnackbarWidgetState extends State<_OverlaySnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + 16.h,
      left: widget.config.margin.left,
      right: widget.config.margin.right,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: _SnackbarContent(
                message: widget.message,
                type: widget.type,
                showCloseButton: widget.config.showCloseButton,
                actionLabel: widget.config.actionLabel,
                onActionTap: widget.config.onActionTap,
                isRTL: false,
                onClose: widget.onDismiss,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


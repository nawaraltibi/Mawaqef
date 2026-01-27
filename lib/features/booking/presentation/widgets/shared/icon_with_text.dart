import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/core.dart';

/// Icon with Text Widget
/// Reusable component for displaying icon with text
class IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final TextStyle? textStyle;
  final double? spacing;
  final bool expandText;

  const IconWithText({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.textStyle,
    this.spacing,
    this.expandText = false,
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      style: textStyle ??
          AppTextStyles.bodyMedium(
            context,
            color: textColor ?? AppColors.secondaryText,
          ),
      maxLines: expandText ? null : 1,
      overflow: expandText ? null : TextOverflow.ellipsis,
    );

    return Row(
      children: [
        Icon(
          icon,
          size: iconSize ?? 18.sp,
          color: iconColor ?? AppColors.secondaryText,
        ),
        SizedBox(width: spacing ?? 8.w),
        expandText ? Expanded(child: textWidget) : textWidget,
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';

/// Custom Text Field Widget
/// Consistent text input field with validation support
/// 
/// UX Behavior:
/// - [helperText] shown only when field is empty (before user starts typing)
/// - [helperText] disappears once user starts typing
/// - [errorText] shown only when validation fails (on submit)
/// - Modern, subtle shadow for comfortable visual appearance
/// - Validation timing is controlled externally via Bloc (on submit only)
/// - No red errors appear while typing (autovalidate disabled)
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final bool isPassword;
  final bool enabled;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;

  const CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.isPassword = false,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    this.autovalidateMode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _hasText = widget.controller.text.isNotEmpty;
    // Listen to controller changes to show/hide helper text
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final actualObscureText = widget.isPassword ? _obscureText : false;
    final calculatedMaxLines = actualObscureText ? 1 : (widget.maxLines ?? 1);
    
    // Determine if there's an external error from Bloc state
    final hasExternalError = widget.errorText != null && widget.errorText!.isNotEmpty;
    
    // Helper text is shown only when:
    // 1. There's no error
    // 2. The field is empty (no text yet)
    final shouldShowHelper = !hasExternalError && !_hasText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.fieldLabel(context),
          ),
          SizedBox(height: 8.h),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            // Very soft, subtle shadow - comfortable for eyes in all states
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 1),
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            validator: widget.validator,
            enabled: widget.enabled,
            obscureText: actualObscureText,
            maxLines: calculatedMaxLines,
            focusNode: widget.focusNode,
            // Disable autovalidate by default - validation is controlled by Bloc
            // Red errors only appear on submit, not while typing
            autovalidateMode: widget.autovalidateMode ?? AutovalidateMode.disabled,
            onChanged: widget.onChanged,
            style: AppTextStyles.fieldInput(context, enabled: widget.enabled),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.fieldHint(context),
              // Show helper text only when field is empty and no error
              helperText: shouldShowHelper ? widget.helperText : null,
              helperStyle: AppTextStyles.fieldHelper(context),
              helperMaxLines: 2,
              // External error from Bloc state (shown on submit)
              errorText: widget.errorText,
              errorStyle: AppTextStyles.fieldError(context),
              errorMaxLines: 2,
              filled: true,
              fillColor: widget.enabled
                  ? AppColors.brightWhite
                  : AppColors.backgroundSecondary,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 18.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.error.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.error.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22.r),
                borderSide: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? EvaIcons.eye
                            : EvaIcons.eyeOff,
                        color: AppColors.secondaryText,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  : widget.suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}


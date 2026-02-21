import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/login/login_bloc.dart' show ValidationErrorType;
import '../utils/auth_validators.dart';

/// Reusable form fields for login
/// 
/// UX Validation Model:
/// - No inline validators (validation controlled by Bloc)
/// - Helper text shown by default (muted gray)
/// - Error text shown only on submit (red, localized)
/// - Errors only appear when user presses Login button
class LoginFormFields extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPasswordChanged;
  final ValidationErrorType? emailError;
  final ValidationErrorType? passwordError;

  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    this.onEmailChanged,
    this.onPasswordChanged,
    this.emailError,
    this.passwordError,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          label: l10n.authEmailLabel,
          hintText: l10n.authEmailHint,
          // Map error type to localized message
          errorText: AuthValidators.getEmailErrorMessage(emailError, l10n),
          controller: emailController,
          focusNode: emailFocusNode,
          onChanged: onEmailChanged,
          prefixIcon: Icon(
            EvaIcons.emailOutline,
            color: AppColors.primary,
            size: 20.sp,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          label: l10n.authPasswordLabel,
          hintText: l10n.authPasswordHint,
          // Map error type to localized message
          errorText: AuthValidators.getPasswordErrorMessage(passwordError, l10n),
          controller: passwordController,
          focusNode: passwordFocusNode,
          onChanged: onPasswordChanged,
          prefixIcon: Icon(
            EvaIcons.lock,
            color: AppColors.primary,
            size: 20.sp,
          ),
          isPassword: true,
          obscureText: true,
        ),
      ],
    );
  }
}


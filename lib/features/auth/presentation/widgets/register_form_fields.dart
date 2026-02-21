import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_dropdown_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/login/login_bloc.dart' show ValidationErrorType;
import '../utils/auth_validators.dart';

/// Reusable form fields for registration
/// 
/// UX Validation Model:
/// - No inline validators (validation controlled by Bloc)
/// - Helper text shown by default (muted gray)
/// - Error text shown only on submit (red, localized)
/// - Errors only appear when user presses Register button
class RegisterFormFields extends StatelessWidget {
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmationController;
  final FocusNode fullNameFocusNode;
  final FocusNode emailFocusNode;
  final FocusNode phoneFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode passwordConfirmationFocusNode;
  final String selectedUserType;
  final ValueChanged<String> onUserTypeChanged;
  final ValueChanged<String>? onFullNameChanged;
  final ValueChanged<String>? onEmailChanged;
  final ValueChanged<String>? onPhoneChanged;
  final ValueChanged<String>? onPasswordChanged;
  final ValueChanged<String>? onPasswordConfirmationChanged;
  final ValidationErrorType? fullNameError;
  final ValidationErrorType? emailError;
  final ValidationErrorType? phoneError;
  final ValidationErrorType? passwordError;
  final ValidationErrorType? passwordConfirmationError;
  final List<String> userTypes;

  const RegisterFormFields({
    super.key,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.passwordConfirmationController,
    required this.fullNameFocusNode,
    required this.emailFocusNode,
    required this.phoneFocusNode,
    required this.passwordFocusNode,
    required this.passwordConfirmationFocusNode,
    required this.selectedUserType,
    required this.onUserTypeChanged,
    this.onFullNameChanged,
    this.onEmailChanged,
    this.onPhoneChanged,
    this.onPasswordChanged,
    this.onPasswordConfirmationChanged,
    this.fullNameError,
    this.emailError,
    this.phoneError,
    this.passwordError,
    this.passwordConfirmationError,
    this.userTypes = const ['user', 'owner'],
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Full Name Field
        CustomTextField(
          label: l10n.authFullNameLabel,
          hintText: l10n.authFullNameHint,
          // Map error type to localized message
          errorText: AuthValidators.getFullNameErrorMessage(fullNameError, l10n),
          controller: fullNameController,
          focusNode: fullNameFocusNode,
          onChanged: onFullNameChanged,
          prefixIcon: Icon(
            EvaIcons.person,
            color: AppColors.primary,
            size: 20.sp,
          ),
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 16.h),

        // Email Field
        CustomTextField(
          label: l10n.authEmailLabel,
          hintText: l10n.authEmailHint,
          // Map error type to localized message
          errorText: AuthValidators.getEmailErrorMessage(emailError, l10n),
          controller: emailController,
          focusNode: emailFocusNode,
          onChanged: onEmailChanged,
          prefixIcon: Icon(
            EvaIcons.email,
            color: AppColors.primary,
            size: 20.sp,
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16.h),

        // Phone Field
        CustomTextField(
          label: l10n.authPhoneLabel,
          hintText: l10n.authPhoneHint,
          // Map error type to localized message
          errorText: AuthValidators.getPhoneErrorMessage(phoneError, l10n),
          controller: phoneController,
          focusNode: phoneFocusNode,
          onChanged: onPhoneChanged,
          prefixIcon: Icon(
            EvaIcons.phone,
            color: AppColors.primary,
            size: 20.sp,
          ),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.h),

        // User Type Dropdown
        CustomDropdownField<String>(
          label: l10n.authUserTypeLabel,
          items: userTypes,
          selectedValue: selectedUserType,
          getLabel: (value) => value == 'user'
              ? l10n.authUserTypeRegular
              : l10n.authUserTypeOwner,
          onChanged: (value) {
            if (value != null) {
              onUserTypeChanged(value);
            }
          },
        ),
        SizedBox(height: 16.h),

        // Password Field
        CustomTextField(
          label: l10n.authPasswordLabel,
          hintText: l10n.authPasswordRegisterHint,
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
        SizedBox(height: 16.h),

        // Password Confirmation Field
        CustomTextField(
          label: l10n.authConfirmPasswordLabel,
          hintText: l10n.authConfirmPasswordHint,
          // Map error type to localized message
          errorText: AuthValidators.getPasswordConfirmationErrorMessage(passwordConfirmationError, l10n),
          controller: passwordConfirmationController,
          focusNode: passwordConfirmationFocusNode,
          onChanged: onPasswordConfirmationChanged,
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


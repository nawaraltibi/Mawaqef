import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/unified_snackbar.dart';
import '../../../core/widgets/custom_dropdown_field.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/register/register_bloc.dart';

/// Register Screen
/// UI component for user registration
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String selectedUserType = 'user';

  final List<String> userTypes = ['user', 'owner'];

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  /// Translate error messages based on known error codes or messages
  String _translateErrorMessage(BuildContext context, String error, int statusCode) {
    // Return original error message if not recognized
    // Most validation errors from API should already be in the error message
    return error;
  }

  void _handleRegister() {
    if (formKey.currentState!.validate()) {
      final bloc = context.read<RegisterBloc>();
      
      // Update all fields in the bloc state
      bloc.add(UpdateFullName(fullNameController.text.trim()));
      bloc.add(UpdateEmail(emailController.text.trim()));
      bloc.add(UpdatePhone(phoneController.text.trim()));
      bloc.add(UpdateUserType(selectedUserType));
      bloc.add(UpdatePassword(passwordController.text));
      bloc.add(UpdatePasswordConfirmation(passwordConfirmationController.text));
      
      // Send register request
      bloc.add(SendRegisterRequest());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              UnifiedSnackbar.success(
                context,
                message: state.message,
              );

              // Show appropriate message based on user type
              if (state.response.requiresApproval) {
                // Owner registration - pending approval
                final l10n = AppLocalizations.of(context)!;
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    UnifiedSnackbar.info(
                      context,
                      message: l10n.authSuccessRegisterPending,
                    );
                  }
                });
              }

              // Navigate to login after a short delay
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  context.pushReplacement(Routes.loginPath);
                }
              });
            } else if (state is RegisterFailure) {
              String errorMessage = _translateErrorMessage(context, state.error, state.statusCode);
              UnifiedSnackbar.error(context, message: errorMessage);
            }
          },
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 32.h),

                      // Back button
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                          color: AppColors.primaryText,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Register Title
                      Text(
                        l10n.authRegisterTitle,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.authRegisterSubtitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Full Name Field
                      CustomTextField(
                        label: l10n.authFullNameLabel,
                        hintText: l10n.authFullNameHint,
                        controller: fullNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.authValidationFullNameRequired;
                          }
                          if (value.length > 255) {
                            return l10n.authValidationFullNameLong;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Email Field
                      CustomTextField(
                        label: l10n.authEmailLabel,
                        hintText: l10n.authEmailHint,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.authValidationEmailRequired;
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return l10n.authValidationEmailInvalid;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Phone Field
                      CustomTextField(
                        label: l10n.authPhoneLabel,
                        hintText: l10n.authPhoneHint,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.authValidationPhoneRequired;
                          }
                          return null;
                        },
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
                            setState(() {
                              selectedUserType = value;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Password Field
                      CustomTextField(
                        label: l10n.authPasswordLabel,
                        hintText: l10n.authPasswordRegisterHint,
                        controller: passwordController,
                        isPassword: true,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.authValidationPasswordRequired;
                          }
                          if (value.length < 8) {
                            return l10n.authValidationPasswordShort;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Password Confirmation Field
                      CustomTextField(
                        label: l10n.authConfirmPasswordLabel,
                        hintText: l10n.authConfirmPasswordHint,
                        controller: passwordConfirmationController,
                        isPassword: true,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.authValidationPasswordConfirmationRequired;
                          }
                          if (value != passwordController.text) {
                            return l10n.authValidationPasswordMismatch;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.h),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          title: l10n.authRegisterButton,
                          isLoading: state is RegisterLoading,
                          onPressed: _handleRegister,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.authHaveAccount,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.pushReplacement(
                              Routes.loginPath,
                            ),
                            child: Text(
                              l10n.authLoginButton,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


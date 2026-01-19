import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/unified_snackbar.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/login/login_bloc.dart';

/// Login Screen
/// UI component for user login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Translate error messages based on known error codes or messages
  String _translateErrorMessage(BuildContext context, String error, int statusCode) {
    final l10n = AppLocalizations.of(context)!;
    
    // Map known error messages to localized strings
    if (statusCode == 401) {
      return l10n.authErrorInvalidCredentials;
    }
    if (error.contains('Invalid Email or Password') || 
        error.toLowerCase().contains('invalid credentials')) {
      return l10n.authErrorInvalidCredentials;
    }
    if (error.contains('Your account is pending admin approval')) {
      return l10n.authErrorAccountPending;
    }
    if (error.contains('Your account has been blocked')) {
      return l10n.authErrorAccountBlocked;
    }
    
    // Return original error message if not recognized
    return error;
  }

  void _handleLogin() {
    if (formKey.currentState!.validate()) {
      final bloc = context.read<LoginBloc>();
      
      // Update email and password in the bloc state
      bloc.add(UpdateEmail(emailController.text.trim()));
      bloc.add(UpdatePassword(passwordController.text));
      
      // Send login request
      bloc.add(SendLoginRequest());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              UnifiedSnackbar.success(
                context,
                message: state.message,
              );

              // Navigate to appropriate main screen based on user type
              final userType = state.response.userType;
              final navigator = GoRouter.of(context);
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  if (userType == 'owner') {
                    navigator.pushReplacement(Routes.ownerMainPath);
                  } else if (userType == 'user') {
                    navigator.pushReplacement(Routes.userMainPath);
                  } else {
                    // Fallback to user main screen for unknown types
                    navigator.pushReplacement(Routes.userMainPath);
                  }
                }
              });
            } else if (state is LoginFailure) {
              String errorMessage = _translateErrorMessage(context, state.error, state.statusCode);
              
              // Handle inactive user messages with appropriate styling
              if (state.isInactiveUser) {
                // Show warning for inactive users (owner pending approval or user blocked)
                UnifiedSnackbar.warning(
                  context,
                  message: errorMessage,
                );
              } else {
                // Show error for other login failures
                UnifiedSnackbar.error(context, message: errorMessage);
              }
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

                      // Welcome Title
                      Text(
                        l10n.authLoginTitle,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        l10n.authLoginSubtitle,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      SizedBox(height: 48.h),

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

                      // Password Field
                      CustomTextField(
                        label: l10n.authPasswordLabel,
                        hintText: l10n.authPasswordHint,
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
                      SizedBox(height: 24.h),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          title: l10n.authLoginButton,
                          isLoading: state is LoginLoading,
                          onPressed: _handleLogin,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.authNoAccount,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.pushReplacement(
                              Routes.registerPath,
                            ),
                            child: Text(
                              l10n.authRegisterButton,
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


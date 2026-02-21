import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/unified_snackbar.dart';
import '../../../core/assets/assets.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/login/login_bloc.dart';
import 'utils/auth_error_handler.dart';
import 'widgets/login_form_fields.dart';

/// Login Screen
/// UI component for user login
/// 
/// UX Validation Model:
/// - No red errors while typing (errors cleared on value change)
/// - Errors shown only on blur (field unfocused) or submit
/// - Helper text displayed by default, replaced by error when validation fails
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  // FocusNodes for detecting blur events
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  /// Handle login button press
  /// Updates bloc with current values and dispatches submit event
  void _handleLogin() {
    // Unfocus all fields first to trigger any pending validation
    FocusScope.of(context).unfocus();
    
    final bloc = context.read<LoginBloc>();

    // Update email and password in the bloc state
    bloc.add(UpdateEmail(emailController.text.trim()));
    bloc.add(UpdatePassword(passwordController.text));

    // Send login request (bloc will validate and show errors if needed)
    bloc.add(SendLoginRequest());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            if (state is LoginSuccess) {
              UnifiedSnackbar.success(context, message: l10n.authLoginSuccess);

              // Navigate to appropriate main screen based on user type
              // Only navigate if user is active (inactive owners are blocked before LoginSuccess)
              // Clear entire navigation stack
              final userType = state.response.userType;
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  if (userType == 'owner') {
                    context.go(Routes.ownerMainPath);
                  } else if (userType == 'user') {
                    context.go(Routes.userMainPath);
                  } else {
                    // Fallback to user main screen for unknown types
                    context.go(Routes.userMainPath);
                  }
                }
              });
            } else if (state is LoginFailure) {
              final errorMessage = AuthErrorHandler.handleLoginError(
                state.error,
                state.statusCode,
                l10n,
              );

              // Handle owner pending approval with specific message
              if (state.isInactiveUser && state.userType == 'owner') {
                UnifiedSnackbar.warning(
                  context,
                  message: l10n.authErrorOwnerPendingApproval,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 20.h),

                    // Login Image
                    Center(
                      child: Image.asset(
                        Assets.imagesLogin,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Welcome Title
                    Text(
                      l10n.authLoginTitle,
                      style: AppTextStyles.headlineLarge(
                        context,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.authLoginSubtitle,
                      style: AppTextStyles.bodyMedium(
                        context,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Login Form Fields
                    // Validation errors from Bloc state (shown on blur or submit)
                    LoginFormFields(
                      emailController: emailController,
                      passwordController: passwordController,
                      emailFocusNode: emailFocusNode,
                      passwordFocusNode: passwordFocusNode,
                      emailError: state.emailError,
                      passwordError: state.passwordError,
                      onEmailChanged: (value) {
                        context.read<LoginBloc>().add(UpdateEmail(value));
                      },
                      onPasswordChanged: (value) {
                        context.read<LoginBloc>().add(UpdatePassword(value));
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
                    SizedBox(height: 15.h),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.authNoAccount,
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push(Routes.registerPath),
                          child: Text(
                            l10n.authRegisterButton,
                            style: AppTextStyles.labelLarge(
                              context,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

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
import '../bloc/register/register_bloc.dart';
import 'utils/auth_error_handler.dart';
import 'widgets/register_form_fields.dart';

/// Register Screen
/// UI component for user registration
/// 
/// UX Validation Model:
/// - No red errors while typing (errors cleared on value change)
/// - Errors shown only on blur (field unfocused) or submit
/// - Helper text displayed by default, replaced by error when validation fails
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
  
  // FocusNodes for detecting blur events
  final FocusNode fullNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode passwordConfirmationFocusNode = FocusNode();
  
  String selectedUserType = 'user';

  final List<String> userTypes = ['user', 'owner'];

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    fullNameFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    passwordFocusNode.dispose();
    passwordConfirmationFocusNode.dispose();
    super.dispose();
  }

  /// Handle register button press
  /// Updates bloc with current values and dispatches submit event
  void _handleRegister() {
    // Unfocus all fields first to trigger any pending validation
    FocusScope.of(context).unfocus();
    
    final bloc = context.read<RegisterBloc>();

    // Update all fields in the bloc state
    bloc.add(UpdateFullName(fullNameController.text.trim()));
    bloc.add(UpdateEmail(emailController.text.trim()));
    bloc.add(UpdatePhone(phoneController.text.trim()));
    bloc.add(UpdateUserType(selectedUserType));
    bloc.add(UpdatePassword(passwordController.text));
    bloc.add(UpdatePasswordConfirmation(passwordConfirmationController.text));

    // Send register request (bloc will validate and show errors if needed)
    bloc.add(SendRegisterRequest());
  }

  void _goBackToLogin() {
    // Pop back to Login (stack: Login → Register); system back button does the same
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: _goBackToLogin,
        ),
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            final l10n = AppLocalizations.of(context)!;

            if (state is RegisterSuccess) {
              // Show single translated success message based on user type
              final successMessage = state.response.requiresApproval
                  ? l10n
                        .authSuccessRegisterOwner // Owner - pending approval
                  : l10n.authSuccessRegister; // Regular user

              UnifiedSnackbar.success(context, message: successMessage);

              // Navigate to login after a short delay
              // Clear entire navigation stack
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  context.go(Routes.loginPath);
                }
              });
            } else if (state is RegisterFailure) {
              final errorMessage = AuthErrorHandler.handleRegisterError(
                state.error,
                state.statusCode,
                l10n,
              );
              UnifiedSnackbar.error(context, message: errorMessage);
            }
          },
          builder: (context, state) {
            final l10n = AppLocalizations.of(context)!;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40.h),
                    // Sign Up Image
                    Center(
                      child: Image.asset(
                        Assets.imagesSignUp,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Register Title
                    Text(
                      l10n.authRegisterTitle,
                      style: AppTextStyles.headlineLarge(
                        context,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.authRegisterSubtitle,
                      style: AppTextStyles.bodyMedium(
                        context,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // Register Form Fields
                    // Validation errors from Bloc state (shown on blur or submit)
                    RegisterFormFields(
                      fullNameController: fullNameController,
                      emailController: emailController,
                      phoneController: phoneController,
                      passwordController: passwordController,
                      passwordConfirmationController:
                          passwordConfirmationController,
                      fullNameFocusNode: fullNameFocusNode,
                      emailFocusNode: emailFocusNode,
                      phoneFocusNode: phoneFocusNode,
                      passwordFocusNode: passwordFocusNode,
                      passwordConfirmationFocusNode: passwordConfirmationFocusNode,
                      fullNameError: state.fullNameError,
                      emailError: state.emailError,
                      phoneError: state.phoneError,
                      passwordError: state.passwordError,
                      passwordConfirmationError: state.passwordConfirmationError,
                      selectedUserType: selectedUserType,
                      onUserTypeChanged: (value) {
                        setState(() {
                          selectedUserType = value;
                        });
                        context.read<RegisterBloc>().add(UpdateUserType(value));
                      },
                      onFullNameChanged: (value) {
                        context.read<RegisterBloc>().add(UpdateFullName(value));
                      },
                      onEmailChanged: (value) {
                        context.read<RegisterBloc>().add(UpdateEmail(value));
                      },
                      onPhoneChanged: (value) {
                        context.read<RegisterBloc>().add(UpdatePhone(value));
                      },
                      onPasswordChanged: (value) {
                        context.read<RegisterBloc>().add(UpdatePassword(value));
                      },
                      onPasswordConfirmationChanged: (value) {
                        context.read<RegisterBloc>().add(UpdatePasswordConfirmation(value));
                      },
                      userTypes: userTypes,
                    ),
                    SizedBox(height: 24.h),

                    // Register Button
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        title: l10n.authRegisterButton,
                        isLoading: state is RegisterLoading,
                        onPressed: _handleRegister,
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.authHaveAccount,
                          style: AppTextStyles.bodyMedium(
                            context,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        TextButton(
                          onPressed: _goBackToLogin,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 4.h,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            l10n.authLoginButton,
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

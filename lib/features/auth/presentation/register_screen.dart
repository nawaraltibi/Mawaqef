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
import '../cubit/register_cubit.dart';
import '../models/register_request.dart';

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

  void _handleRegister() {
    if (formKey.currentState!.validate()) {
      final request = RegisterRequest(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        userType: selectedUserType,
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
      );

      context.read<RegisterCubit>().register(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              UnifiedSnackbar.success(
                context,
                message: state.message,
              );

              // Show appropriate message based on user type
              if (state.response.requiresApproval) {
                // Owner registration - pending approval
                Future.delayed(const Duration(seconds: 1), () {
                  UnifiedSnackbar.info(
                    context,
                    message:
                        'Your account is pending admin approval. You will be notified once approved.',
                  );
                });
              }

              // Navigate to login after a short delay
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  context.pushReplacement(Routes.loginPath);
                }
              });
            } else if (state is RegisterError) {
              UnifiedSnackbar.error(context, message: state.error);
            }
          },
          builder: (context, state) {
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
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Sign up to start using the parking app',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.secondaryText,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Full Name Field
                      CustomTextField(
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        controller: fullNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          if (value.length > 255) {
                            return 'Full name must not exceed 255 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Email Field
                      CustomTextField(
                        label: 'Email',
                        hintText: 'Enter your email',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Phone Field
                      CustomTextField(
                        label: 'Phone',
                        hintText: 'Enter your phone number',
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // User Type Dropdown
                      CustomDropdownField<String>(
                        label: 'User Type',
                        items: userTypes,
                        selectedValue: selectedUserType,
                        getLabel: (value) => value == 'user'
                            ? 'Regular User'
                            : 'Parking Owner',
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
                        label: 'Password',
                        hintText: 'Enter your password (min 8 characters)',
                        controller: passwordController,
                        isPassword: true,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),

                      // Password Confirmation Field
                      CustomTextField(
                        label: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        controller: passwordConfirmationController,
                        isPassword: true,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password confirmation is required';
                          }
                          if (value != passwordController.text) {
                            return 'Password confirmation does not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.h),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          title: 'Register',
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
                            'Already have an account? ',
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
                              'Login',
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


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/unified_snackbar.dart';
import '../../../data/repositories/auth_local_repository.dart';
import '../models/user_model.dart';
import '../cubit/logout_cubit.dart';
import 'widgets/logout_dialog.dart';

/// Profile Screen
/// UI component for displaying user profile and logout functionality
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userData = await AuthLocalRepository.getUser();
    if (userData != null && mounted) {
      setState(() {
        _user = UserModel.fromJson(userData);
      });
    }
  }

  void _showLogoutDialog() {
    LogoutDialog.show(
      context,
      () {
        context.read<LogoutCubit>().logout();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<LogoutCubit, LogoutState>(
          listener: (context, state) {
            if (state is LogoutSuccess) {
              UnifiedSnackbar.success(
                context,
                message: 'Logged out successfully',
              );

              // Navigate to login screen after logout
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted) {
                  context.pushReplacement(Routes.loginPath);
                }
              });
            } else if (state is LogoutError) {
              // Handle 401 (Unauthenticated) - clear data and navigate
              if (state.statusCode == 401) {
                // Auth data already cleared by LogoutCubit
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted) {
                    context.pushReplacement(Routes.loginPath);
                  }
                });
              } else {
                // Show error for other status codes (500, etc.)
                UnifiedSnackbar.error(context, message: state.error);
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 24.h),

                  // Profile Info Section
                  if (_user != null) ...[
                    // User Name
                    Text(
                      _user!.fullName,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // User Email
                    Text(
                      _user!.email,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // User Type
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        _user!.userType.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Status Badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: _user!.isActive
                            ? AppColors.success.withValues(alpha: 0.1)
                            : AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        _user!.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _user!.isActive ? AppColors.success : AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 48.h),

                  // Logout Button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.error,
                        width: 1.5,
                      ),
                    ),
                    child: CustomElevatedButton(
                      title: 'Logout',
                      isLoading: state is LogoutLoading,
                      onPressed: _showLogoutDialog,
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.error,
                      useGradient: false,
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


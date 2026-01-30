import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/app_text_styles.dart';
import '../../../core/widgets/custom_elevated_button.dart';
import '../../../core/widgets/unified_snackbar.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/profile/profile_bloc.dart';
import '../../auth/bloc/logout/logout_bloc.dart';
import '../models/profile_data_response.dart';
import '../models/update_profile_request.dart';
import '../models/update_password_request.dart';
import '../models/delete_account_request.dart';
import 'utils/profile_error_handler.dart';
import 'widgets/update_password_dialog.dart';
import 'widgets/delete_account_dialog.dart';
import 'widgets/language_switcher_tile.dart';
import 'widgets/profile_form_fields.dart';
import 'widgets/profile_status_badge.dart';
import 'widgets/profile_loading_state.dart';
import 'widgets/profile_error_state.dart';
import '../../../features/auth/presentation/widgets/logout_dialog.dart';

/// Profile Screen
/// UI component for displaying and managing user profile
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _controllersInitialized = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// Initialize controllers with profile data (only once)
  void _initializeControllers(ProfileDataResponse profileData) {
    if (!_controllersInitialized) {
      _fullNameController.text = profileData.data.fullName;
      _emailController.text = profileData.data.email;
      _phoneController.text = profileData.data.phone;
      _controllersInitialized = true;
    }
  }

  void _startEditing(ProfileDataResponse profileData) {
    setState(() {
      _isEditing = true;
      // Update controllers with current profile data when entering edit mode
      _fullNameController.text = profileData.data.fullName;
      _emailController.text = profileData.data.email;
      _phoneController.text = profileData.data.phone;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
    context.read<ProfileBloc>().add(ResetProfileState());
  }

  void _saveProfile() {
    final request = UpdateProfileRequest(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    context.read<ProfileBloc>().add(UpdateProfile(request));
  }

  void _showUpdatePasswordDialog() {
    UpdatePasswordDialog.show(context, (UpdatePasswordRequest request) {
      context.read<ProfileBloc>().add(UpdatePassword(request));
    });
  }

  void _showDeleteAccountDialog() {
    DeleteAccountDialog.show(context, (DeleteAccountRequest request) {
      context.read<ProfileBloc>().add(DeleteAccount(request));
    });
  }

  void _showLogoutDialog() {
    LogoutDialog.show(context, () {
      context.read<LogoutBloc>().add(LogoutRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n.authProfileTitle,
          style: AppTextStyles.titleLarge(context),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
            height: 1.h,
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: MultiBlocListener(
          listeners: [
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state is ProfileUpdateSuccess) {
                  UnifiedSnackbar.success(
                    context,
                    message: l10n.profileSuccessUpdate,
                  );
                  // Update editing state - setState needed for UI rebuild
                  // This is acceptable: simple UI state change, not business logic
                  if (mounted) {
                    setState(() {
                      _isEditing = false;
                    });
                  }
                  // Update controllers with new profile data after successful update
                  if (state.profileData != null) {
                    _fullNameController.text = state.profileData!.data.fullName;
                    _emailController.text = state.profileData!.data.email;
                    _phoneController.text = state.profileData!.data.phone;
                  }
                  // Reload profile to show updated data
                  context.read<ProfileBloc>().add(LoadProfile());
                } else if (state is PasswordUpdateSuccess) {
                  UnifiedSnackbar.success(
                    context,
                    message: l10n.profileSuccessPasswordUpdate,
                  );
                  // Navigate to login after password update (tokens are invalidated)
                  // Clear entire navigation stack
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      context.go(Routes.loginPath);
                    }
                  });
                } else if (state is AccountDeleteSuccess) {
                  UnifiedSnackbar.success(
                    context,
                    message: l10n.profileSuccessDeleteAccount,
                  );
                  // Navigate to login after account deletion
                  // Clear entire navigation stack
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      context.go(Routes.loginPath);
                    }
                  });
                } else if (state is ProfileFailure) {
                  final errorMessage = ProfileErrorHandler.handleErrorState(
                    state.error,
                    state.statusCode,
                    l10n,
                  );
                  UnifiedSnackbar.error(context, message: errorMessage);
                }
              },
            ),
            BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                if (state is LogoutSuccess) {
                  UnifiedSnackbar.success(
                    context,
                    message: l10n.authSuccessLogout,
                  );
                  // Navigate to login screen after logout
                  // Clear entire navigation stack
                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) {
                      context.go(Routes.loginPath);
                    }
                  });
                } else if (state is LogoutFailure) {
                  // Handle 401 (Unauthenticated) - clear data and navigate
                  // Clear entire navigation stack
                  if (state.statusCode == 401) {
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        context.go(Routes.loginPath);
                      }
                    });
                  } else {
                    // Show error for other status codes (500, etc.)
                    UnifiedSnackbar.error(context, message: state.error);
                  }
                }
              },
            ),
          ],
          child: BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (previous, current) {
              // Optimize rebuilds: only rebuild when state type changes or data actually changes
              if (previous.runtimeType != current.runtimeType) return true;
              if (current is ProfileLoaded && previous is ProfileLoaded) {
                return previous.profileData != current.profileData;
              }
              if (current is ProfileLoading && previous is ProfileLoading) {
                return previous.updateRequest != current.updateRequest;
              }
              return false;
            },
            builder: (context, state) {
              if (state is ProfileLoading && state.updateRequest == null) {
                return const ProfileLoadingState();
              }

              if (state is ProfileFailure && state.updateRequest == null) {
                final errorMessage = ProfileErrorHandler.handleErrorState(
                  state.error,
                  state.statusCode,
                  l10n,
                );
                return ProfileErrorState(
                  error: errorMessage,
                  onRetry: () {
                    context.read<ProfileBloc>().add(LoadProfile());
                  },
                );
              }

              ProfileDataResponse? profileData;
              if (state is ProfileLoaded) {
                profileData = state.profileData;
              } else if (state is ProfileUpdateSuccess &&
                  state.profileData != null) {
                profileData = state.profileData;
              }

              if (profileData == null) {
                // Initial load - trigger immediately
                if (state is ProfileInitial) {
                  // Load profile data immediately without waiting
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      context.read<ProfileBloc>().add(LoadProfile());
                    }
                  });
                }
                return const SizedBox.shrink();
              }

              // Initialize controllers with profile data (only once)
              _initializeControllers(profileData);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsetsDirectional.only(
                  start: 20.w,
                  end: 20.w,
                  top: 20.h,
                  bottom: 20.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 8.h),

                    // Profile Info Card
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Type Badge
                          ProfileStatusBadge(
                            status: profileData.data.userType,
                            isUserType: true,
                          ),
                          SizedBox(height: 16.h),

                          // Profile Form Fields
                          ProfileFormFields(
                            fullNameController: _fullNameController,
                            emailController: _emailController,
                            phoneController: _phoneController,
                            enabled: _isEditing,
                          ),
                          SizedBox(height: 16.h),

                          // Number of Vehicles (Read-only) - Only show for users, not owners
                          if (profileData.data.userType.toLowerCase() ==
                              'user') ...[
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSecondary.withValues(
                                  alpha: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: AppColors.border.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    l10n.profileNumberOfVehicles,
                                    style: AppTextStyles.bodyMedium(
                                      context,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  Text(
                                    '${profileData.data.numberOfVehicles}',
                                    style: AppTextStyles.titleMedium(
                                      context,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),
                          ],

                          // Status Badge
                          ProfileStatusBadge(
                            status: profileData.data.status,
                            isUserType: false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Edit/Save/Cancel Buttons
                    if (_isEditing) ...[
                      CustomElevatedButton(
                        title: l10n.profileSaveButton,
                        isLoading: state is ProfileLoading,
                        onPressed: _saveProfile,
                      ),
                      SizedBox(height: 12.h),
                      CustomElevatedButton(
                        title: l10n.profileCancelButton,
                        onPressed: _cancelEditing,
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primaryText,
                        useGradient: false,
                      ),
                    ] else ...[
                      CustomElevatedButton(
                        title: l10n.profileEditButton,
                        onPressed: () {
                          if (profileData != null) {
                            _startEditing(profileData);
                          }
                        },
                        icon: const Icon(Icons.edit, size: 20),
                      ),
                    ],
                    SizedBox(height: 16.h),

                    // Language Switcher
                    const LanguageSwitcherTile(),
                    SizedBox(height: 16.h),

                    // Update Password Button
                    CustomElevatedButton(
                      title: l10n.profileUpdatePasswordButton,
                      onPressed: _showUpdatePasswordDialog,
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.primary,
                      useGradient: false,
                      icon: const Icon(Icons.lock_outline, size: 20),
                    ),
                    SizedBox(height: 16.h),

                    // Violations Button (only for user, not owner)
                    if (profileData.data.userType.toLowerCase() == 'user')
                      CustomElevatedButton(
                        title: l10n.violationsTitle,
                        onPressed: () => context.push(Routes.violationsPath),
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primary,
                        useGradient: false,
                        icon: const Icon(Icons.receipt_long_outlined, size: 20),
                      ),
                    if (profileData.data.userType.toLowerCase() == 'user')
                      SizedBox(height: 16.h),

                    // Logout Button
                    BlocBuilder<LogoutBloc, LogoutState>(
                      builder: (context, logoutState) {
                        return CustomElevatedButton(
                          title: l10n.authLogoutButton,
                          isLoading: logoutState is LogoutLoading,
                          onPressed: _showLogoutDialog,
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.warning,
                          useGradient: false,
                          icon: const Icon(Icons.logout, size: 20),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),

                    // Delete Account Button
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: CustomElevatedButton(
                        title: l10n.profileDeleteAccountButton,
                        onPressed: _showDeleteAccountDialog,
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.error,
                        useGradient: false,
                        icon: const Icon(Icons.delete_outline, size: 20),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

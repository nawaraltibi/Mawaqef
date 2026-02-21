import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../../../core/services/profile_cache_service.dart';
import '../../../../data/repositories/auth_local_repository.dart';
import '../../models/profile_data_response.dart';
import '../../models/update_profile_request.dart';
import '../../models/update_profile_response.dart';
import '../../models/update_password_request.dart';
import '../../models/update_password_response.dart';
import '../../models/delete_account_request.dart';
import '../../models/delete_account_response.dart';
import '../../repository/profile_repository.dart';
import '../mixins/profile_error_handler_mixin.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// Profile Bloc
/// Manages profile state and business logic using Bloc pattern with AsyncRunner
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> with ProfileErrorHandlerMixin {
  final AsyncRunner<ProfileDataResponse> loadProfileRunner = AsyncRunner<ProfileDataResponse>();
  final AsyncRunner<UpdateProfileResponse> updateProfileRunner = AsyncRunner<UpdateProfileResponse>();
  final AsyncRunner<UpdatePasswordResponse> updatePasswordRunner = AsyncRunner<UpdatePasswordResponse>();
  final AsyncRunner<DeleteAccountResponse> deleteAccountRunner = AsyncRunner<DeleteAccountResponse>();

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdatePassword>(_onUpdatePassword);
    on<DeleteAccount>(_onDeleteAccount);
    on<UpdateProfileField>(_onUpdateProfileField);
    on<ResetProfileState>(_onResetProfileState);
  }

  /// Load user profile data
  /// First loads from cache for instant display, then fetches from API
  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // Load cached profile first for instant display
    final cachedProfile = ProfileCacheService.getCachedProfile();
    if (cachedProfile != null && !emit.isDone) {
      emit(ProfileLoaded(profileData: cachedProfile));
    } else {
      emit(ProfileLoading());
    }

    await loadProfileRunner.run(
      onlineTask: (previousResult) async {
        final profileResponse = await ProfileRepository.getProfile();
        // Cache the profile data for future instant loading
        await ProfileCacheService.saveProfile(profileResponse);
        return profileResponse;
      },
      onSuccess: (profileResponse) async {
        if (!emit.isDone) {
          emit(ProfileLoaded(profileData: profileResponse));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleError(error, emit);
        }
      },
    );
  }

  /// Update profile information
  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // Capture current profile data before update attempt
    final previousProfileData = state is ProfileLoaded
        ? (state as ProfileLoaded).profileData
        : ProfileCacheService.getCachedProfile();

    // Validate request locally first
    final validationErrors = event.request.validate();
    if (validationErrors.isNotEmpty) {
      emit(ProfileFailure(
        error: validationErrors.join('\n'),
        statusCode: 422,
        updateRequest: event.request,
        profileData: previousProfileData,
      ));
      return;
    }

    emit(ProfileLoading(updateRequest: event.request));

    await updateProfileRunner.run(
      onlineTask: (previousResult) async {
        final updateResponse = await ProfileRepository.updateProfile(
          updateRequest: event.request,
        );
        
        // Update local user data
        final userJson = updateResponse.user.toJson();
        await AuthLocalRepository.saveUser(userJson);
        
        return updateResponse;
      },
      onSuccess: (updateResponse) async {
        if (!emit.isDone) {
          // Reload profile to get updated data
          final profileResponse = await ProfileRepository.getProfile();
          // Update cache with new profile data
          await ProfileCacheService.saveProfile(profileResponse);
          emit(ProfileUpdateSuccess(
            message: updateResponse.message,
            profileData: profileResponse,
          ));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleError(
            error,
            emit,
            updateRequest: event.request,
            profileData: previousProfileData,
          );
        }
      },
    );
  }

  /// Update password
  Future<void> _onUpdatePassword(
    UpdatePassword event,
    Emitter<ProfileState> emit,
  ) async {
    // Validate request locally first
    final validationErrors = event.request.validate();
    if (validationErrors.isNotEmpty) {
      emit(ProfileFailure(
        error: validationErrors.join('\n'),
        statusCode: 422,
      ));
      return;
    }

    emit(ProfileLoading());

    await updatePasswordRunner.run(
      onlineTask: (previousResult) async {
        final updateResponse = await ProfileRepository.updatePassword(
          updateRequest: event.request,
        );
        
        // Password update invalidates all tokens, so clear auth data
        // User will need to login again
        await AuthLocalRepository.clearAuthData();
        
        return updateResponse;
      },
      onSuccess: (updateResponse) async {
        if (!emit.isDone) {
          emit(PasswordUpdateSuccess(message: updateResponse.message));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleError(error, emit);
        }
      },
    );
  }

  /// Delete account
  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    // Validate request locally first
    final validationErrors = event.request.validate();
    if (validationErrors.isNotEmpty) {
      emit(ProfileFailure(
        error: validationErrors.join('\n'),
        statusCode: 422,
      ));
      return;
    }

    emit(ProfileLoading());

    await deleteAccountRunner.run(
      onlineTask: (previousResult) async {
        final deleteResponse = await ProfileRepository.deleteAccount(
          deleteRequest: event.request,
        );
        
        // Clear auth data after account deletion
        await AuthLocalRepository.clearAuthData();
        
        return deleteResponse;
      },
      onSuccess: (deleteResponse) async {
        if (!emit.isDone) {
          emit(AccountDeleteSuccess(message: deleteResponse.message));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleError(error, emit);
        }
      },
    );
  }

  /// Update profile fields in the request
  void _onUpdateProfileField(
    UpdateProfileField event,
    Emitter<ProfileState> emit,
  ) {
    UpdateProfileRequest? currentRequest;
    
    if (state is ProfileLoaded) {
      final profileData = (state as ProfileLoaded).profileData.data;
      currentRequest = UpdateProfileRequest(
        fullName: profileData.fullName,
        email: profileData.email,
        phone: profileData.phone,
      );
    } else if (state is ProfileInitial) {
      currentRequest = (state as ProfileInitial).updateRequest;
    } else if (state is ProfileLoading) {
      currentRequest = (state as ProfileLoading).updateRequest;
    } else if (state is ProfileFailure) {
      currentRequest = (state as ProfileFailure).updateRequest;
    }

    final updatedRequest = (currentRequest ?? UpdateProfileRequest(
      fullName: '',
      email: '',
      phone: '',
    )).copyWith(
      fullName: event.fullName,
      email: event.email,
      phone: event.phone,
    );

    if (state is ProfileLoaded) {
      emit(ProfileLoaded(
        profileData: (state as ProfileLoaded).profileData,
        updateRequest: updatedRequest,
      ));
    } else {
      emit(ProfileInitial(updateRequest: updatedRequest));
    }
  }

  /// Reset profile state
  void _onResetProfileState(
    ResetProfileState event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      emit(ProfileLoaded(profileData: (state as ProfileLoaded).profileData));
    } else if (state is ProfileFailure &&
        (state as ProfileFailure).profileData != null) {
      emit(ProfileLoaded(
          profileData: (state as ProfileFailure).profileData!));
    } else {
      emit(ProfileInitial());
    }
  }
}


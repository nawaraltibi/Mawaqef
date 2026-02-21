part of 'profile_bloc.dart';

/// Base class for profile states
abstract class ProfileState {}

/// Initial state with empty request
class ProfileInitial extends ProfileState {
  final UpdateProfileRequest? updateRequest;

  ProfileInitial({this.updateRequest});
}

/// Loading state - profile operation in progress
class ProfileLoading extends ProfileState {
  final UpdateProfileRequest? updateRequest;

  ProfileLoading({this.updateRequest});
}

/// Loaded state - profile data loaded successfully
class ProfileLoaded extends ProfileState {
  final ProfileDataResponse profileData;
  final UpdateProfileRequest? updateRequest;

  ProfileLoaded({
    required this.profileData,
    this.updateRequest,
  });
}

/// Update success state - profile updated successfully
class ProfileUpdateSuccess extends ProfileState {
  final String message;
  final ProfileDataResponse? profileData;

  ProfileUpdateSuccess({
    required this.message,
    this.profileData,
  });
}

/// Password update success state
class PasswordUpdateSuccess extends ProfileState {
  final String message;

  PasswordUpdateSuccess({required this.message});
}

/// Account deletion success state
class AccountDeleteSuccess extends ProfileState {
  final String message;

  AccountDeleteSuccess({required this.message});
}

/// Failure state - profile operation failed
class ProfileFailure extends ProfileState {
  final String error;
  final int statusCode;
  final UpdateProfileRequest? updateRequest;
  final ProfileDataResponse? profileData;

  ProfileFailure({
    required this.error,
    required this.statusCode,
    this.updateRequest,
    this.profileData,
  });
}


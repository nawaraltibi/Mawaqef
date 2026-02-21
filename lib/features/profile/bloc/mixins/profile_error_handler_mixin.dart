import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/profile_data_response.dart';
import '../../models/update_profile_request.dart';
import '../profile/profile_bloc.dart';

/// Mixin for handling errors in profile bloc
/// Note: This mixin must be used with a Bloc<ProfileEvent, ProfileState>
mixin ProfileErrorHandlerMixin on Bloc<ProfileEvent, ProfileState> {
  /// Handle error and emit failure state
  void handleError(
    Object error,
    Emitter<ProfileState> emit, {
    UpdateProfileRequest? updateRequest,
    ProfileDataResponse? profileData,
  }) {
    String errorMessage = '';
    int statusCode = 500;

    if (error is AppException) {
      errorMessage = error.message;
      statusCode = error.statusCode;

      if (error.errors != null && error.errors!.isNotEmpty) {
        final errorList = <String>[];
        error.errors!.forEach((key, value) {
          errorList.addAll(value);
        });
        if (errorList.isNotEmpty) {
          errorMessage = errorList.join('\n');
        }
      }
    } else {
      errorMessage = error.toString();
    }

    emit(ProfileFailure(
      error: errorMessage,
      statusCode: statusCode,
      updateRequest: updateRequest,
      profileData: profileData,
    ));
  }
}


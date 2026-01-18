import '../models/register_request.dart';
import '../models/register_response.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/logout_response.dart';
import '../../../core/utils/app_exception.dart';
import '../../../data/datasources/network/api_request.dart';

/// Auth Repository
/// Handles all authentication-related API calls
class AuthRepository {
  /// Register a new user
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 422: Validation errors (duplicate email, password mismatch, etc.)
  /// - 500: Server errors
  static Future<RegisterResponse> register({
    required RegisterRequest registerRequest,
  }) async {
    final request = APIRequest(
      path: '/register',
      method: HTTPMethod.post,
      body: registerRequest.toJson(),
      authorizationOption: AuthorizationOption.unauthorized,
    );

    try {
      final response = await request.send();
      
      // DioProvider returns Response object, extract data
      final responseData = response.data;
      
      // Handle successful response (201 Created)
      if (response.statusCode == 201 && responseData is Map<String, dynamic>) {
        return RegisterResponse.fromJson(responseData);
      }
      
      // If we get here, something unexpected happened
      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException {
      // Re-throw AppException as-is (it contains proper error details)
      rethrow;
    } catch (e) {
      // Wrap unexpected errors
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  /// Login user
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Invalid credentials
  /// - 422: Validation errors (missing fields, invalid email)
  /// - 500: Server errors
  static Future<LoginResponse> login({
    required LoginRequest loginRequest,
  }) async {
    final request = APIRequest(
      path: '/login',
      method: HTTPMethod.post,
      body: loginRequest.toJson(),
      authorizationOption: AuthorizationOption.unauthorized,
    );

    try {
      final response = await request.send();
      
      // DioProvider returns Response object, extract data
      final responseData = response.data;
      
      // Handle successful response (200 OK)
      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return LoginResponse.fromJson(responseData);
      }
      
      // If we get here, something unexpected happened
      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException {
      // Re-throw AppException as-is (it contains proper error details)
      rethrow;
    } catch (e) {
      // Wrap unexpected errors
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  /// Logout user
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Missing or invalid token (Unauthenticated)
  /// - 500: Server errors
  /// 
  /// Note: Token is automatically retrieved from AuthLocalRepository
  /// and included in Authorization header via APIRequest
  static Future<LogoutResponse> logout() async {
    final request = APIRequest(
      path: '/logout',
      method: HTTPMethod.post,
      body: null, // No body required for logout
      authorizationOption: AuthorizationOption.authorized, // Requires token
    );

    try {
      final response = await request.send();
      
      // DioProvider returns Response object, extract data
      final responseData = response.data;
      
      // Handle successful response (200 OK)
      if (response.statusCode == 200 && responseData is Map<String, dynamic>) {
        return LogoutResponse.fromJson(responseData);
      }
      
      // If we get here, something unexpected happened
      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException catch (e) {
      // Re-throw AppException as-is (it contains proper error details)
      // Handle 401 specifically (Unauthenticated)
      if (e.statusCode == 401) {
        throw AppException(
          statusCode: 401,
          errorCode: 'unauthenticated',
          message: 'Unauthenticated.',
        );
      }
      rethrow;
    } catch (e) {
      // Wrap unexpected errors
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }
}


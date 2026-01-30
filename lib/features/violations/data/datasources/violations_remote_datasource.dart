import '../models/unpaid_violations_response.dart';
import '../models/paid_violations_response.dart';
import '../models/pay_violation_request.dart';
import '../models/pay_violation_response.dart';
import '../../../../core/utils/app_exception.dart';
import '../../../../data/datasources/network/api_request.dart';

/// Violations Remote Data Source
/// Handles all remote API calls for violations
class ViolationsRemoteDataSource {
  /// Get all unpaid violations for the authenticated user
  /// 
  /// GET /api/violation/allunpaid
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<UnpaidViolationsResponse> getUnpaidViolations() async {
    final request = APIRequest(
      path: '/violation/allunpaid',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return UnpaidViolationsResponse.fromJson(responseData);
      }

      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  /// Get paid violations for the authenticated user
  /// 
  /// GET /api/violation/allpaid
  /// 
  /// Returns last 10 paid violations.
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<PaidViolationsResponse> getPaidViolations() async {
    final request = APIRequest(
      path: '/violation/allpaid',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return PaidViolationsResponse.fromJson(responseData);
      }

      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  /// Pay a violation
  /// 
  /// POST /api/violation/payviolation/:violationId
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 404: Violation not found or doesn't belong to user
  /// - 409: Violation already paid
  /// - 422: Validation errors (invalid payment_method, etc.)
  /// - 500: Server errors
  Future<PayViolationResponse> payViolation({
    required int violationId,
    required PayViolationRequest payRequest,
  }) async {
    final request = APIRequest(
      path: '/violation/payviolation/$violationId',
      method: HTTPMethod.post,
      body: payRequest.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return PayViolationResponse.fromJson(responseData);
      }

      throw Exception('Unexpected response status: ${response.statusCode}');
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }
}



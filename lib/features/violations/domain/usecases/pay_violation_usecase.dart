import '../entities/violation_entity.dart';
import '../repositories/violations_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Pay Violation Use Case
/// Business logic for paying a violation
class PayViolationUseCase {
  final ViolationsRepository repository;

  PayViolationUseCase(this.repository);

  /// Execute the use case
  /// 
  /// [violationId] - The ID of the violation to pay
  /// [paymentMethod] - The payment method (e.g., 'cash', 'card')
  /// 
  /// Returns the updated ViolationEntity after payment.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 404: Violation not found or doesn't belong to user
  /// - 409: Violation already paid
  /// - 422: Validation errors (invalid payment_method, etc.)
  /// - 500: Server errors
  Future<ViolationEntity> call({
    required int violationId,
    required String paymentMethod,
  }) async {
    try {
      return await repository.payViolation(
        violationId: violationId,
        paymentMethod: paymentMethod,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to pay violation: ${e.toString()}',
      );
    }
  }
}



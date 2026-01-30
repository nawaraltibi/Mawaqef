import '../entities/violation_entity.dart';

/// Violations Repository Interface
/// Abstract repository for violation operations
/// 
/// This is part of the domain layer and should not depend on:
/// - Flutter framework
/// - Data layer implementations
/// - External libraries (except core utilities)
abstract class ViolationsRepository {
  /// Get all unpaid violations for the authenticated user
  /// 
  /// Returns a list of ViolationEntity objects with parking lot and vehicle information.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<List<ViolationEntity>> getUnpaidViolations();

  /// Get paid violations for the authenticated user
  /// 
  /// Returns the last 10 paid violations.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<List<ViolationEntity>> getPaidViolations();

  /// Pay a violation
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
  Future<ViolationEntity> payViolation({
    required int violationId,
    required String paymentMethod,
  });
}



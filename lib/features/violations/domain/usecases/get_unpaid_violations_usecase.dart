import '../entities/violation_entity.dart';
import '../repositories/violations_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Get Unpaid Violations Use Case
/// Business logic for retrieving unpaid violations
class GetUnpaidViolationsUseCase {
  final ViolationsRepository repository;

  GetUnpaidViolationsUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Returns a list of ViolationEntity objects for unpaid violations.
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<List<ViolationEntity>> call() async {
    try {
      return await repository.getUnpaidViolations();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to get unpaid violations: ${e.toString()}',
      );
    }
  }
}



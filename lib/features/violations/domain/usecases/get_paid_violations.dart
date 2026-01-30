import '../entities/violation_entity.dart';
import '../repositories/violations_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Get Paid Violations Use Case
/// Business logic for retrieving paid violations
class GetPaidViolationsUseCase {
  final ViolationsRepository repository;

  GetPaidViolationsUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Returns a list of ViolationEntity objects for paid violations (last 10).
  /// 
  /// Throws AppException on error:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<List<ViolationEntity>> call() async {
    try {
      return await repository.getPaidViolations();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to get paid violations: ${e.toString()}',
      );
    }
  }
}



import 'violation_model.dart';

/// Unpaid Violations Response
/// Response model for GET /api/violation/allunpaid
class UnpaidViolationsResponse {
  final List<ViolationModel> violations;
  final String? message;

  const UnpaidViolationsResponse({
    required this.violations,
    this.message,
  });

  factory UnpaidViolationsResponse.fromJson(Map<String, dynamic> json) {
    final violationsList = json['violations'] ?? json['data'] ?? [];
    
    return UnpaidViolationsResponse(
      violations: (violationsList as List)
          .map((item) => ViolationModel.fromJson(
                item is Map<String, dynamic> ? item : {},
              ))
          .toList(),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'violations': violations.map((v) => v.toJson()).toList(),
      'message': message,
    };
  }
}



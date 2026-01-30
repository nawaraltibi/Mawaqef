import 'violation_model.dart';

/// Paid Violations Response
/// Response model for GET /api/violation/allpaid
class PaidViolationsResponse {
  final List<ViolationModel> violations;
  final String? message;

  const PaidViolationsResponse({
    required this.violations,
    this.message,
  });

  factory PaidViolationsResponse.fromJson(Map<String, dynamic> json) {
    final violationsList = json['violations'] ?? json['data'] ?? [];
    
    return PaidViolationsResponse(
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



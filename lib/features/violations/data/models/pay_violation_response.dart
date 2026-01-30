import 'violation_model.dart';

/// Pay Violation Response
/// Response model for POST /api/violation/payviolation/:violationId
class PayViolationResponse {
  final ViolationModel violation;
  final String? message;

  const PayViolationResponse({
    required this.violation,
    this.message,
  });

  factory PayViolationResponse.fromJson(Map<String, dynamic> json) {
    return PayViolationResponse(
      violation: ViolationModel.fromJson(
        json['violation'] ?? json['data'] ?? {},
      ),
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'violation': violation.toJson(),
      'message': message,
    };
  }
}



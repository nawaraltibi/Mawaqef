/// Pay Violation Request
/// Request model for POST /api/violation/payviolation/:violationId
class PayViolationRequest {
  final String paymentMethod;

  const PayViolationRequest({
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'payment_method': paymentMethod,
    };
  }
}



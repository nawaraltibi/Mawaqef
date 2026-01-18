/// Logout Response Model
/// Response from logout API
class LogoutResponse {
  final String message;

  LogoutResponse({
    required this.message,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      message: json['message'] as String? ?? 'Logged out successfully',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}


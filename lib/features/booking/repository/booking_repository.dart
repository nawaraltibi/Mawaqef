import '../../../core/utils/app_exception.dart';
import '../../../data/datasources/network/api_request.dart';
import '../../../data/datasources/network/api_config.dart';
import '../../../data/datasources/network/dio_provider.dart';
import '../models/booking_details_response.dart';
import '../models/bookings_list_response.dart';
import '../models/cancel_booking_response.dart';
import '../models/create_booking_request.dart';
import '../models/create_booking_response.dart';
import '../models/extend_booking_request.dart';
import '../models/extend_booking_response.dart';
import '../models/payment_request.dart';
import '../models/payment_response.dart';
import '../models/payments_list_response.dart';
import '../models/remaining_time_response.dart';

/// Booking Repository
/// Handles all booking-related API calls
/// 
/// All methods throw AppException on error with appropriate status codes:
/// - 401: Unauthenticated (missing or invalid token)
/// - 404: Resource not found (booking doesn't exist or doesn't belong to user)
/// - 422: Validation errors (invalid input, missing required fields)
/// - 409: Conflict (already cancelled, cannot cancel, etc.)
/// - 500: Server errors
class BookingRepository {
  /// Helper method to handle API response
  static T _handleResponse<T>(
    dynamic response,
    T Function(Map<String, dynamic>) fromJson,
    int expectedStatusCode,
  ) {
    final responseData = response.data;

    if (response.statusCode == expectedStatusCode && 
        responseData is Map<String, dynamic>) {
      return fromJson(responseData);
    }

    throw Exception('Unexpected response status: ${response.statusCode}');
  }

  /// Helper method to handle errors
  static Never _handleError(dynamic error) {
    if (error is AppException) {
      throw error;
    }
    throw AppException(
      statusCode: 500,
      errorCode: 'unexpected-error',
      message: error.toString(),
    );
  }
  
  /// Create a new parking booking
  /// 
  /// POST /api/booking/park
  /// 
  /// Creates a booking with 'pending' status. Payment is required to activate.
  /// 
  /// Throws:
  /// - 403: Vehicle not owned by user, parking lot unavailable, lot is full
  /// - 409: Duplicate booking with same details
  /// - 422: Validation errors (invalid lot_id, vehicle_id, or hours)
  static Future<CreateBookingResponse> createBooking({
    required CreateBookingRequest request,
  }) async {
    final apiRequest = APIRequest(
      path: '/booking/park',
      method: HTTPMethod.post,
      body: request.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await apiRequest.send();
      return _handleResponse(
        response,
        CreateBookingResponse.fromJson,
        201,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Cancel an existing booking
  /// 
  /// POST /api/booking/{bookingId}/cancel
  /// 
  /// Only pending or active bookings can be cancelled.
  /// Booking status will be changed to 'inactive'.
  /// 
  /// Throws:
  /// - 404: Booking not found or doesn't belong to user
  /// - 409: Booking already cancelled or cannot be cancelled
  static Future<CancelBookingResponse> cancelBooking({
    required int bookingId,
  }) async {
    final apiRequest = APIRequest(
      path: '/booking/$bookingId/cancel',
      method: HTTPMethod.post,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await apiRequest.send();
      return _handleResponse(
        response,
        CancelBookingResponse.fromJson,
        200,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Request booking extension
  /// 
  /// POST /api/booking/extendbooking/{bookingId}
  /// 
  /// Adds extra hours to pending_extra_hours field.
  /// Payment required to apply the extension.
  /// Only works for active (paid) bookings.
  /// 
  /// Throws:
  /// - 404: Booking not found or doesn't belong to user
  /// - 400: Booking is not active (must be paid first)
  /// - 422: Validation errors (invalid extra_hours)
  static Future<ExtendBookingResponse> extendBooking({
    required int bookingId,
    required ExtendBookingRequest request,
  }) async {
    final apiRequest = APIRequest(
      path: '/booking/extendbooking/$bookingId',
      method: HTTPMethod.post,
      body: request.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await apiRequest.send();
      return _handleResponse(
        response,
        ExtendBookingResponse.fromJson,
        200,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Process payment success
  /// 
  /// POST /api/booking/paymentsuccess/{bookingId}
  /// 
  /// Activates pending booking or applies extension.
  /// Creates a payment record with 'success' status.
  /// 
  /// Throws:
  /// - 404: Booking not found or doesn't belong to user
  /// - 422: Validation errors (invalid amount or payment_method)
  static Future<PaymentResponse> processPaymentSuccess({
    required int bookingId,
    required PaymentRequest request,
  }) async {
    final apiRequest = APIRequest(
      path: '/booking/paymentsuccess/$bookingId',
      method: HTTPMethod.post,
      body: request.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await apiRequest.send();
      return _handleResponse(
        response,
        PaymentResponse.fromJson,
        200,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Process payment failure
  /// 
  /// POST /api/booking/paymentfailed/{bookingId}
  /// 
  /// Records a failed payment attempt.
  /// Booking remains unchanged (still pending or active).
  /// 
  /// Throws:
  /// - 404: Booking not found or doesn't belong to user
  /// - 422: Validation errors
  static Future<PaymentResponse> processPaymentFailure({
    required int bookingId,
    required PaymentRequest request,
  }) async {
    final apiRequest = APIRequest(
      path: '/booking/paymentfailed/$bookingId',
      method: HTTPMethod.post,
      body: request.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await apiRequest.send();
      return _handleResponse(
        response,
        PaymentResponse.fromJson,
        200,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Get active bookings
  /// 
  /// GET /api/booking/active
  /// 
  /// Returns all bookings that are active OR pending AND not yet expired.
  /// Includes parking lot information via eager loading.
  /// Limited to 10 bookings, ordered by start_time ascending.
  /// 
  /// Throws:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  static Future<BookingsListResponse> getActiveBookings() async {
    final apiRequest = APIRequest(
      path: '/booking/active',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await apiRequest.send();
      return _handleResponse(
        response,
        BookingsListResponse.fromJson,
        200,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Get finished bookings
  /// 
  /// GET /api/booking/finished
  /// 
  /// Returns last 15 finished bookings (inactive or expired).
  /// Includes parking lot information via eager loading.
  /// Ordered by end_time descending (most recent first).
  /// 
  /// Throws:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  static Future<BookingsListResponse> getFinishedBookings() async {
    final apiRequest = APIRequest(
      path: '/booking/finished',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await apiRequest.send();
      return _handleResponse(
        response,
        BookingsListResponse.fromJson,
        200,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Get booking details
  /// 
  /// GET /api/booking/getdetails/{bookingId}
  /// 
  /// Returns detailed information about a specific booking.
  /// Includes parking lot and vehicle information via eager loading.
  /// 
  /// Throws:
  /// - 404: Booking not found or doesn't belong to user
  /// - 401: Unauthenticated
  static Future<BookingDetailsResponse> getBookingDetails({
    required int bookingId,
  }) async {
    final apiRequest = APIRequest(
      path: '/booking/getdetails/$bookingId',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await apiRequest.send();
      return _handleResponse(
        response,
        BookingDetailsResponse.fromJson,
        200,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Get remaining time for a booking
  /// 
  /// GET /api/booking/remainingtime/{bookingId}
  /// 
  /// Returns remaining time for an active booking.
  /// Includes warning if less than 10 minutes remaining.
  /// 
  /// Throws:
  /// - 404: Booking not found, inactive, or doesn't belong to user
  /// - 401: Unauthenticated
  static Future<RemainingTimeResponse> getRemainingTime({
    required int bookingId,
  }) async {
    final apiRequest = APIRequest(
      path: '/booking/remainingtime/$bookingId',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await apiRequest.send();
      return _handleResponse(
        response,
        RemainingTimeResponse.fromJson,
        200,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Get last 5 payments
  /// 
  /// GET /api/booking/allpayments
  /// 
  /// Returns last 5 payment records for authenticated user.
  /// Includes related booking information via eager loading.
  /// Ordered by created_at descending (most recent first).
  /// 
  /// Throws:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  static Future<PaymentsListResponse> getPaymentHistory() async {
    final apiRequest = APIRequest(
      path: '/booking/allpayments',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await apiRequest.send();
      return _handleResponse(
        response,
        PaymentsListResponse.fromJson,
        200,
      );
    } catch (e) {
      _handleError(e);
    }
  }

  /// Get booking PDF
  /// 
  /// GET /api/booking/printbookingPdf/{bookingId}
  /// 
  /// Returns booking invoice as PDF stream.
  /// 
  /// Note: This endpoint returns a PDF file, not JSON.
  /// You'll need to handle the response differently using DioProvider's download feature.
  /// 
  /// Throws:
  /// - 404: Booking not found or doesn't belong to user
  /// - 401: Unauthenticated
  /// 
  /// Example usage:
  /// ```dart
  /// final savePath = await getApplicationDocumentsDirectory();
  /// final filePath = '${savePath.path}/booking_$bookingId.pdf';
  /// await downloadBookingPdf(bookingId: bookingId, savePath: filePath);
  /// ```
  /// Get PDF URL for viewing in WebView
  /// Returns the full URL to the PDF endpoint
  static String getBookingPdfUrl(int bookingId) {
    return '${APIConfig.appAPI}/booking/printbookingPdf/$bookingId';
  }

  static Future<void> downloadBookingPdf({
    required int bookingId,
    required String savePath,
    Function(int received, int total)? onProgress,
  }) async {
    final fileUrl = '${APIConfig.appAPI}/booking/printbookingPdf/$bookingId';
    
    try {
      await DioProvider.instance.downloadFile(
        fileUrl,
        savePath,
        onProgress: onProgress,
        headers: {
          'Accept': 'application/pdf',
        },
      );
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


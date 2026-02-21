import '../models/parking_lots_response.dart';
import '../models/parking_details_response.dart';
import '../../../../core/utils/app_exception.dart';
import '../../../../data/datasources/network/api_request.dart';

/// Parking Map Remote Data Source
/// Handles all remote API calls for parking map feature
class ParkingMapRemoteDataSource {
  /// Get all parking lots for map display
  /// 
  /// GET /api/allparkinginthemap
  /// 
  /// This endpoint is public and does not require authentication.
  /// Returns parking lots with location data and available spaces.
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 500: Server errors
  /// - Network errors
  Future<ParkingLotsResponse> getAllParkingLots() async {
    final request = APIRequest(
      path: '/allparkinginthemap',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.unauthorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      // Handle successful response (200 OK or 201 Created)
      if ((response.statusCode == 200 || response.statusCode == 201)) {
        // Handle both Map and List responses
        if (responseData is Map<String, dynamic>) {
          return ParkingLotsResponse.fromJson(responseData);
        } else if (responseData is List) {
          // If response is directly a list, wrap it
          return ParkingLotsResponse.fromJson({
            'data': responseData,
          });
        } else {
          throw AppException(
            statusCode: 500,
            errorCode: 'invalid-response-format',
            message: 'Unexpected response format: ${responseData.runtimeType}',
          );
        }
      }

      throw AppException(
        statusCode: response.statusCode ?? 500,
        errorCode: 'unexpected-status',
        message: 'Unexpected response status: ${response.statusCode}',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to get parking lots: ${e.toString()}',
      );
    }
  }

  /// Get parking details by ID
  /// 
  /// GET /api/parking/{id}
  /// 
  /// This endpoint is public and does not require authentication.
  /// Returns detailed information about a specific parking lot.
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 404: Parking lot not found
  /// - 500: Server errors
  /// - Network errors
  Future<ParkingDetailsResponse> getParkingDetails({
    required int lotId,
  }) async {
    final request = APIRequest(
      path: '/parking/$lotId',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.unauthorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      // Handle successful response (200 OK or 201 Created)
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData is Map<String, dynamic>) {
        return ParkingDetailsResponse.fromJson(responseData);
      }

      // Handle 404 Not Found
      if (response.statusCode == 404) {
        throw AppException(
          statusCode: 404,
          errorCode: 'parking-not-found',
          message: 'Parking lot with ID $lotId not found',
        );
      }

      throw AppException(
        statusCode: response.statusCode ?? 500,
        errorCode: 'unexpected-status',
        message: 'Unexpected response status: ${response.statusCode}',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to get parking details: ${e.toString()}',
      );
    }
  }

  /// Search nearby parking lots within a radius
  /// 
  /// GET /api/searchparking?latitude={lat}&longitude={lng}&radius={radiusKm}
  /// 
  /// This endpoint requires authentication (Bearer token).
  /// Returns parking lots within the specified radius from the given coordinates.
  /// Backend now also filters out fully occupied parking lots (available_spaces == 0).
  /// 
  /// Parameters:
  /// - [latitude]: User's current latitude
  /// - [longitude]: User's current longitude
  /// - [radiusKm]: Search radius in kilometers
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated (missing or invalid token)
  /// - 500: Server errors
  /// - Network errors
  Future<ParkingLotsResponse> searchNearbyParking({
    required double latitude,
    required double longitude,
    required int radiusKm,
  }) async {
    final request = APIRequest(
      path: '/searchparking', // Fixed typo: was '/searshparking'
      method: HTTPMethod.get,
      body: null,
      query: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'radius': radiusKm.toString(),
      },
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      // Handle successful response (200 OK or 201 Created)
      if ((response.statusCode == 200 || response.statusCode == 201)) {
        // Handle both Map and List responses
        if (responseData is Map<String, dynamic>) {
          return ParkingLotsResponse.fromJson(responseData);
        } else if (responseData is List) {
          // If response is directly a list, wrap it
          return ParkingLotsResponse.fromJson({
            'data': responseData,
          });
        } else {
          throw AppException(
            statusCode: 500,
            errorCode: 'invalid-response-format',
            message: 'Unexpected response format: ${responseData.runtimeType}',
          );
        }
      }

      throw AppException(
        statusCode: response.statusCode ?? 500,
        errorCode: 'unexpected-status',
        message: 'Unexpected response status: ${response.statusCode}',
      );
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to search nearby parking: ${e.toString()}',
      );
    }
  }
}


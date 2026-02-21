import '../models/add_vehicle_request.dart';
import '../models/add_vehicle_response.dart';
import '../models/update_vehicle_request.dart';
import '../models/update_vehicle_response.dart';
import '../models/vehicles_list_response.dart';
import '../models/delete_vehicle_response.dart';
import '../../../../core/utils/app_exception.dart';
import '../../../../data/datasources/network/api_request.dart';

/// Vehicles Remote Data Source
/// Handles all remote API calls for vehicles
class VehiclesRemoteDataSource {
  /// Get all vehicles for the authenticated user
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 500: Server errors
  Future<VehiclesListResponse> getVehicles() async {
    final request = APIRequest(
      path: '/vehicle/vehicles',
      method: HTTPMethod.get,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      // Backend returns 201 for GET requests (non-standard, but we handle it)
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseData is Map<String, dynamic>) {
        return VehiclesListResponse.fromJson(responseData);
      }

      throw Exception('Unexpected response status: ${response.statusCode}');
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

  /// Add a new vehicle
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 422: Validation errors (duplicate plat_number, missing fields, etc.)
  /// - 500: Server errors
  Future<AddVehicleResponse> addVehicle({
    required AddVehicleRequest addRequest,
  }) async {
    final request = APIRequest(
      path: '/vehicle/create',
      method: HTTPMethod.post,
      body: addRequest.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      // Handle successful response (201 Created)
      if (response.statusCode == 201 &&
          responseData is Map<String, dynamic>) {
        return AddVehicleResponse.fromJson(responseData);
      }

      throw Exception('Unexpected response status: ${response.statusCode}');
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

  /// Update a vehicle
  /// 
  /// Note: This creates a modification request that requires admin approval.
  /// The vehicle is not updated immediately.
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 403: Vehicle is blocked
  /// - 404: Vehicle not found or doesn't belong to user
  /// - 422: Validation errors (duplicate plat_number, no changes, etc.)
  /// - 500: Server errors
  Future<UpdateVehicleResponse> updateVehicle({
    required int vehicleId,
    required UpdateVehicleRequest updateRequest,
  }) async {
    final request = APIRequest(
      path: '/vehicle/update/$vehicleId',
      method: HTTPMethod.put,
      body: updateRequest.toJson(),
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      // Handle successful response (200 OK)
      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return UpdateVehicleResponse.fromJson(responseData);
      }

      throw Exception('Unexpected response status: ${response.statusCode}');
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

  /// Delete a vehicle
  /// 
  /// Throws AppException on error with appropriate status codes:
  /// - 401: Unauthenticated
  /// - 404: Vehicle not found or doesn't belong to user
  /// - 409: Vehicle has active bookings
  /// - 500: Server errors
  Future<DeleteVehicleResponse> deleteVehicle({
    required int vehicleId,
  }) async {
    final request = APIRequest(
      path: '/vehicle/$vehicleId',
      method: HTTPMethod.delete,
      body: null,
      authorizationOption: AuthorizationOption.authorized,
    );

    try {
      final response = await request.send();
      final responseData = response.data;

      // Handle successful response (200 OK)
      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic>) {
        return DeleteVehicleResponse.fromJson(responseData);
      }

      throw Exception('Unexpected response status: ${response.statusCode}');
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

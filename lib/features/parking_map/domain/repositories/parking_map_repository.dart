import '../entities/parking_lot_entity.dart';
import '../entities/parking_details_entity.dart';

/// Parking Map Repository Interface
/// Abstract repository for parking map operations
/// 
/// This is part of the domain layer and should not depend on:
/// - Flutter framework
/// - Data layer implementations
/// - External libraries (except core utilities)
abstract class ParkingMapRepository {
  /// Get all parking lots for map display
  /// 
  /// Returns a list of ParkingLotEntity objects with location data.
  /// This endpoint is public and does not require authentication.
  /// 
  /// Throws AppException on error:
  /// - 500: Server errors
  /// - Network errors
  Future<List<ParkingLotEntity>> getAllParkingLots();

  /// Get parking details by ID
  /// 
  /// Returns detailed ParkingDetailsEntity for the specified parking lot.
  /// This endpoint is public and does not require authentication.
  /// 
  /// Throws AppException on error:
  /// - 404: Parking lot not found
  /// - 500: Server errors
  /// - Network errors
  Future<ParkingDetailsEntity> getParkingDetails({
    required int lotId,
  });

  /// Search nearby parking lots within a radius
  /// 
  /// Returns a list of ParkingLotEntity objects within the specified radius.
  /// Only returns parking lots with available spaces > 0.
  /// This endpoint is public and does not require authentication.
  /// 
  /// Parameters:
  /// - [latitude]: User's current latitude
  /// - [longitude]: User's current longitude
  /// - [radiusKm]: Search radius in kilometers
  /// 
  /// Throws AppException on error:
  /// - 500: Server errors
  /// - Network errors
  Future<List<ParkingLotEntity>> searchNearbyParking({
    required double latitude,
    required double longitude,
    required double radiusKm,
  });
}


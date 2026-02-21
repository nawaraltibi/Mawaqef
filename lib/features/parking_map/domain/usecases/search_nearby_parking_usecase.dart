import '../entities/parking_lot_entity.dart';
import '../repositories/parking_map_repository.dart';
import '../../../../core/utils/app_exception.dart';

/// Search Nearby Parking Use Case
/// Business logic for searching parking lots near a specific location
class SearchNearbyParkingUseCase {
  final ParkingMapRepository repository;

  /// Default search radius in kilometers
  static const double defaultRadiusKm = 5.0;

  SearchNearbyParkingUseCase(this.repository);

  /// Execute the use case
  /// 
  /// Returns a list of ParkingLotEntity objects within the specified radius.
  /// Only returns parking lots with available spaces > 0.
  /// 
  /// Parameters:
  /// - [latitude]: User's current latitude
  /// - [longitude]: User's current longitude
  /// - [radiusKm]: Search radius in kilometers (default: 5 KM)
  /// 
  /// Throws AppException on error:
  /// - 500: Server errors
  /// - Network errors
  Future<List<ParkingLotEntity>> call({
    required double latitude,
    required double longitude,
    double radiusKm = defaultRadiusKm,
  }) async {
    try {
      final parkingLots = await repository.searchNearbyParking(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
      );
      
      // Filter out parking lots with no available spaces
      // (Backend should already do this, but we ensure it here as well)
      return parkingLots
          .where((lot) => lot.hasAvailableSpaces)
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: 'Failed to search nearby parking: ${e.toString()}',
      );
    }
  }
}

import 'package:geolocator/geolocator.dart';
import '../utils/app_exception.dart';
import 'location_entity.dart';
import 'location_repository.dart';

/// Location Service Implementation
/// Handles location operations using geolocator package
class LocationService implements LocationRepository {
  @override
  Future<LocationEntity> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw AppException(
          statusCode: 503,
          errorCode: 'location-services-disabled',
          message: 'Location services are disabled. Please enable location services.',
        );
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw AppException(
            statusCode: 403,
            errorCode: 'location-permission-denied',
            message: 'Location permissions are denied. Please grant location permission.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw AppException(
          statusCode: 403,
          errorCode: 'location-permission-permanently-denied',
          message:
              'Location permissions are permanently denied. Please enable them in app settings.',
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      return LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        speed: position.speed,
        timestamp: position.timestamp,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException(
        statusCode: 500,
        errorCode: 'location-error',
        message: 'Failed to get current location: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<bool> checkLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  @override
  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }
}


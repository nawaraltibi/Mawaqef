part of 'parking_map_bloc.dart';

/// Base class for parking map events
abstract class ParkingMapEvent {}

/// Event to load all parking lots for map display
class LoadParkingLots extends ParkingMapEvent {
  LoadParkingLots();
}

/// Event to load user's current location
class LoadUserLocation extends ParkingMapEvent {
  LoadUserLocation();
}

/// Event to select a parking lot and load its details
class SelectParkingLot extends ParkingMapEvent {
  final int lotId;

  SelectParkingLot({
    required this.lotId,
  });
}

/// Event to deselect parking lot (close bottom sheet)
class DeselectParkingLot extends ParkingMapEvent {
  DeselectParkingLot();
}

/// Event to search nearby parking lots based on user's current location
class SearchNearbyParking extends ParkingMapEvent {
  final double latitude;
  final double longitude;
  final double radiusKm;

  SearchNearbyParking({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 5.0, // Default 5 KM
  });
}

/// Event to cancel search and return to normal map view
class CancelSearchNearbyParking extends ParkingMapEvent {
  CancelSearchNearbyParking();
}

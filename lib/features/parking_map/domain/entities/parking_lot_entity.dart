/// Parking Lot Entity
/// Pure domain entity representing a parking lot for map display
/// No Flutter or external dependencies
/// 
/// Fields:
/// - [availableSpaces]: Booking-based availability (for business logic/validation)
/// - [occupiedSpaces]: Booking-based occupied spaces
/// - [vacantSpaces]: Camera-based vacant spaces (for display only)
class ParkingLotEntity {
  final int lotId;
  final String lotName;
  final String address;
  final double latitude;
  final double longitude;
  final int? availableSpaces; // Booking-based (for validation)
  final int? occupiedSpaces; // Booking-based occupied spaces
  final int? vacantSpaces; // Camera-based (for display only)
  final int totalSpaces;
  final double hourlyRate;
  final String status; // 'active' or 'inactive'

  const ParkingLotEntity({
    required this.lotId,
    required this.lotName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.totalSpaces,
    this.availableSpaces,
    this.occupiedSpaces,
    this.vacantSpaces,
    required this.hourlyRate,
    required this.status,
  });

  /// Check if parking is active
  bool get isActive => status == 'active';

  /// Check if parking is inactive
  bool get isInactive => status == 'inactive';

  /// Check if parking has available spaces
  /// Uses availableSpaces (booking-based) first, falls back to vacantSpaces (camera-based)
  bool get hasAvailableSpaces {
    return (availableSpaces ?? vacantSpaces ?? 0) > 0;
  }

  /// Check if parking lot is full
  bool get isFull => (availableSpaces ?? vacantSpaces ?? 0) == 0;

  /// Get occupancy percentage (0.0 to 1.0) using backend-provided values
  double get occupancyRate {
    if (totalSpaces == 0) return 0.0;
    // Use backend-provided occupied spaces if available
    final occupied = occupiedSpaces ?? (totalSpaces - (availableSpaces ?? totalSpaces));
    return (occupied / totalSpaces).clamp(0.0, 1.0);
  }

  /// Get available spaces count (returns 0 if null)
  int get availableSpacesCount => availableSpaces ?? 0;

  /// Get display-friendly available spaces
  /// Uses camera-based vacant_spaces for display (includes all detected vehicles)
  /// Falls back to booking-based available_spaces if camera data not available
  int get displayAvailableSpaces => vacantSpaces ?? availableSpaces ?? 0;

  /// Get display-friendly occupied spaces
  /// Derived from camera-based vacant_spaces for display
  /// Falls back to booking-based occupied_spaces
  int get displayOccupiedSpaces {
    if (vacantSpaces != null) {
      return (totalSpaces - vacantSpaces!).clamp(0, totalSpaces);
    }
    return occupiedSpaces ?? 0;
  }

  /// Create a copy of ParkingLotEntity with updated fields
  ParkingLotEntity copyWith({
    int? lotId,
    String? lotName,
    String? address,
    double? latitude,
    double? longitude,
    int? totalSpaces,
    int? availableSpaces,
    int? occupiedSpaces,
    int? vacantSpaces,
    double? hourlyRate,
    String? status,
  }) {
    return ParkingLotEntity(
      lotId: lotId ?? this.lotId,
      lotName: lotName ?? this.lotName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalSpaces: totalSpaces ?? this.totalSpaces,
      availableSpaces: availableSpaces ?? this.availableSpaces,
      occupiedSpaces: occupiedSpaces ?? this.occupiedSpaces,
      vacantSpaces: vacantSpaces ?? this.vacantSpaces,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParkingLotEntity && other.lotId == lotId;
  }

  @override
  int get hashCode => lotId.hashCode;

  @override
  String toString() {
    return 'ParkingLotEntity(lotId: $lotId, lotName: $lotName, address: $address, '
        'lat: $latitude, lng: $longitude, available: $availableSpaces/$totalSpaces, '
        'vacantSpaces: $vacantSpaces)';
  }
}

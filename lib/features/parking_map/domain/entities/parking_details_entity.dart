/// Parking Details Entity
/// Pure domain entity representing detailed parking information
/// No Flutter or external dependencies
/// 
/// Fields:
/// - [availableSpaces]: Booking-based availability (for business logic/validation)
/// - [occupiedSpaces]: Booking-based occupied spaces
/// - [vacantSpaces]: Camera-based vacant spaces (for display only)
class ParkingDetailsEntity {
  final int lotId;
  final String lotName;
  final String address;
  final double latitude;
  final double longitude;
  final int totalSpaces;
  final int? availableSpaces; // Booking-based (for validation)
  final int? occupiedSpaces; // Booking-based occupied spaces
  final int? vacantSpaces; // Camera-based (for display only)
  final double hourlyRate;
  final String status; // 'active' or 'inactive'
  final String? statusRequest; // 'pending', 'accept', or 'rejected'
  final int? userId;
  final String? createdAt;
  final String? updatedAt;

  const ParkingDetailsEntity({
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
    this.statusRequest,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  /// Check if parking is active
  bool get isActive => status == 'active';

  /// Check if parking is inactive
  bool get isInactive => status == 'inactive';

  /// Check if request is pending
  bool get isPending => statusRequest == 'pending';

  /// Check if request is approved
  bool get isApproved => statusRequest == 'accept';

  /// Check if request is rejected
  bool get isRejected => statusRequest == 'rejected';

  /// Check if parking has available spaces (booking-based)
  bool get hasAvailableSpaces {
    if (availableSpaces == null) return false;
    return availableSpaces! > 0;
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

  /// Get status display text
  String get statusDisplay {
    if (isRejected) return 'Rejected';
    if (isPending) return 'Pending Approval';
    if (isApproved && isActive) return 'Active';
    if (isApproved && isInactive) return 'Inactive';
    return 'Unknown';
  }

  /// Create a copy of ParkingDetailsEntity with updated fields
  ParkingDetailsEntity copyWith({
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
    String? statusRequest,
    int? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return ParkingDetailsEntity(
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
      statusRequest: statusRequest ?? this.statusRequest,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParkingDetailsEntity && other.lotId == lotId;
  }

  @override
  int get hashCode => lotId.hashCode;

  @override
  String toString() {
    return 'ParkingDetailsEntity(lotId: $lotId, lotName: $lotName, address: $address, '
        'lat: $latitude, lng: $longitude, available: $availableSpaces/$totalSpaces, '
        'status: $status, statusRequest: $statusRequest, vacantSpaces: $vacantSpaces)';
  }
}

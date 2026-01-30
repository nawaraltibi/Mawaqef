/// Parking Lot Entity
/// Pure domain entity representing a parking lot
/// No Flutter or external dependencies
class ParkingLotEntity {
  final int parkingLotId;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int? totalSpots;
  final int? availableSpots;
  final double? pricePerHour;
  final String? status;

  const ParkingLotEntity({
    required this.parkingLotId,
    required this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.totalSpots,
    this.availableSpots,
    this.pricePerHour,
    this.status,
  });

  /// Create a copy of ParkingLotEntity with updated fields
  ParkingLotEntity copyWith({
    int? parkingLotId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? totalSpots,
    int? availableSpots,
    double? pricePerHour,
    String? status,
  }) {
    return ParkingLotEntity(
      parkingLotId: parkingLotId ?? this.parkingLotId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      totalSpots: totalSpots ?? this.totalSpots,
      availableSpots: availableSpots ?? this.availableSpots,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParkingLotEntity && other.parkingLotId == parkingLotId;
  }

  @override
  int get hashCode => parkingLotId.hashCode;

  @override
  String toString() {
    return 'ParkingLotEntity(parkingLotId: $parkingLotId, name: $name)';
  }
}



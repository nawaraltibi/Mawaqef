/// Vehicle Entity
/// Pure domain entity representing a vehicle
/// No Flutter or external dependencies
class VehicleEntity {
  final int vehicleId;
  final String platNumber;
  final String carMake;
  final String carModel;
  final String color;
  final String? status;
  final int? userId;

  const VehicleEntity({
    required this.vehicleId,
    required this.platNumber,
    required this.carMake,
    required this.carModel,
    required this.color,
    this.status,
    this.userId,
  });

  /// Get full vehicle name
  String get fullName => '$carMake $carModel';

  /// Create a copy of VehicleEntity with updated fields
  VehicleEntity copyWith({
    int? vehicleId,
    String? platNumber,
    String? carMake,
    String? carModel,
    String? color,
    String? status,
    int? userId,
  }) {
    return VehicleEntity(
      vehicleId: vehicleId ?? this.vehicleId,
      platNumber: platNumber ?? this.platNumber,
      carMake: carMake ?? this.carMake,
      carModel: carModel ?? this.carModel,
      color: color ?? this.color,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VehicleEntity && other.vehicleId == vehicleId;
  }

  @override
  int get hashCode => vehicleId.hashCode;

  @override
  String toString() {
    return 'VehicleEntity(vehicleId: $vehicleId, platNumber: $platNumber, fullName: $fullName)';
  }
}



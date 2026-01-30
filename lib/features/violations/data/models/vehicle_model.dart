/// Vehicle Model
/// Represents a vehicle in the API response
class VehicleModel {
  final int vehicleId;
  final String platNumber;
  final String carMake;
  final String carModel;
  final String color;
  final String? status;
  final int? userId;

  const VehicleModel({
    required this.vehicleId,
    required this.platNumber,
    required this.carMake,
    required this.carModel,
    required this.color,
    this.status,
    this.userId,
  });

  /// Helper method to safely convert dynamic value to int
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed ?? defaultValue;
    }
    return defaultValue;
  }

  /// Helper method to safely convert dynamic value to String
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      vehicleId: _parseInt(json['vehicle_id'] ?? json['id']),
      platNumber: _parseString(json['plat_number'] ?? json['plate_number']),
      carMake: _parseString(json['car_make'] ?? json['make']),
      carModel: _parseString(json['car_model'] ?? json['model']),
      color: _parseString(json['color']),
      status: json['status'] as String?,
      userId: json['user_id'] != null ? _parseInt(json['user_id']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_id': vehicleId,
      'plat_number': platNumber,
      'car_make': carMake,
      'car_model': carModel,
      'color': color,
      'status': status,
      'user_id': userId,
    };
  }

  /// Create a copy of VehicleModel with updated fields
  VehicleModel copyWith({
    int? vehicleId,
    String? platNumber,
    String? carMake,
    String? carModel,
    String? color,
    String? status,
    int? userId,
  }) {
    return VehicleModel(
      vehicleId: vehicleId ?? this.vehicleId,
      platNumber: platNumber ?? this.platNumber,
      carMake: carMake ?? this.carMake,
      carModel: carModel ?? this.carModel,
      color: color ?? this.color,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  /// Get full vehicle name
  String get fullName => '$carMake $carModel';
}



/// Parking Lot Model
/// Represents a parking lot in the API response
class ParkingLotModel {
  final int parkingLotId;
  final String name;
  final String? address;
  final double? latitude;
  final double? longitude;
  final int? totalSpots;
  final int? availableSpots;
  final double? pricePerHour;
  final String? status;

  const ParkingLotModel({
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

  /// Helper method to safely convert dynamic value to double
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  /// Helper method to safely convert dynamic value to String
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  factory ParkingLotModel.fromJson(Map<String, dynamic> json) {
    return ParkingLotModel(
      parkingLotId: _parseInt(json['parking_lot_id'] ?? json['id'] ?? json['lot_id']),
      name: _parseString(json['name']),
      address: json['address'] as String?,
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      totalSpots: json['total_spots'] != null ? _parseInt(json['total_spots']) : null,
      availableSpots: json['available_spots'] != null ? _parseInt(json['available_spots']) : null,
      pricePerHour: _parseDouble(json['price_per_hour'] ?? json['price']),
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parking_lot_id': parkingLotId,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'total_spots': totalSpots,
      'available_spots': availableSpots,
      'price_per_hour': pricePerHour,
      'status': status,
    };
  }

  /// Create a copy of ParkingLotModel with updated fields
  ParkingLotModel copyWith({
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
    return ParkingLotModel(
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
}



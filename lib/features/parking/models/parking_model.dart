/// Parking Model
/// Represents a parking lot entity
/// 
/// Fields:
/// - [availableSpaces]: Booking-based availability (for business logic/validation)
/// - [occupiedSpaces]: Booking-based occupied spaces
/// - [vacantSpaces]: Camera-based vacant spaces (for display only)
class ParkingModel {
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

  ParkingModel({
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

  factory ParkingModel.fromJson(Map<String, dynamic> json) {
    return ParkingModel(
      lotId: _parseInt(json['lot_id'] ?? json['id']),
      lotName: json['lot_name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      totalSpaces: _parseInt(json['total_spaces']),
      availableSpaces: json['available_spaces'] != null ? _parseInt(json['available_spaces']) : null,
      occupiedSpaces: json['occupied_spaces'] != null ? _parseInt(json['occupied_spaces']) : null,
      vacantSpaces: json['vacant_spaces'] != null ? _parseInt(json['vacant_spaces']) : null,
      hourlyRate: _parseDouble(json['hourly_rate']),
      status: json['status'] as String? ?? 'inactive',
      statusRequest: json['statusrequest'] as String? ?? json['status_request'] as String?,
      userId: json['user_id'] != null ? _parseInt(json['user_id']) : null,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'lot_id': lotId,
      'lot_name': lotName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'total_spaces': totalSpaces,
      'available_spaces': availableSpaces,
      'occupied_spaces': occupiedSpaces,
      'vacant_spaces': vacantSpaces,
      'hourly_rate': hourlyRate,
      'status': status,
      'statusrequest': statusRequest,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Create a copy of ParkingModel with updated fields
  ParkingModel copyWith({
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
    return ParkingModel(
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

  /// Get status display text
  String get statusDisplay {
    if (isRejected) return 'Rejected';
    if (isPending) return 'Pending Approval';
    if (isApproved && isActive) return 'Active';
    if (isApproved && isInactive) return 'Inactive';
    return 'Unknown';
  }

  /// Check if parking lot has available spaces (booking-based)
  bool get hasAvailableSpaces => (availableSpaces ?? 0) > 0;

  /// Check if parking lot is full
  bool get isFull => (availableSpaces ?? vacantSpaces ?? 0) == 0;

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
}

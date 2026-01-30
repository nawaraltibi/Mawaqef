import 'parking_lot_model.dart';
import 'vehicle_model.dart';

/// Violation Model
/// Represents a violation in the API response
class ViolationModel {
  final int violationId;
  final String violationType;
  final String? description;
  final double amount;
  final String status; // 'paid' or 'unpaid'
  final String? violationDate;
  final String? paidDate;
  final ParkingLotModel? parkingLot;
  final VehicleModel? vehicle;

  const ViolationModel({
    required this.violationId,
    required this.violationType,
    this.description,
    required this.amount,
    required this.status,
    this.violationDate,
    this.paidDate,
    this.parkingLot,
    this.vehicle,
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
  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  /// Helper method to safely convert dynamic value to String
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    if (value is String) return value;
    return value.toString();
  }

  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      violationId: _parseInt(json['violation_id'] ?? json['id']),
      violationType: _parseString(json['violation_type'] ?? json['type']),
      description: json['description'] as String?,
      amount: _parseDouble(json['amount'] ?? json['fine_amount']),
      status: _parseString(json['status'], defaultValue: 'unpaid'),
      violationDate: json['violation_date'] ?? json['created_at'] as String?,
      paidDate: json['paid_date'] as String?,
      parkingLot: json['parking_lot'] != null
          ? ParkingLotModel.fromJson(
              json['parking_lot'] is Map<String, dynamic>
                  ? json['parking_lot'] as Map<String, dynamic>
                  : {},
            )
          : null,
      vehicle: json['vehicle'] != null
          ? VehicleModel.fromJson(
              json['vehicle'] is Map<String, dynamic>
                  ? json['vehicle'] as Map<String, dynamic>
                  : {},
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'violation_id': violationId,
      'violation_type': violationType,
      'description': description,
      'amount': amount,
      'status': status,
      'violation_date': violationDate,
      'paid_date': paidDate,
      'parking_lot': parkingLot?.toJson(),
      'vehicle': vehicle?.toJson(),
    };
  }

  /// Create a copy of ViolationModel with updated fields
  ViolationModel copyWith({
    int? violationId,
    String? violationType,
    String? description,
    double? amount,
    String? status,
    String? violationDate,
    String? paidDate,
    ParkingLotModel? parkingLot,
    VehicleModel? vehicle,
  }) {
    return ViolationModel(
      violationId: violationId ?? this.violationId,
      violationType: violationType ?? this.violationType,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      violationDate: violationDate ?? this.violationDate,
      paidDate: paidDate ?? this.paidDate,
      parkingLot: parkingLot ?? this.parkingLot,
      vehicle: vehicle ?? this.vehicle,
    );
  }

  /// Check if violation is paid
  bool get isPaid => status == 'paid';

  /// Check if violation is unpaid
  bool get isUnpaid => status == 'unpaid';
}



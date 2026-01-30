import 'parking_lot_entity.dart';
import 'vehicle_entity.dart';

/// Violation Entity
/// Pure domain entity representing a parking violation
/// No Flutter or external dependencies
class ViolationEntity {
  final int violationId;
  final String violationType;
  final String? description;
  final double amount;
  final String status; // 'paid' or 'unpaid'
  final String? violationDate;
  final String? paidDate;
  final ParkingLotEntity? parkingLot;
  final VehicleEntity? vehicle;

  const ViolationEntity({
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

  /// Check if violation is paid
  bool get isPaid => status == 'paid';

  /// Check if violation is unpaid
  bool get isUnpaid => status == 'unpaid';

  /// Create a copy of ViolationEntity with updated fields
  ViolationEntity copyWith({
    int? violationId,
    String? violationType,
    String? description,
    double? amount,
    String? status,
    String? violationDate,
    String? paidDate,
    ParkingLotEntity? parkingLot,
    VehicleEntity? vehicle,
  }) {
    return ViolationEntity(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ViolationEntity && other.violationId == violationId;
  }

  @override
  int get hashCode => violationId.hashCode;

  @override
  String toString() {
    return 'ViolationEntity(violationId: $violationId, type: $violationType, amount: $amount, status: $status)';
  }
}



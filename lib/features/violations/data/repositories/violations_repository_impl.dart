import '../../domain/entities/violation_entity.dart';
import '../../domain/entities/parking_lot_entity.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repositories/violations_repository.dart';
import '../datasources/violations_remote_datasource.dart';
import '../models/violation_model.dart';
import '../models/parking_lot_model.dart';
import '../models/vehicle_model.dart';
import '../models/pay_violation_request.dart';
import '../../../../core/utils/app_exception.dart';

/// Violations Repository Implementation
/// Implements the domain repository interface
class ViolationsRepositoryImpl implements ViolationsRepository {
  final ViolationsRemoteDataSource remoteDataSource;

  ViolationsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<ViolationEntity>> getUnpaidViolations() async {
    try {
      final response = await remoteDataSource.getUnpaidViolations();
      return response.violations.map((model) => _modelToEntity(model)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  @override
  Future<List<ViolationEntity>> getPaidViolations() async {
    try {
      final response = await remoteDataSource.getPaidViolations();
      return response.violations.map((model) => _modelToEntity(model)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  @override
  Future<ViolationEntity> payViolation({
    required int violationId,
    required String paymentMethod,
  }) async {
    try {
      final request = PayViolationRequest(
        paymentMethod: paymentMethod,
      );

      final response = await remoteDataSource.payViolation(
        violationId: violationId,
        payRequest: request,
      );
      return _modelToEntity(response.violation);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  /// Convert ViolationModel to ViolationEntity
  ViolationEntity _modelToEntity(ViolationModel model) {
    return ViolationEntity(
      violationId: model.violationId,
      violationType: model.violationType,
      description: model.description,
      amount: model.amount,
      status: model.status,
      violationDate: model.violationDate,
      paidDate: model.paidDate,
      parkingLot: model.parkingLot != null
          ? _parkingLotModelToEntity(model.parkingLot!)
          : null,
      vehicle: model.vehicle != null
          ? _vehicleModelToEntity(model.vehicle!)
          : null,
    );
  }

  /// Convert ParkingLotModel to ParkingLotEntity
  ParkingLotEntity _parkingLotModelToEntity(ParkingLotModel model) {
    return ParkingLotEntity(
      parkingLotId: model.parkingLotId,
      name: model.name,
      address: model.address,
      latitude: model.latitude,
      longitude: model.longitude,
      totalSpots: model.totalSpots,
      availableSpots: model.availableSpots,
      pricePerHour: model.pricePerHour,
      status: model.status,
    );
  }

  /// Convert VehicleModel to VehicleEntity
  VehicleEntity _vehicleModelToEntity(VehicleModel model) {
    return VehicleEntity(
      vehicleId: model.vehicleId,
      platNumber: model.platNumber,
      carMake: model.carMake,
      carModel: model.carModel,
      color: model.color,
      status: model.status,
      userId: model.userId,
    );
  }
}



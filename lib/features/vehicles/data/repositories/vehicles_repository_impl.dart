import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repositories/vehicles_repository.dart';
import '../datasources/vehicles_remote_datasource.dart';
import '../models/add_vehicle_request.dart';
import '../models/update_vehicle_request.dart';
import '../models/vehicle_model.dart';
import '../../../../core/utils/app_exception.dart';

/// Vehicles Repository Implementation
/// Implements the domain repository interface
class VehiclesRepositoryImpl implements VehiclesRepository {
  final VehiclesRemoteDataSource remoteDataSource;

  VehiclesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<VehicleEntity>> getVehicles() async {
    try {
      final response = await remoteDataSource.getVehicles();
      return response.vehicles.map((model) => _modelToEntity(model)).toList();
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
  Future<VehicleEntity> addVehicle({
    required String platNumber,
    required String carMake,
    required String carModel,
    required String color,
  }) async {
    try {
      final request = AddVehicleRequest(
        platNumber: platNumber,
        carMake: carMake,
        carModel: carModel,
        color: color,
      );

      final response = await remoteDataSource.addVehicle(addRequest: request);
      return _modelToEntity(response.vehicle);
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
  Future<VehicleEntity> updateVehicle({
    required int vehicleId,
    required String platNumber,
    required String carMake,
    required String carModel,
    required String color,
  }) async {
    try {
      final request = UpdateVehicleRequest(
        platNumber: platNumber,
        carMake: carMake,
        carModel: carModel,
        color: color,
      );

      final response = await remoteDataSource.updateVehicle(
        vehicleId: vehicleId,
        updateRequest: request,
      );
      return _modelToEntity(response.vehicle);
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
  Future<void> deleteVehicle({required int vehicleId}) async {
    try {
      final response = await remoteDataSource.deleteVehicle(
        vehicleId: vehicleId,
      );

      if (!response.isSuccess) {
        throw AppException(
          statusCode: 500,
          errorCode: 'delete-failed',
          message: response.message,
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException(
        statusCode: 500,
        errorCode: 'unexpected-error',
        message: e.toString(),
      );
    }
  }

  /// Convert VehicleModel to VehicleEntity
  VehicleEntity _modelToEntity(VehicleModel model) {
    return VehicleEntity(
      vehicleId: model.vehicleId,
      platNumber: model.platNumber,
      carMake: model.carMake,
      carModel: model.carModel,
      color: model.color,
      status: model.status,
      requestStatus: model.requestStatus,
      userId: model.userId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}


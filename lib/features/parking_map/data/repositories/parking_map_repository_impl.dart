import '../../domain/entities/parking_lot_entity.dart';
import '../../domain/entities/parking_details_entity.dart';
import '../../domain/repositories/parking_map_repository.dart';
import '../datasources/parking_map_remote_datasource.dart';
import '../models/parking_lot_model.dart';
import '../models/parking_details_model.dart';
import '../../../../core/utils/app_exception.dart';

/// Parking Map Repository Implementation
/// Implements the domain repository interface
class ParkingMapRepositoryImpl implements ParkingMapRepository {
  final ParkingMapRemoteDataSource remoteDataSource;

  ParkingMapRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<ParkingLotEntity>> getAllParkingLots() async {
    try {
      final response = await remoteDataSource.getAllParkingLots();
      return response.parkingLots
          .map((model) => _lotModelToEntity(model))
          .toList();
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
  Future<ParkingDetailsEntity> getParkingDetails({
    required int lotId,
  }) async {
    try {
      final response = await remoteDataSource.getParkingDetails(lotId: lotId);
      return _detailsModelToEntity(response.parking);
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

  /// Convert ParkingLotModel to ParkingLotEntity
  /// This mapping isolates data layer models from domain entities
  ParkingLotEntity _lotModelToEntity(ParkingLotModel model) {
    return ParkingLotEntity(
      lotId: model.lotId,
      lotName: model.lotName,
      address: model.address,
      latitude: model.latitude,
      longitude: model.longitude,
      totalSpaces: model.totalSpaces,
      availableSpaces: model.availableSpaces,
      occupiedSpaces: model.occupiedSpaces,
      vacantSpaces: model.vacantSpaces,
      hourlyRate: model.hourlyRate,
      status: model.status,
    );
  }

  /// Convert ParkingDetailsModel to ParkingDetailsEntity
  /// This mapping isolates data layer models from domain entities
  ParkingDetailsEntity _detailsModelToEntity(ParkingDetailsModel model) {
    return ParkingDetailsEntity(
      lotId: model.lotId,
      lotName: model.lotName,
      address: model.address,
      latitude: model.latitude,
      longitude: model.longitude,
      totalSpaces: model.totalSpaces,
      availableSpaces: model.availableSpaces,
      occupiedSpaces: model.occupiedSpaces,
      vacantSpaces: model.vacantSpaces,
      hourlyRate: model.hourlyRate,
      status: model.status,
      statusRequest: model.statusRequest,
      userId: model.userId,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  @override
  Future<List<ParkingLotEntity>> searchNearbyParking({
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) async {
    try {
      final response = await remoteDataSource.searchNearbyParking(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm.toInt(),
      );
      
      // Note: Backend now handles filtering of full parking lots
      // We still apply a safety filter here for additional protection
      return response.parkingLots
          .where((model) => !model.isFull) // Use model's isFull getter
          .map((model) => _lotModelToEntity(model))
          .toList();
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
}


import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/usecases/get_vehicles_usecase.dart';
import '../../domain/usecases/add_vehicle_usecase.dart';
import '../../domain/usecases/update_vehicle_usecase.dart';
import '../../domain/usecases/delete_vehicle_usecase.dart';
import 'mixins/vehicles_error_handler_mixin.dart';

part 'vehicles_event.dart';
part 'vehicles_state.dart';

/// Vehicles Bloc
/// Manages vehicles state and business logic using Bloc pattern with AsyncRunner
class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState>
    with VehiclesErrorHandlerMixin {
  final GetVehiclesUseCase getVehiclesUseCase;
  final AddVehicleUseCase addVehicleUseCase;
  final UpdateVehicleUseCase updateVehicleUseCase;
  final DeleteVehicleUseCase deleteVehicleUseCase;

  final AsyncRunner<List<VehicleEntity>> getVehiclesRunner =
      AsyncRunner<List<VehicleEntity>>();
  final AsyncRunner<VehicleEntity> addVehicleRunner =
      AsyncRunner<VehicleEntity>();
  final AsyncRunner<VehicleEntity> updateVehicleRunner =
      AsyncRunner<VehicleEntity>();
  final AsyncRunner<void> deleteVehicleRunner = AsyncRunner<void>();

  VehiclesBloc({
    required this.getVehiclesUseCase,
    required this.addVehicleUseCase,
    required this.updateVehicleUseCase,
    required this.deleteVehicleUseCase,
  }) : super(VehiclesInitial()) {
    on<GetVehiclesRequested>(_onGetVehiclesRequested);
    on<AddVehicleRequested>(_onAddVehicleRequested);
    on<UpdateVehicleRequested>(_onUpdateVehicleRequested);
    on<DeleteVehicleRequested>(_onDeleteVehicleRequested);
    on<ResetVehiclesState>(_onResetVehiclesState);
  }

  /// Get vehicles for the authenticated user
  Future<void> _onGetVehiclesRequested(
    GetVehiclesRequested event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(VehiclesLoading());

    await getVehiclesRunner.run(
      onlineTask: (previousResult) async {
        return await getVehiclesUseCase();
      },
      onSuccess: (vehicles) async {
        if (!emit.isDone) {
          if (vehicles.isEmpty) {
            emit(VehiclesEmpty());
          } else {
            emit(VehiclesLoaded(vehicles: vehicles));
          }
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleError(error, emit);
        }
      },
    );
  }

  /// Add a new vehicle
  Future<void> _onAddVehicleRequested(
    AddVehicleRequested event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(VehicleActionLoading());

    await addVehicleRunner.run(
      onlineTask: (previousResult) async {
        return await addVehicleUseCase(
          platNumber: event.platNumber,
          carMake: event.carMake,
          carModel: event.carModel,
          color: event.color,
        );
      },
      onSuccess: (vehicle) async {
        if (!emit.isDone) {
          emit(VehicleActionSuccess(
            successType: VehicleSuccessType.added,
            vehicle: vehicle,
          ));
          // Reload vehicles list after successful add
          add(GetVehiclesRequested());
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleVehicleActionError(error, emit);
        }
      },
    );
  }

  /// Update a vehicle
  /// Note: This creates a modification request that requires admin approval
  Future<void> _onUpdateVehicleRequested(
    UpdateVehicleRequested event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(VehicleActionLoading());

    await updateVehicleRunner.run(
      onlineTask: (previousResult) async {
        return await updateVehicleUseCase(
          vehicleId: event.vehicleId,
          platNumber: event.platNumber,
          carMake: event.carMake,
          carModel: event.carModel,
          color: event.color,
        );
      },
      onSuccess: (vehicle) async {
        if (!emit.isDone) {
          emit(VehicleActionSuccess(
            successType: VehicleSuccessType.updateRequested,
            vehicle: vehicle,
          ));
          // Reload vehicles list after successful update request
          add(GetVehiclesRequested());
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleVehicleActionError(error, emit);
        }
      },
    );
  }

  /// Delete a vehicle
  Future<void> _onDeleteVehicleRequested(
    DeleteVehicleRequested event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(VehicleActionLoading());

    await deleteVehicleRunner.run(
      onlineTask: (previousResult) async {
        await deleteVehicleUseCase(vehicleId: event.vehicleId);
      },
      onSuccess: (_) async {
        if (!emit.isDone) {
          emit(VehicleActionSuccess(
            successType: VehicleSuccessType.deleted,
          ));
          // Reload vehicles list after successful delete
          add(GetVehiclesRequested());
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleVehicleActionError(error, emit);
        }
      },
    );
  }

  /// Reset vehicles state
  void _onResetVehiclesState(
    ResetVehiclesState event,
    Emitter<VehiclesState> emit,
  ) {
    if (state is VehiclesLoaded) {
      emit(VehiclesLoaded(vehicles: (state as VehiclesLoaded).vehicles));
    } else {
      emit(VehiclesInitial());
    }
  }
}


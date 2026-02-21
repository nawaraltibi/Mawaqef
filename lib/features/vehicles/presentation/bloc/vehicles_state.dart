part of 'vehicles_bloc.dart';

/// Base class for vehicles states
abstract class VehiclesState {}

/// Initial state
class VehiclesInitial extends VehiclesState {
  VehiclesInitial();
}

/// Loading state - vehicles operation in progress
class VehiclesLoading extends VehiclesState {
  VehiclesLoading();
}

/// Loaded state - vehicles loaded successfully
class VehiclesLoaded extends VehiclesState {
  final List<VehicleEntity> vehicles;

  VehiclesLoaded({required this.vehicles});
}

/// Empty state - no vehicles found
class VehiclesEmpty extends VehiclesState {
  VehiclesEmpty();
}

/// Error state - vehicles operation failed
class VehiclesError extends VehiclesState {
  final String error;
  final int statusCode;

  VehiclesError({
    required this.error,
    required this.statusCode,
  });
}

/// Loading state for vehicle actions (add, update, delete)
class VehicleActionLoading extends VehiclesState {
  VehicleActionLoading();
}

/// Success type enum for vehicle actions
/// Used for localized message lookup in the presentation layer
enum VehicleSuccessType {
  added,
  updateRequested,
  deleted,
}

/// Success state for vehicle actions
class VehicleActionSuccess extends VehiclesState {
  /// Success type for localized message lookup
  final VehicleSuccessType successType;
  
  /// The vehicle that was affected (optional)
  final VehicleEntity? vehicle;

  VehicleActionSuccess({
    required this.successType,
    this.vehicle,
  });
}

/// Failure state for vehicle actions
class VehicleActionFailure extends VehiclesState {
  final String error;
  final int statusCode;

  VehicleActionFailure({
    required this.error,
    required this.statusCode,
  });
}


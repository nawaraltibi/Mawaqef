// Vehicles Feature - Barrel File
// Export all public APIs for the Vehicles feature

// Domain Layer
export 'domain/entities/vehicle_entity.dart';
export 'domain/repositories/vehicles_repository.dart';
export 'domain/usecases/get_vehicles_usecase.dart';
export 'domain/usecases/add_vehicle_usecase.dart';
export 'domain/usecases/update_vehicle_usecase.dart';
export 'domain/usecases/delete_vehicle_usecase.dart';

// Data Layer
export 'data/models/vehicle_model.dart';
export 'data/models/add_vehicle_request.dart';
export 'data/models/add_vehicle_response.dart';
export 'data/models/update_vehicle_request.dart';
export 'data/models/update_vehicle_response.dart';
export 'data/models/vehicles_list_response.dart';
export 'data/models/delete_vehicle_response.dart';
export 'data/datasources/vehicles_remote_datasource.dart';
export 'data/repositories/vehicles_repository_impl.dart';

// Presentation Layer - BLoC
// Note: Only export the main bloc file - events and states are part of it
export 'presentation/bloc/vehicles_bloc.dart';


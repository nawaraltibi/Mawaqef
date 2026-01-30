// Violations Feature - Barrel File
// Export all public APIs for the Violations feature

// Domain Layer
export 'domain/entities/violation_entity.dart';
export 'domain/entities/parking_lot_entity.dart';
export 'domain/entities/vehicle_entity.dart';
export 'domain/repositories/violations_repository.dart';
export 'domain/usecases/get_unpaid_violations.dart';
export 'domain/usecases/get_paid_violations.dart';
export 'domain/usecases/pay_violation.dart';

// Data Layer
export 'data/models/violation_model.dart';
export 'data/models/parking_lot_model.dart';
export 'data/models/vehicle_model.dart';
export 'data/models/unpaid_violations_response.dart';
export 'data/models/paid_violations_response.dart';
export 'data/models/pay_violation_request.dart';
export 'data/models/pay_violation_response.dart';
export 'data/datasources/violations_remote_datasource.dart';
export 'data/repositories/violations_repository_impl.dart';

// Presentation Layer - BLoC
// Note: Only export the main bloc file - events and states are part of it
export 'presentation/bloc/violations_bloc.dart';


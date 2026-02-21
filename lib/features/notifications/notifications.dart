// Notifications Feature - Barrel File
// Export all public APIs for the Notifications feature

// Domain Layer
export 'domain/entities/notification_entity.dart';
export 'domain/entities/notifications_result.dart';
export 'domain/repositories/notifications_repository.dart';
export 'domain/usecases/get_all_notifications_usecase.dart';
export 'domain/usecases/mark_notification_as_read_usecase.dart';

// Data Layer
export 'data/models/notification_model.dart';
export 'data/models/notifications_list_response.dart';
export 'data/models/mark_notification_read_response.dart';
export 'data/datasources/notifications_remote_datasource.dart';
export 'data/repositories/notifications_repository_impl.dart';

// Presentation Layer - BLoC
// Note: Only export the main bloc file - events and states are part of it
export 'presentation/bloc/notifications_bloc.dart';


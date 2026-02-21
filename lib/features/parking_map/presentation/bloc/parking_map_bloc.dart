import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../../../core/utils/app_exception.dart';
import '../../../../core/location/location_entity.dart';
import '../../../../core/map/map_point.dart';
import '../../domain/entities/parking_lot_entity.dart';
import '../../domain/entities/parking_details_entity.dart';
import '../../domain/usecases/get_all_parking_lots_usecase.dart';
import '../../domain/usecases/get_parking_details_usecase.dart';
import '../../domain/usecases/search_nearby_parking_usecase.dart';
import '../../../../core/location/get_current_location_usecase.dart';

part 'parking_map_event.dart';
part 'parking_map_state.dart';

/// Parking Map Bloc
/// Manages parking map state and business logic using Bloc pattern with AsyncRunner
class ParkingMapBloc extends Bloc<ParkingMapEvent, ParkingMapState> {
  final GetAllParkingLotsUseCase getAllParkingLotsUseCase;
  final GetParkingDetailsUseCase getParkingDetailsUseCase;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;
  final SearchNearbyParkingUseCase searchNearbyParkingUseCase;

  final AsyncRunner<List<ParkingLotEntity>> getParkingLotsRunner =
      AsyncRunner<List<ParkingLotEntity>>();
  final AsyncRunner<ParkingDetailsEntity> getParkingDetailsRunner =
      AsyncRunner<ParkingDetailsEntity>();
  final AsyncRunner<LocationEntity> getLocationRunner =
      AsyncRunner<LocationEntity>();
  final AsyncRunner<List<ParkingLotEntity>> searchNearbyParkingRunner =
      AsyncRunner<List<ParkingLotEntity>>();

  ParkingMapBloc({
    required this.getAllParkingLotsUseCase,
    required this.getParkingDetailsUseCase,
    required this.getCurrentLocationUseCase,
    required this.searchNearbyParkingUseCase,
  }) : super(ParkingMapState.initial()) {
    on<LoadParkingLots>(_onLoadParkingLots);
    on<LoadUserLocation>(_onLoadUserLocation);
    on<SelectParkingLot>(_onSelectParkingLot);
    on<DeselectParkingLot>(_onDeselectParkingLot);
    on<SearchNearbyParking>(_onSearchNearbyParking);
    on<CancelSearchNearbyParking>(_onCancelSearchNearbyParking);
  }

  /// Load all parking lots for map display
  Future<void> _onLoadParkingLots(
    LoadParkingLots event,
    Emitter<ParkingMapState> emit,
  ) async {
    // Don't emit loading if we already have data (optimistic update)
    if (!state.hasParkingLots) {
      emit(state.copyWith(
        isLoadingParkingLots: true,
        clearError: true,
      ));
    }

    await getParkingLotsRunner.run(
      onlineTask: (previousResult) async {
        return await getAllParkingLotsUseCase();
      },
      onSuccess: (parkingLots) async {
        if (!emit.isDone) {
          emit(state.copyWith(
            parkingLots: parkingLots,
            isLoadingParkingLots: false,
            clearError: true,
          ));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          final message = error is AppException
              ? error.message
              : error.toString();
          final statusCode = error is AppException ? error.statusCode : 500;
          emit(state.copyWith(
            isLoadingParkingLots: false,
            errorMessage: message,
            errorStatusCode: statusCode,
          ));
        }
      },
    );
  }

  /// Load user's current location
  Future<void> _onLoadUserLocation(
    LoadUserLocation event,
    Emitter<ParkingMapState> emit,
  ) async {
    emit(state.copyWith(isLoadingLocation: true));

    await getLocationRunner.run(
      onlineTask: (previousResult) async {
        return await getCurrentLocationUseCase();
      },
      onSuccess: (location) async {
        if (!emit.isDone) {
          final userLocation = MapPoint(
            latitude: location.latitude,
            longitude: location.longitude,
          );

          emit(state.copyWith(
            userLocation: userLocation,
            isLoadingLocation: false,
          ));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          // Don't show error if we already have parking lots
          // Just silently fail location loading
          if (state.hasParkingLots) {
            emit(state.copyWith(isLoadingLocation: false));
          } else {
            final message = error is AppException
                ? error.message
                : error.toString();
            final statusCode = error is AppException ? error.statusCode : 500;
            emit(state.copyWith(
              isLoadingLocation: false,
              errorMessage: message,
              errorStatusCode: statusCode,
            ));
          }
        }
      },
    );
  }

  /// Select a parking lot and load its details
  Future<void> _onSelectParkingLot(
    SelectParkingLot event,
    Emitter<ParkingMapState> emit,
  ) async {
    // Find the parking lot entity - first try displayed list, then all parking lots
    // This allows selecting full parking lots even when in search mode
    ParkingLotEntity? lot;
    
    // First, try to find in displayed parking lots
    lot = state.displayedParkingLots.cast<ParkingLotEntity?>().firstWhere(
      (p) => p?.lotId == event.lotId,
      orElse: () => null,
    );
    
    // If not found and we're in search mode, also check all parking lots
    if (lot == null && state.isSearchMode) {
      lot = state.parkingLots.cast<ParkingLotEntity?>().firstWhere(
        (p) => p?.lotId == event.lotId,
        orElse: () => null,
      );
    }
    
    if (lot == null) {
      // Parking lot not found in any list
      return;
    }

    // Immediately set selection and start loading details
    emit(state.copyWith(
      selectedLot: lot,
      isLoadingDetails: true,
      clearSelectedDetails: true,
      clearDetailsError: true,
    ));

    await getParkingDetailsRunner.run(
      onlineTask: (previousResult) async {
        return await getParkingDetailsUseCase(lotId: event.lotId);
      },
      onSuccess: (details) async {
        if (!emit.isDone) {
          emit(state.copyWith(
            selectedDetails: details,
            isLoadingDetails: false,
            clearDetailsError: true,
          ));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          final message = error is AppException
              ? error.message
              : error.toString();
          final statusCode = error is AppException ? error.statusCode : 500;
          emit(state.copyWith(
            isLoadingDetails: false,
            detailsErrorMessage: message,
            detailsErrorStatusCode: statusCode,
          ));
        }
      },
    );
  }

  /// Deselect parking lot (close bottom sheet)
  void _onDeselectParkingLot(
    DeselectParkingLot event,
    Emitter<ParkingMapState> emit,
  ) {
    emit(state.copyWith(
      clearSelectedLot: true,
      clearSelectedDetails: true,
      clearDetailsError: true,
    ));
  }

  /// Search nearby parking lots based on user's current location
  Future<void> _onSearchNearbyParking(
    SearchNearbyParking event,
    Emitter<ParkingMapState> emit,
  ) async {
    // Set loading state and enable search mode
    emit(state.copyWith(
      isLoadingSearch: true,
      isSearchMode: true,
      clearSearchError: true,
      clearSelectedLot: true,
      clearSelectedDetails: true,
    ));

    await searchNearbyParkingRunner.run(
      onlineTask: (previousResult) async {
        return await searchNearbyParkingUseCase(
          latitude: event.latitude,
          longitude: event.longitude,
          radiusKm: event.radiusKm,
        );
      },
      onSuccess: (searchResults) async {
        if (!emit.isDone) {
          emit(state.copyWith(
            searchedParkingLots: searchResults,
            isLoadingSearch: false,
            clearSearchError: true,
          ));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          final message = error is AppException
              ? error.message
              : error.toString();
          final statusCode = error is AppException ? error.statusCode : 500;
          emit(state.copyWith(
            isLoadingSearch: false,
            searchErrorMessage: message,
            searchErrorStatusCode: statusCode,
          ));
        }
      },
    );
  }

  /// Cancel search and return to normal map view
  void _onCancelSearchNearbyParking(
    CancelSearchNearbyParking event,
    Emitter<ParkingMapState> emit,
  ) {
    emit(state.copyWith(
      isSearchMode: false,
      clearSearchResults: true,
      clearSearchError: true,
      clearSelectedLot: true,
      clearSelectedDetails: true,
    ));
  }
}

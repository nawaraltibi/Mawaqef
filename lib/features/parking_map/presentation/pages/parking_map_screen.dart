import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/map/map_adapter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/parking_lot_entity.dart';
import '../bloc/parking_map_bloc.dart';
import '../widgets/parking_details_bottom_sheet.dart';
import '../../../../features/notifications/presentation/bloc/notifications_bloc.dart';

/// Parking Map Screen
/// Displays parking lots on a map with bottom sheet for details
class ParkingMapScreen extends StatefulWidget {
  const ParkingMapScreen({super.key});

  @override
  State<ParkingMapScreen> createState() => _ParkingMapScreenState();
}

class _ParkingMapScreenState extends State<ParkingMapScreen>
    with OSMMixinObserver, TickerProviderStateMixin {
  MapController? _mapController;
  bool _mapIsReady = false;
  GeoPoint? _initialCenter;
  bool _hasCenteredOnUserLocation = false; // Track if we've already centered
  GeoPoint? _lastUserLocation;
  bool _isBottomSheetOpen = false; // Track if bottom sheet is open
  final Map<int, AnimationController> _markerAnimationControllers =
      {}; // Track marker animations
  final Set<int> _addedMarkerLotIds = {}; // Track which parking lots have markers

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    // Default center (can be overridden by user location)
    _initialCenter = GeoPoint(
      latitude: 33.5138, // Damascus, Syria
      longitude: 36.2765,
    );

    _mapController = MapController(initPosition: _initialCenter!);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    // Dispose all marker animation controllers
    for (var controller in _markerAnimationControllers.values) {
      controller.dispose();
    }
    _markerAnimationControllers.clear();
    super.dispose();
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady && mounted) {
      setState(() {
        _mapIsReady = isReady;
      });
      
      // When map is ready, add markers if we have parking lots
      final state = context.read<ParkingMapBloc>().state;
      if (state.hasParkingLots) {
        // Small delay to ensure map is fully initialized
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && _mapIsReady) {
            _addParkingMarkers(state.parkingLots, state.selectedLot?.lotId);
          }
        });
      }
    }
  }

  /// Center map on user location (only once on initial load)
  Future<void> _centerOnUserLocation(
    GeoPoint userLocation, {
    bool force = false,
  }) async {
    if (_mapController == null || !_mapIsReady) return;

    // Only center automatically on first load, unless forced (by button)
    if (!force && _hasCenteredOnUserLocation) return;

    // Check if location actually changed
    if (!force && _lastUserLocation != null) {
      final latDiff = (userLocation.latitude - _lastUserLocation!.latitude)
          .abs();
      final lngDiff = (userLocation.longitude - _lastUserLocation!.longitude)
          .abs();
      if (latDiff < 0.0001 && lngDiff < 0.0001) {
        return; // Same location, don't center again
      }
    }

    try {
      // flutter_osm_plugin: goToLocation is deprecated; use moveTo
      await _mapController!.moveTo(userLocation, animate: true);
      _hasCenteredOnUserLocation = true;
      _lastUserLocation = userLocation;
    } catch (e) {
      debugPrint('Error centering on user location: $e');
    }
  }

  /// Go to my location button handler
  Future<void> _goToMyLocation() async {
    if (!_mapIsReady) {
      for (int i = 0; i < 30; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_mapIsReady && _mapController != null) break;
        if (!mounted) return;
      }
      if (!_mapIsReady || _mapController == null) return;
    }

    if (_mapController == null) return;

    final state = context.read<ParkingMapBloc>().state;
    
    if (state.userLocation != null) {
      // If we have location, center on it
      final userLocation = MapAdapter.toGeoPoint(state.userLocation!);
      await _centerOnUserLocation(userLocation, force: true);
    } else {
      // If no location, request it first
      context.read<ParkingMapBloc>().add(LoadUserLocation());
      
      // Wait a bit for location to load, then try again
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (!mounted) return;
      final updatedState = context.read<ParkingMapBloc>().state;
      if (updatedState.userLocation != null) {
        final userLocation = MapAdapter.toGeoPoint(updatedState.userLocation!);
        await _centerOnUserLocation(userLocation, force: true);
      }
    }
  }

  /// Add parking lot markers to map with selection support
  Future<void> _addParkingMarkers(
    List<ParkingLotEntity> parkingLots,
    int? selectedLotId,
  ) async {
    if (_mapController == null || !_mapIsReady) return;

    try {
      // Get current lot IDs
      final currentLotIds = parkingLots.map((lot) => lot.lotId).toSet();
      
      // Remove markers for lots that no longer exist
      final lotsToRemove = _addedMarkerLotIds.difference(currentLotIds);
      for (final lotId in lotsToRemove) {
        _addedMarkerLotIds.remove(lotId);
        // Note: flutter_osm_plugin doesn't have direct removeMarker by ID
        // We'll rely on addMarker overwriting for same location
      }

      // Initialize animation controllers for new markers
      for (final lot in parkingLots) {
        if (!_markerAnimationControllers.containsKey(lot.lotId)) {
          _markerAnimationControllers[lot.lotId] = AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: this,
          );
        }
      }

      // Remove animation controllers for markers that no longer exist
      final controllersToRemove = _markerAnimationControllers.keys
          .where((id) => !currentLotIds.contains(id))
          .toList();
      for (final id in controllersToRemove) {
        _markerAnimationControllers[id]?.dispose();
        _markerAnimationControllers.remove(id);
      }

      // Add markers for each parking lot (only if not already added)
      for (final lot in parkingLots) {
        // Skip if marker already added for this lot
        if (_addedMarkerLotIds.contains(lot.lotId)) {
          continue;
        }

        final marker = MapAdapter.parkingLotToMapMarker(lot);
        final geoPoint = MapAdapter.markerToGeoPoint(marker);
        final isSelected = selectedLotId != null && lot.lotId == selectedLotId;

        try {
          // Enhanced parking marker - Pin style (location_on) for better positioning
          // The pin shape (teardrop) points to the exact location
          await _mapController!.addMarker(
            geoPoint,
            markerIcon: MarkerIcon(
              icon: Icon(
                Icons.local_parking, // P icon - واضحة ومميزة للمواقف
                color: isSelected 
                    ? AppColors.primary 
                    : AppColors.primary.withValues(alpha: 0.85),
                size: isSelected ? 64 : 60, // حجم P للوضوح
                shadows: [
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.9),
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          );

          _addedMarkerLotIds.add(lot.lotId);

          // Animate marker when selected
          if (isSelected) {
            _markerAnimationControllers[lot.lotId]?.forward().then((_) {
              _markerAnimationControllers[lot.lotId]?.reverse();
            });
          }
        } catch (markerError) {
          // Marker add failed for this lot; continue with others
        }
      }
    } catch (e) {
      debugPrint('Error in _addParkingMarkers: $e');
    }
  }

  /// Find parking lot near clicked point and select it
  void _handleMapTap(GeoPoint point, List<ParkingLotEntity> parkingLots) {
    if (parkingLots.isEmpty) {
      // If tapping empty map, deselect
      context.read<ParkingMapBloc>().add(DeselectParkingLot());
      return;
    }

    // Find nearest parking lot within reasonable distance
    // Increased threshold for better tap detection
    const threshold = 0.001; // Approximate 100 meters in degrees
    ParkingLotEntity? nearestLot;
    double? nearestDistance;

    for (final lot in parkingLots) {
      final latDiff = (lot.latitude - point.latitude).abs();
      final lngDiff = (lot.longitude - point.longitude).abs();
      final distance = latDiff + lngDiff; // Simple distance calculation

      if (distance < threshold) {
        if (nearestLot == null ||
            distance < (nearestDistance ?? double.infinity)) {
          nearestLot = lot;
          nearestDistance = distance;
        }
      }
    }

    if (nearestLot != null) {
      // Found a parking lot near the tap - animate marker
      final controller = _markerAnimationControllers[nearestLot.lotId];
      if (controller != null) {
        controller.forward().then((_) {
          controller.reverse();
        });
      }
      // Select parking lot
      context.read<ParkingMapBloc>().add(
        SelectParkingLot(lotId: nearestLot.lotId),
      );
    } else {
      // If no parking lot found near tap, deselect
      context.read<ParkingMapBloc>().add(DeselectParkingLot());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.parkingMapTitle),
        actions: [
          _NotificationsIconButton(),
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: l10n.goToMyLocation,
            onPressed: _goToMyLocation,
          ),
        ],
      ),
      body: BlocConsumer<ParkingMapBloc, ParkingMapState>(
        listener: (context, state) {
          // Handle user location updates - center once on first load only
          if (state.userLocation != null && !_hasCenteredOnUserLocation) {
            final userLocation = MapAdapter.toGeoPoint(state.userLocation!);
            _centerOnUserLocation(userLocation);
          }

          // Handle parking lots updates
          if (state.hasParkingLots && _mapIsReady) {
            _addParkingMarkers(state.parkingLots, state.selectedLot?.lotId);
          }

          // Handle bottom sheet display
          if (state.hasSelection && !_isBottomSheetOpen) {
            // Open bottom sheet when a parking lot is selected
            _showBottomSheet(context, state);
          } else if (!state.hasSelection && _isBottomSheetOpen) {
            // Close bottom sheet when selection is cleared
            Navigator.of(context).pop();
            _isBottomSheetOpen = false;
          }
          // Note: If bottom sheet is already open and details are loaded,
          // BlocBuilder inside the sheet will update it automatically
        },
        builder: (context, state) {
          return _buildMapView(context, state);
        },
      ),
    );
  }

  Widget _buildMapView(BuildContext context, ParkingMapState state) {
    final l10n = AppLocalizations.of(context);
    // Show loading state
    if (state.isLoadingParkingLots && !state.hasParkingLots) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error state
    if (state.hasError && !state.hasParkingLots) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              '${l10n?.error ?? 'Error'}: ${state.errorMessage}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<ParkingMapBloc>().add(LoadParkingLots());
              },
              child: Text(l10n?.retry ?? 'Retry'),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (!state.isLoadingParkingLots &&
        !state.hasParkingLots &&
        !state.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_parking_outlined,
              size: 64,
              color: AppColors.secondaryText,
            ),
            const SizedBox(height: 16),
            Text(l10n?.noParkingLotsFound ?? 'No parking lots found'),
          ],
        ),
      );
    }

    // Show map
    if (_mapController != null) {
      return OSMFlutter(
        controller: _mapController!,
        osmOption: OSMOption(
          userTrackingOption: const UserTrackingOption(
            enableTracking: true, // تفعيل التتبع لإظهار السهم
            unFollowUser: true, // لا يتابع الموقع تلقائياً (لا يمركز تلقائياً)
          ),
          zoomOption: const ZoomOption(
            initZoom: 16.0, // زيادة zoom ابتدائي لدقة أفضل (كان 15)
            minZoomLevel: 3.0,
            maxZoomLevel: 19.0, // الحد الأقصى المسموح في OpenStreetMap
            stepZoom: 1.0,
          ),
          userLocationMarker: UserLocationMaker(
            // إلغاء personMarker (pin حمراء) - استخدام marker صغير جداً بدلاً من 0 لتجنب خطأ Invalid image dimensions
            personMarker: MarkerIcon(
              icon: Icon(
                Icons.location_on,
                color: Colors.transparent, // شفاف - لا يظهر pin
                size: 1, // حجم صغير جداً (1) لتجنب خطأ Invalid image dimensions
              ),
            ),
            directionArrowMarker: MarkerIcon(
              icon: Icon(
                Icons.navigation,
                color: AppColors.primary, // App primary color for direction arrow
                size: 60, // Larger size for better visibility (كان 32)
              ),
            ),
          ),
        ),
        onMapIsReady: mapIsReady,
        onGeoPointClicked: (GeoPoint point) {
          // Handle map tap - check if near a parking lot or deselect
          if (state.hasParkingLots) {
            _handleMapTap(point, state.parkingLots);
          }
        },
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  /// Show bottom sheet using showModalBottomSheet
  void _showBottomSheet(BuildContext context, ParkingMapState state) {
    if (!state.hasSelection || _isBottomSheetOpen) return;

    _isBottomSheetOpen = true;
    final bloc = context.read<ParkingMapBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (bottomSheetContext) => BlocProvider.value(
        value: bloc, // Provide the bloc to the bottom sheet context
        child: DraggableScrollableSheet(
          initialChildSize: 0.59, // Higher initial position
          minChildSize: 0.50, // Lower minimum to allow more scrolling
          maxChildSize: 0.60,
          builder: (sheetContext, scrollController) {
            // Use BlocBuilder to rebuild when state changes
            return BlocBuilder<ParkingMapBloc, ParkingMapState>(
              builder: (blocContext, currentState) {
                if (!currentState.hasSelection) {
                  // If selection is cleared, close the sheet
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (Navigator.of(bottomSheetContext).canPop()) {
                      Navigator.of(bottomSheetContext).pop();
                    }
                  });
                  return const SizedBox.shrink();
                }

                return ParkingDetailsBottomSheet(
                  selectedLot: currentState.selectedLot!,
                  details: currentState.selectedDetails,
                  isLoadingDetails: currentState.isLoadingDetails,
                  errorMessage: currentState.detailsErrorMessage,
                  scrollController: scrollController,
                  mapController: _mapController,
                  userLocation: currentState.userLocation,
                );
              },
            );
          },
        ),
      ),
    ).then((_) {
      // When bottom sheet is dismissed, deselect parking lot
      if (_isBottomSheetOpen) {
        _isBottomSheetOpen = false;
        if (!mounted) return;
        // Avoid using BuildContext across async gap
        bloc.add(DeselectParkingLot());
      }
    });
  }
}

/// Notifications Icon Button Widget
/// Displays notification icon with unread count badge
class _NotificationsIconButton extends StatefulWidget {
  const _NotificationsIconButton();

  @override
  State<_NotificationsIconButton> createState() =>
      _NotificationsIconButtonState();
}

class _NotificationsIconButtonState extends State<_NotificationsIconButton> {
  late NotificationsBloc _notificationsBloc;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    _notificationsBloc = getIt<NotificationsBloc>();
    // Load notifications once
    if (!_hasLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _notificationsBloc.add(GetAllNotificationsRequested());
        _hasLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _notificationsBloc,
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          int unreadCount = 0;
          if (state is NotificationsLoaded) {
            unreadCount = state.notifications.length;
          }

          final l10n = AppLocalizations.of(context);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                tooltip: l10n?.notificationsTitle ?? 'Notifications',
                onPressed: () {
                  context.push(Routes.notificationsPath);
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      unreadCount > 9 ? '9+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: AppColors.textOnPrimary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}


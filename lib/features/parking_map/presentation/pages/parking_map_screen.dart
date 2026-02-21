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
    with OSMMixinObserver {
  MapController? _mapController;
  bool _mapIsReady = false;
  GeoPoint? _initialCenter;
  bool _hasCenteredOnUserLocation = false;
  GeoPoint? _lastUserLocation;
  bool _isBottomSheetOpen = false;
  
  // Simplified marker tracking
  final Map<int, GeoPoint> _currentMarkers = {}; // Currently displayed markers
  bool _isRebuildingMarkers = false; // Lock for marker operations
  bool _needsRebuild = false; // Track if rebuild is needed after current one
  bool? _lastSearchModeState; // Track last search mode to detect changes
  DateTime? _lastSearchToggleTime; // Debounce search toggle
  int _lastParkingLotsCount = 0; // Track parking lots count to detect changes
  int _lastSearchResultsCount = 0; // Track search results count to detect changes

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
    super.dispose();
  }

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady && mounted) {
      setState(() {
        _mapIsReady = isReady;
      });
      
      // When map is ready, rebuild markers based on current state
      final state = context.read<ParkingMapBloc>().state;
      if (state.displayedParkingLots.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted && _mapIsReady) {
            _rebuildAllMarkers(state);
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

  /// Rebuild all markers based on current state
  /// This is the SINGLE source of truth for marker management
  Future<void> _rebuildAllMarkers(ParkingMapState state) async {
    if (_mapController == null || !_mapIsReady) return;
    
    // If already rebuilding, mark that we need to rebuild again after current one finishes
    if (_isRebuildingMarkers) {
      _needsRebuild = true;
      return;
    }
    
    _isRebuildingMarkers = true;
    _needsRebuild = false;
    
    try {
      // Step 1: Clear all existing markers
      for (final geoPoint in _currentMarkers.values) {
        try {
          await _mapController!.removeMarker(geoPoint);
        } catch (e) {
          // Ignore removal errors - marker might not exist
        }
      }
      _currentMarkers.clear();
      
      // Small delay to ensure markers are fully removed
      await Future.delayed(const Duration(milliseconds: 50));
      
      // Check if component is still mounted
      if (!mounted || _mapController == null) return;
      
      // Step 2: Determine which lots to show based on current mode
      final List<ParkingLotEntity> lotsToShow = [];
      final Set<int> searchLotIds = {};
      
      if (state.isSearchMode && state.searchedParkingLots.isNotEmpty) {
        // In search mode: show search results with red pins
        searchLotIds.addAll(state.searchedParkingLots.map((l) => l.lotId));
        lotsToShow.addAll(state.searchedParkingLots);
        
        // Also add other parking lots that aren't in search results (with P icon)
        for (final lot in state.parkingLots) {
          if (!searchLotIds.contains(lot.lotId)) {
            lotsToShow.add(lot);
          }
        }
      } else {
        // Normal mode: show all parking lots with P icons
        lotsToShow.addAll(state.parkingLots);
      }
      
      // Step 3: Add markers for all lots
      for (final lot in lotsToShow) {
        if (!mounted || _mapController == null) return;
        
        final marker = MapAdapter.parkingLotToMapMarker(lot);
        final geoPoint = MapAdapter.markerToGeoPoint(marker);
        final isSearchResult = searchLotIds.contains(lot.lotId);
        final isSelected = state.selectedLot?.lotId == lot.lotId;
        
        // Determine marker style
        final Color markerColor;
        final IconData markerIcon;
        
        if (isSearchResult) {
          markerColor = AppColors.error;
          markerIcon = Icons.location_on;
        } else {
          markerColor = ParkingOccupancyColors.getColor(
            availableSpaces: lot.displayAvailableSpaces,
            totalSpaces: lot.totalSpaces,
          );
          markerIcon = Icons.local_parking;
        }
        
        try {
          await _mapController!.addMarker(
            geoPoint,
            markerIcon: MarkerIcon(
              icon: Icon(
                markerIcon,
                color: isSelected 
                    ? markerColor 
                    : markerColor.withValues(alpha: 0.85),
                size: isSelected ? 64 : 60,
                shadows: [
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.9),
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: markerColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          );
          
          _currentMarkers[lot.lotId] = geoPoint;
        } catch (e) {
          debugPrint('Error adding marker for lot ${lot.lotId}: $e');
        }
      }
    } catch (e) {
      debugPrint('Error in _rebuildAllMarkers: $e');
    } finally {
      _isRebuildingMarkers = false;
      
      // If another rebuild was requested while we were rebuilding, do it now
      if (_needsRebuild && mounted) {
        final currentState = context.read<ParkingMapBloc>().state;
        _rebuildAllMarkers(currentState);
      }
    }
  }

  /// Find parking lot near clicked point and select it
  /// Searches in ALL parking lots, not just displayed ones
  void _handleMapTap(GeoPoint point, List<ParkingLotEntity> displayedParkingLots) {
    final state = context.read<ParkingMapBloc>().state;
    
    // Build a list of all parking lots to search (including full ones)
    final allLotsToSearch = <ParkingLotEntity>[];
    allLotsToSearch.addAll(state.parkingLots);
    
    // Add search results if in search mode (to prioritize them)
    if (state.isSearchMode && state.searchedParkingLots.isNotEmpty) {
      for (final lot in state.searchedParkingLots) {
        if (!allLotsToSearch.any((l) => l.lotId == lot.lotId)) {
          allLotsToSearch.insert(0, lot);
        }
      }
    }
    
    if (allLotsToSearch.isEmpty) {
      context.read<ParkingMapBloc>().add(DeselectParkingLot());
      return;
    }

    // Find nearest parking lot within reasonable distance
    const threshold = 0.001; // Approximate 100 meters in degrees
    ParkingLotEntity? nearestLot;
    double? nearestDistance;

    for (final lot in allLotsToSearch) {
      final latDiff = (lot.latitude - point.latitude).abs();
      final lngDiff = (lot.longitude - point.longitude).abs();
      final distance = latDiff + lngDiff;

      if (distance < threshold) {
        if (nearestLot == null ||
            distance < (nearestDistance ?? double.infinity)) {
          nearestLot = lot;
          nearestDistance = distance;
        }
      }
    }

    if (nearestLot != null) {
      context.read<ParkingMapBloc>().add(
        SelectParkingLot(lotId: nearestLot.lotId),
      );
    } else {
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
          // Search Nearby Button in AppBar
          BlocBuilder<ParkingMapBloc, ParkingMapState>(
            builder: (context, state) {
              return IconButton(
                icon: state.isLoadingSearch
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).appBarTheme.iconTheme?.color ?? 
                                AppColors.primary,
                          ),
                        ),
                      )
                    : Icon(
                        state.isSearchMode ? Icons.search_off : Icons.search,
                      ),
                tooltip: state.isSearchMode 
                    ? (l10n.cancelSearch)
                    : (l10n.searchNearbyParking),
                onPressed: state.isLoadingSearch
                    ? null
                    : () => _onSearchNearbyPressed(context, state),
              );
            },
          ),
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

          // Rebuild markers only when necessary
          if (_mapIsReady) {
            final searchModeChanged = _lastSearchModeState != state.isSearchMode;
            final parkingLotsChanged = _lastParkingLotsCount != state.parkingLots.length;
            final searchResultsChanged = _lastSearchResultsCount != state.searchedParkingLots.length;
            
            // Only rebuild if something actually changed
            if (searchModeChanged || parkingLotsChanged || searchResultsChanged) {
              _lastSearchModeState = state.isSearchMode;
              _lastParkingLotsCount = state.parkingLots.length;
              _lastSearchResultsCount = state.searchedParkingLots.length;
              _rebuildAllMarkers(state);
            }
          }

          // Handle bottom sheet display
          if (state.hasSelection && !_isBottomSheetOpen) {
            _showBottomSheet(context, state);
          } else if (!state.hasSelection && _isBottomSheetOpen) {
            Navigator.of(context).pop();
            _isBottomSheetOpen = false;
          }
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

    // Show empty state (only when not in search mode)
    if (!state.isLoadingParkingLots &&
        !state.hasParkingLots &&
        !state.hasError &&
        !state.isSearchMode) {
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
      return Stack(
        children: [
          OSMFlutter(
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
              if (state.displayedParkingLots.isNotEmpty) {
                _handleMapTap(point, state.displayedParkingLots);
              }
            },
          ),
          // Search status indicator (auto-dismissing)
          if (state.isSearchMode)
            _SearchModeIndicator(
              key: ValueKey('search_indicator_${state.searchedParkingLots.length}'),
              state: state,
              l10n: l10n,
            ),
        ],
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  /// Handle search nearby button press with debouncing
  Future<void> _onSearchNearbyPressed(
    BuildContext context, 
    ParkingMapState state,
  ) async {
    // Debounce rapid clicks - ignore if less than 500ms since last toggle
    final now = DateTime.now();
    if (_lastSearchToggleTime != null && 
        now.difference(_lastSearchToggleTime!) < const Duration(milliseconds: 500)) {
      return; // Ignore rapid clicks
    }
    _lastSearchToggleTime = now;
    
    // If already in search mode, toggle off and zoom back in
    if (state.isSearchMode) {
      // Cancel search in bloc - this will trigger listener to rebuild markers
      context.read<ParkingMapBloc>().add(CancelSearchNearbyParking());
      
      // Zoom back to normal level when exiting search mode
      if (_mapController != null && _mapIsReady) {
        try {
          await _mapController!.setZoom(zoomLevel: 16.0);
        } catch (e) {
          debugPrint('Error zooming in: $e');
        }
      }
      return;
    }

    // Zoom out to show more parking lots in the area
    if (_mapController != null && _mapIsReady) {
      try {
        await _mapController!.setZoom(zoomLevel: 13.0);
      } catch (e) {
        debugPrint('Error zooming out: $e');
      }
    }

    // Check if we have user location
    if (state.userLocation != null) {
      context.read<ParkingMapBloc>().add(
        SearchNearbyParking(
          latitude: state.userLocation!.latitude,
          longitude: state.userLocation!.longitude,
        ),
      );
    } else {
      // Request location first
      context.read<ParkingMapBloc>().add(LoadUserLocation());
      
      // Wait for location to load
      await Future.delayed(const Duration(milliseconds: 1500));
      
      if (!mounted) return;
      
      final updatedState = context.read<ParkingMapBloc>().state;
      if (updatedState.userLocation != null) {
        context.read<ParkingMapBloc>().add(
          SearchNearbyParking(
            latitude: updatedState.userLocation!.latitude,
            longitude: updatedState.userLocation!.longitude,
          ),
        );
      }
    }
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
          // Use unreadCount from server for accurate badge count
          int unreadCount = 0;
          if (state is NotificationsLoaded) {
            unreadCount = state.unreadCount;
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

/// Auto-dismissing Search Mode Indicator Widget
/// Shows search status and automatically hides after a few seconds
class _SearchModeIndicator extends StatefulWidget {
  final ParkingMapState state;
  final AppLocalizations? l10n;

  const _SearchModeIndicator({
    super.key,
    required this.state,
    required this.l10n,
  });

  @override
  State<_SearchModeIndicator> createState() => _SearchModeIndicatorState();
}

class _SearchModeIndicatorState extends State<_SearchModeIndicator>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.value = 1.0; // Start visible
    
    // Auto-dismiss after 4 seconds if not loading
    _scheduleAutoDismiss();
  }

  void _scheduleAutoDismiss() {
    // Don't auto-dismiss while loading
    if (widget.state.isLoadingSearch) return;
    
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && _isVisible && !widget.state.isLoadingSearch) {
        _dismissIndicator();
      }
    });
  }

  @override
  void didUpdateWidget(_SearchModeIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If loading state changed from true to false, schedule auto-dismiss
    if (oldWidget.state.isLoadingSearch && !widget.state.isLoadingSearch) {
      // Show the indicator again when results come in
      setState(() {
        _isVisible = true;
      });
      _animationController.value = 1.0;
      _scheduleAutoDismiss();
    }
  }

  void _dismissIndicator() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    final resultsCount = widget.state.searchedParkingLots.length;
    final String message;
    
    if (widget.state.isLoadingSearch) {
      message = widget.l10n?.searchingNearbyParking ?? 'Searching nearby parking...';
    } else if (widget.state.hasSearchError) {
      message = widget.state.searchErrorMessage ?? (widget.l10n?.searchError ?? 'Search failed');
    } else if (resultsCount == 0) {
      message = widget.l10n?.noNearbyParkingFound ?? 'No nearby parking found';
    } else {
      message = '${widget.l10n?.foundNearbyParking ?? 'Found'} $resultsCount ${widget.l10n?.parkingLots ?? 'parking lots'}';
    }

    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.state.hasSearchError 
                ? AppColors.error.withValues(alpha: 0.9)
                : AppColors.primary.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (widget.state.isLoadingSearch)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                Icon(
                  widget.state.hasSearchError 
                      ? Icons.error_outline
                      : resultsCount == 0 
                          ? Icons.search_off 
                          : Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _dismissIndicator,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

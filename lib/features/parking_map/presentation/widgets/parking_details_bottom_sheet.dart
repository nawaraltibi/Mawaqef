import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/map/map_point.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/map/map_adapter.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/parking_lot_entity.dart';
import '../../domain/entities/parking_details_entity.dart';
import '../../../../features/parking/models/parking_model.dart';
import '../../../../features/vehicles/data/models/vehicle_model.dart';
import '../../../../features/vehicles/domain/entities/vehicle_entity.dart';
import '../../../../features/vehicles/domain/usecases/get_vehicles_usecase.dart';

/// Parking Details Bottom Sheet
/// Modern bottom sheet inspired by reference designs
/// Shows parking lot details with smooth animations
class ParkingDetailsBottomSheet extends StatefulWidget {
  final ParkingLotEntity selectedLot;
  final ParkingDetailsEntity? details;
  final bool isLoadingDetails;
  final String? errorMessage;
  final ScrollController scrollController;
  final MapController? mapController;
  final MapPoint? userLocation;

  const ParkingDetailsBottomSheet({
    super.key,
    required this.selectedLot,
    required this.scrollController,
    this.details,
    this.isLoadingDetails = false,
    this.errorMessage,
    this.mapController,
    this.userLocation,
  });

  @override
  State<ParkingDetailsBottomSheet> createState() =>
      _ParkingDetailsBottomSheetState();
}

class _ParkingDetailsBottomSheetState extends State<ParkingDetailsBottomSheet> {
  static GeoPoint?
  _lastDrawnRoadDestination; // Track last drawn road (static to share across instances)
  static GeoPoint?
  _lastDestinationPin; // Track last destination pin location to remove it

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Size to content
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Content - All in one scrollable column
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Parking name
                  Text(
                    widget.selectedLot.lotName,
                    style: AppTextStyles.titleLarge(
                      context,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Address
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.selectedLot.address,
                          style: AppTextStyles.bodyMedium(
                            context,
                          ).copyWith(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Loading or content
                  if (widget.isLoadingDetails)
                    _buildLoadingSkeleton()
                  else if (widget.errorMessage != null)
                    _buildErrorState(context, widget.errorMessage!)
                  else if (widget.details != null)
                    _buildDetailsContent(context, widget.details!)
                  else
                    _buildBasicInfo(context, widget.selectedLot),

                  const SizedBox(height: 16),

                  // Action buttons - Now part of the scrollable content
                  if (widget.details != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: _buildSecondaryButton(
                        context,
                        icon: Icons.directions,
                        label: AppLocalizations.of(context)?.getDirections ?? 'Get Directions',
                        onPressed: _handleGetDirections,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Primary CTA button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.details != null
                          ? () => _handleSelectAndPay(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)?.selectAndPay ?? 'Select and Pay',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.details != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${widget.details!.hourlyRate.toStringAsFixed(2)} ${AppLocalizations.of(context)?.perHour ?? 'per hour'}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  // Reduced bottom padding to minimize empty space
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Availability skeleton
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 16),
        // Info skeleton
        Container(
          height: 20,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 20,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  /// Handle get directions button
  Future<void> _handleGetDirections() async {
    if (widget.mapController == null ||
        widget.userLocation == null ||
        widget.details == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.parkingLocationError ??
                'Unable to get your location. Please select a location on the map.',
          ),
        ),
      );
      return;
    }

    try {
      // Remove previous road if exists
      if (_lastDrawnRoadDestination != null) {
        await widget.mapController!.removeLastRoad();
      }
      if (!mounted) return;

      // Get user location and parking location
      final userGeoPoint = MapAdapter.toGeoPoint(widget.userLocation!);
      final parkingGeoPoint = GeoPoint(
        latitude: widget.details!.latitude,
        longitude: widget.details!.longitude,
      );

      // Try to draw road with retry mechanism (OSRM sometimes fails)
      RoadInfo? roadInfo;
      int retryCount = 0;
      const maxRetries = 2;

      while (retryCount <= maxRetries && mounted) {
        try {
          // Draw elegant route from user location to parking lot
          // Using app primary color with thicker width for better visibility
          roadInfo = await widget.mapController!.drawRoad(
            userGeoPoint,
            parkingGeoPoint,
            roadType: RoadType.car,
            roadOption: RoadOption(
              roadColor: AppColors.primary, // App primary blue color
              roadWidth: 60, // Thicker for better visibility and clarity
              zoomInto: true,
            ),
          );
          break; // Success, exit retry loop
        } catch (retryError) {
          retryCount++;
          if (retryCount > maxRetries) {
            // All retries failed, rethrow the last error
            rethrow;
          }

          // Wait before retrying
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }

      if (!mounted || roadInfo == null) return;

      _lastDrawnRoadDestination = parkingGeoPoint;

      // Remove previous destination pin if exists
      // Use a small offset for red pin to avoid removing parking lot marker (P)
      if (_lastDestinationPin != null) {
        try {
          await widget.mapController!.removeMarker(_lastDestinationPin!);
        } catch (removeError) {
          // If removeMarker doesn't work, we'll add the new marker anyway
        }
      }

      // Add large red pin marker at parking destination with small offset
      // This offset ensures the red pin doesn't overlap exactly with parking marker (P)
      // and allows us to remove it without affecting the parking marker
      try {
        // Small offset (about 5-10 meters) to avoid exact overlap with parking marker
        const offset = 0.0001; // Approximately 10 meters
        final pinLocation = GeoPoint(
          latitude: parkingGeoPoint.latitude + offset,
          longitude: parkingGeoPoint.longitude,
        );

        await widget.mapController!.addMarker(
          pinLocation,
          markerIcon: MarkerIcon(
            icon: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 80, // Large red pin at destination (يمكن تعديل الحجم هنا)
            ),
          ),
        );
        _lastDestinationPin = pinLocation;
      } catch (markerError) {
        debugPrint('Error adding destination marker: $markerError');
      }

      // Close bottom sheet to show the map with directions
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show success message after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          final distanceKm = (roadInfo!.distance ?? 0).toStringAsFixed(2);
          final loc = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${loc?.getDirections ?? 'Get Directions'}: $distanceKm km',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      });
    } catch (e) {
      debugPrint('Error drawing road: $e');
      if (!mounted) return;

      final loc = AppLocalizations.of(context);
      final errorMessage = e.toString().toLowerCase();
      String userMessage;

      if (errorMessage.contains('json') ||
          errorMessage.contains('exit') ||
          errorMessage.contains('parsing')) {
        userMessage = loc?.routingServiceError ?? 'Routing service is temporarily unavailable.';
      } else if (errorMessage.contains('network') ||
          errorMessage.contains('connection') ||
          errorMessage.contains('timeout')) {
        userMessage = loc?.routingNetworkError ?? 'Network error. Please check your connection.';
      } else {
        userMessage =
            '${loc?.error ?? 'Error'}: ${loc?.routingFailed ?? 'Failed to get directions.'}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userMessage),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  /// Handle select and pay button - Navigate to booking pre payment screen
  Future<void> _handleSelectAndPay(BuildContext context) async {
    if (widget.details == null) return;

      final router = GoRouter.of(context);

    try {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      await Future.delayed(const Duration(milliseconds: 200));

      final rootContext = router.routerDelegate.navigatorKey.currentContext;
      if (rootContext == null) return;

      // Show loading indicator
      showDialog(
        context: rootContext,
        barrierDismissible: false,
        builder: (dialogContext) =>
            const Center(child: CircularProgressIndicator()),
      );

      // Fetch vehicles
      final getVehiclesUseCase = getIt<GetVehiclesUseCase>();
      final vehiclesEntities = await getVehiclesUseCase();

      // Convert entities to models
      final vehicles = vehiclesEntities
          .map((entity) => _vehicleEntityToModel(entity))
          .toList();

      // Convert parking details to parking model
      final parking = _parkingDetailsToModel(widget.details!);

      // Close loading dialog
      if (rootContext.mounted && Navigator.of(rootContext).canPop()) {
        Navigator.of(rootContext).pop();
      }

      // Navigate to booking pre payment screen
      router.push(
        Routes.userMainBookingsPrePaymentPath,
        extra: {'parking': parking, 'vehicles': vehicles},
      );
    } catch (e) {
      debugPrint('Error in _handleSelectAndPay: $e');

      final rootContext = router.routerDelegate.navigatorKey.currentContext;
      if (rootContext != null && rootContext.mounted) {
        if (Navigator.of(rootContext).canPop()) {
          Navigator.of(rootContext).pop();
        }
        final l10n = AppLocalizations.of(rootContext);
        ScaffoldMessenger.of(rootContext).showSnackBar(
          SnackBar(
            content: Text(l10n?.error ?? 'Error'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Convert ParkingDetailsEntity to ParkingModel
  ParkingModel _parkingDetailsToModel(ParkingDetailsEntity details) {
    return ParkingModel(
      lotId: details.lotId,
      lotName: details.lotName,
      address: details.address,
      latitude: details.latitude,
      longitude: details.longitude,
      totalSpaces: details.totalSpaces,
      availableSpaces: details.availableSpaces,
      hourlyRate: details.hourlyRate,
      status: details.status,
      statusRequest: details.statusRequest,
      userId: details.userId,
      createdAt: details.createdAt,
      updatedAt: details.updatedAt,
    );
  }

  /// Convert VehicleEntity to VehicleModel
  VehicleModel _vehicleEntityToModel(VehicleEntity entity) {
    return VehicleModel(
      vehicleId: entity.vehicleId,
      platNumber: entity.platNumber,
      carMake: entity.carMake,
      carModel: entity.carModel,
      color: entity.color,
      status: entity.status,
      requestStatus: entity.requestStatus,
      userId: entity.userId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(error, style: TextStyle(color: Colors.red[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context, ParkingLotEntity lot) {
    // Get color based on availability
    final occupancyColor = ParkingOccupancyColors.getColor(
      availableSpaces: lot.displayAvailableSpaces,
      totalSpaces: lot.totalSpaces,
    );
    
    // Determine status text based on occupancy
    String statusText;
    if (lot.isFull) {
      statusText = AppLocalizations.of(context)!.full;
    } else if (lot.displayAvailableSpaces < (lot.totalSpaces * 0.3).ceil()) {
      statusText = AppLocalizations.of(context)!.limited;
    } else {
      statusText = AppLocalizations.of(context)!.available;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Available spaces - using camera-based display values
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: occupancyColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: occupancyColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.local_parking, color: occupancyColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${lot.displayAvailableSpaces} / ${lot.totalSpaces}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: occupancyColor,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.availableParkingSpaces,
                      style: TextStyle(fontSize: 12, color: occupancyColor.withValues(alpha: 0.8)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: occupancyColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Price
        Row(
          children: [
            Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              '${lot.hourlyRate.toStringAsFixed(2)} ${AppLocalizations.of(context)!.perHour}',
              style: AppTextStyles.bodyMedium(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsContent(
    BuildContext context,
    ParkingDetailsEntity details,
  ) {
    // Get color based on availability
    final occupancyColor = ParkingOccupancyColors.getColor(
      availableSpaces: details.displayAvailableSpaces,
      totalSpaces: details.totalSpaces,
    );
    
    // Determine status text based on occupancy
    String statusText;
    if (details.isFull) {
      statusText = AppLocalizations.of(context)!.full;
    } else if (details.displayAvailableSpaces < (details.totalSpaces * 0.3).ceil()) {
      statusText = AppLocalizations.of(context)!.limited;
    } else {
      statusText = AppLocalizations.of(context)!.available;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Available spaces with details - using camera-based display values
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: occupancyColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: occupancyColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_parking,
                color: occupancyColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${details.displayAvailableSpaces} / ${details.totalSpaces}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: occupancyColor,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.availableParkingSpaces,
                      style: TextStyle(
                        fontSize: 12,
                        color: occupancyColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: occupancyColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Price per hour
        Row(
          children: [
            Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              '${details.hourlyRate.toStringAsFixed(2)} ${AppLocalizations.of(context)!.perHour}',
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Payment hours (if available)
        Row(
          children: [
            Icon(Icons.payment, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.paymentHoursApply,
              style: AppTextStyles.bodyMedium(
                context,
              ).copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

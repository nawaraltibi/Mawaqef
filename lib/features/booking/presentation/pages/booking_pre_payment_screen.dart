import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/core.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../data/repositories/auth_local_repository.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/create_booking/create_booking_bloc.dart';
import '../../core/utils/booking_navigation_helper.dart';
import '../../../parking/models/parking_model.dart';
import '../../../parking_map/domain/entities/parking_details_entity.dart';
import '../../../parking_map/domain/usecases/get_parking_details_usecase.dart';
import '../../../vehicles/data/models/vehicle_model.dart';
import '../../../vehicles/domain/entities/vehicle_entity.dart';
import '../../../vehicles/domain/usecases/get_vehicles_usecase.dart';
import '../widgets/booking_pre_payment_header.dart';
import '../widgets/booking_pre_payment_info_card.dart';
import '../widgets/booking_pre_payment_time_selector.dart';
import '../widgets/booking_pre_payment_vehicle_selector.dart';
import '../widgets/booking_pre_payment_price_summary.dart';
import '../widgets/booking_pre_payment_cta_button.dart';

/// Booking Pre-Payment Screen
/// UI screen for selecting time, vehicle, and reviewing booking details before payment
///
/// This screen allows users to:
/// - View parking details
/// - Select booking duration (1 hour, 2 hours, or custom)
/// - Select a vehicle
/// - Review total price
/// - Proceed to payment
class BookingPrePaymentScreen extends StatefulWidget {
  final ParkingModel parking;
  final List<VehicleModel> vehicles;

  const BookingPrePaymentScreen({
    super.key,
    required this.parking,
    required this.vehicles,
  });

  @override
  State<BookingPrePaymentScreen> createState() =>
      _BookingPrePaymentScreenState();
}

class _BookingPrePaymentScreenState extends State<BookingPrePaymentScreen> {
  int? _selectedVehicleId;
  int _selectedHours = 1;
  bool _isCustomTime = false;
  final TextEditingController _customHoursController = TextEditingController();
  late List<VehicleModel> _vehicles;
  late ParkingModel _parking;

  @override
  void initState() {
    super.initState();
    _parking = widget.parking;
    _vehicles = widget.vehicles;
    // Initialize with first vehicle if available
    if (_vehicles.isNotEmpty) {
      _selectedVehicleId = _vehicles.first.vehicleId;
      // Update bloc with initial values
      context.read<CreateBookingBloc>().add(
        UpdateVehicleId(_vehicles.first.vehicleId),
      );
    }
    // Initialize hours
    context.read<CreateBookingBloc>().add(const UpdateHours(1));
    // Initialize lot ID
    context.read<CreateBookingBloc>().add(UpdateLotId(_parking.lotId));

    // Listen to custom hours input changes
    _customHoursController.addListener(_onCustomHoursChanged);

    // جلب تفاصيل الموقف من الـ API عند فتح الصفحة (أو العودة إليها) لتحديث عدد المواقف الفاضية
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshParkingDetails());
  }

  /// إعادة جلب تفاصيل الموقف من الـ API لتحديث availableSpaces (مثلاً بعد العودة من تفاصيل الحجز)
  Future<void> _refreshParkingDetails() async {
    try {
      final details = await getIt<GetParkingDetailsUseCase>().call(
        lotId: _parking.lotId,
      );
      if (!mounted) return;
      setState(() {
        _parking = _parkingDetailsToModel(details);
      });
    } catch (e) {
      debugPrint('Error refreshing parking details: $e');
    }
  }

  ParkingModel _parkingDetailsToModel(ParkingDetailsEntity e) {
    return ParkingModel(
      lotId: e.lotId,
      lotName: e.lotName,
      address: e.address,
      latitude: e.latitude,
      longitude: e.longitude,
      totalSpaces: e.totalSpaces,
      availableSpaces: e.availableSpaces,
      hourlyRate: e.hourlyRate,
      status: e.status,
      statusRequest: e.statusRequest,
      userId: e.userId,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  /// Refresh vehicles list after adding a new vehicle
  Future<void> _refreshVehicles() async {
    try {
      final getVehiclesUseCase = getIt<GetVehiclesUseCase>();
      final vehiclesEntities = await getVehiclesUseCase();

      // Convert entities to models
      final vehicles = vehiclesEntities
          .map((entity) => _vehicleEntityToModel(entity))
          .toList();

      setState(() {
        _vehicles = vehicles;
        // Select first vehicle if available and none selected
        if (_vehicles.isNotEmpty && _selectedVehicleId == null) {
          _selectedVehicleId = _vehicles.first.vehicleId;
          context.read<CreateBookingBloc>().add(
            UpdateVehicleId(_vehicles.first.vehicleId),
          );
        }
      });
    } catch (e) {
      debugPrint('Error refreshing vehicles: $e');
    }
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

  @override
  void dispose() {
    _customHoursController.dispose();
    super.dispose();
  }

  void _onCustomHoursChanged() {
    if (_isCustomTime && _customHoursController.text.isNotEmpty) {
      final hours = int.tryParse(_customHoursController.text) ?? 1;
      if (hours > 0) {
        setState(() {
          _selectedHours = hours;
        });
        context.read<CreateBookingBloc>().add(UpdateHours(hours));
      }
    }
  }

  void _onTimeSelected(int hours, bool isCustom) {
    setState(() {
      _selectedHours = hours;
      _isCustomTime = isCustom;
    });
    context.read<CreateBookingBloc>().add(UpdateHours(hours));
  }

  void _onVehicleSelected(int vehicleId) {
    setState(() {
      _selectedVehicleId = vehicleId;
    });
    context.read<CreateBookingBloc>().add(UpdateVehicleId(vehicleId));
  }

  void _onContinue() {
    if (_selectedVehicleId == null) {
      // Show error - vehicle must be selected
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.bookingPrePaymentChooseVehicleRequired),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    // Submit create booking request
    // This will trigger CreateBookingSuccess state, which will navigate to payment
    context.read<CreateBookingBloc>().add(const SubmitCreateBooking());
  }

  double _calculateTotalPrice() {
    return _parking.hourlyRate * _selectedHours;
  }

  /// Handle booking creation success
  void _handleBookingSuccess(
    BuildContext context,
    CreateBookingSuccess state,
    AppLocalizations l10n,
  ) {
    final bookingId = state.response.data?.bookingId;
    if (bookingId == null || bookingId == 0) {
      UnifiedSnackbar.error(context, message: l10n.errorBookingIdMissing);
      return;
    }

    final selectedVehicle = _vehicles.firstWhere(
      (v) => v.vehicleId == _selectedVehicleId,
      orElse: () => _vehicles.first,
    );

    final bookingData = BookingNavigationHelper.extractBookingData(
      response: state.response,
      parking: _parking,
      vehicle: selectedVehicle,
      selectedHours: _selectedHours,
      calculatedTotal: _calculateTotalPrice(),
    );

    BookingNavigationHelper.navigateToPayment(
      context: context,
      parking: bookingData['parking'] as ParkingModel,
      vehicle: bookingData['vehicle'] as VehicleModel,
      hours: bookingData['hours'] as int,
      totalAmount: bookingData['totalAmount'] as double,
      bookingId: bookingData['bookingId'] as int,
      startTime: bookingData['startTime'] as DateTime?,
      endTime: bookingData['endTime'] as DateTime?,
    );
  }

  /// Handle booking creation failure
  void _handleBookingFailure(
    BuildContext context,
    CreateBookingFailure state,
    AppLocalizations l10n,
  ) {
    // Handle 409 Conflict - existing booking with same details
    if (state.statusCode == 409 && state.responseData != null) {
      final selectedVehicle = _vehicles.firstWhere(
        (v) => v.vehicleId == _selectedVehicleId,
        orElse: () => _vehicles.first,
      );

      final bookingData = BookingNavigationHelper.extractBookingDataFromError(
        responseData: state.responseData!,
        parking: _parking,
        vehicle: selectedVehicle,
        selectedHours: _selectedHours,
        calculatedTotal: _calculateTotalPrice(),
      );

      if (bookingData != null) {
        BookingNavigationHelper.navigateToPayment(
          context: context,
          parking: bookingData['parking'] as ParkingModel,
          vehicle: bookingData['vehicle'] as VehicleModel,
          hours: bookingData['hours'] as int,
          totalAmount: bookingData['totalAmount'] as double,
          bookingId: bookingData['bookingId'] as int,
          startTime: bookingData['startTime'] as DateTime?,
          endTime: bookingData['endTime'] as DateTime?,
        );
        return;
      }
    }

    // Map internal error codes and API messages to localized messages
    String message;
    if (state.error == 'invalid_booking_data') {
      message = l10n.invalidHours;
    } else if (state.error == 'The square is full') {
      // Translate hardcoded API message to localized string
      message = l10n.parkingLotFull;
    } else {
      message = state.error;
    }
    UnifiedSnackbar.error(context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final userType = await AuthLocalRepository.getUserType();
        if (!context.mounted) return;
        if (userType == 'owner') {
          context.goAndClearStack(Routes.ownerMainPath);
        } else {
          context.goAndClearStack(Routes.userMainHomePath);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: true,
        body: BlocListener<CreateBookingBloc, CreateBookingState>(
          listener: (context, state) {
            if (state is CreateBookingSuccess) {
              _handleBookingSuccess(context, state, l10n);
            } else if (state is CreateBookingFailure) {
              _handleBookingFailure(context, state, l10n);
            }
          },
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

                return RepaintBoundary(
                  child: Column(
                    children: [
                      // Scrollable content (including header)
                      Flexible(
                        child: SingleChildScrollView(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Header with parking image and title - Now scrollable
                              BookingPrePaymentHeader(parking: _parking),

                              // Content padding
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 16.h),

                                    // Parking Info Card
                                    BookingPrePaymentInfoCard(
                                      parking: _parking,
                                    ),

                                    SizedBox(height: 24.h),

                                    // Payment Hours Info
                                    _buildPaymentHoursInfo(l10n),

                                    SizedBox(height: 24.h),

                                    // Time Selection Section
                                    Text(
                                      l10n.bookingPrePaymentChooseTime,
                                      style: AppTextStyles.titleMedium(
                                        context,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    BookingPrePaymentTimeSelector(
                                      selectedHours: _selectedHours,
                                      isCustom: _isCustomTime,
                                      onTimeSelected: _onTimeSelected,
                                    ),

                                    // Custom hours input field
                                    if (_isCustomTime) ...[
                                      SizedBox(height: 12.h),
                                      TextField(
                                        controller: _customHoursController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: l10n.enterHours,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: AppColors.surface,
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16.w,
                                            vertical: 14.h,
                                          ),
                                        ),
                                      ),
                                    ],

                                    SizedBox(height: 24.h),

                                    // Vehicle Selection Section
                                    Text(
                                      l10n.bookingPrePaymentChooseVehicleRequired,
                                      style: AppTextStyles.titleMedium(
                                        context,
                                        color: AppColors.primaryText,
                                      ),
                                    ),
                                    SizedBox(height: 12.h),
                                    BookingPrePaymentVehicleSelector(
                                      vehicles: _vehicles,
                                      selectedVehicleId: _selectedVehicleId,
                                      onVehicleSelected: _onVehicleSelected,
                                      onVehicleAdded: _refreshVehicles,
                                      parking: _parking,
                                    ),

                                    SizedBox(height: 16.h),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Price Summary and CTA - أنيميشن للـ padding مع فتح/إغلاق الكيبورد
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 12.h,
                          bottom: keyboardHeight > 0
                              ? keyboardHeight + 12.h
                              : 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BookingPrePaymentPriceSummary(
                              hourlyRate: _parking.hourlyRate,
                              hours: _selectedHours,
                              totalPrice: _calculateTotalPrice(),
                            ),
                            SizedBox(height: 12.h),
                            BookingPrePaymentCtaButton(
                              onPressed: _selectedVehicleId != null
                                  ? _onContinue
                                  : null,
                              isLoading:
                                  context.watch<CreateBookingBloc>().state
                                      is CreateBookingLoading,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentHoursInfo(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, size: 20.sp, color: AppColors.secondaryText),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              l10n.bookingPrePaymentPaymentHours,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

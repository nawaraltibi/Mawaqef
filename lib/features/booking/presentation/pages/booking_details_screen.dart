import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import '../../../../core/core.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/bookings_list_refresh_notifier.dart';
import '../../../../core/services/home_refresh_notifier.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../bloc/booking_details/booking_details_bloc.dart';
import '../../bloc/booking_action/booking_action_bloc.dart';
import '../../models/remaining_time_response.dart';
import '../../repository/booking_repository.dart';
import '../../../parking/models/parking_model.dart';
import '../../../vehicles/domain/usecases/get_vehicles_usecase.dart';
import '../../../vehicles/data/models/vehicle_model.dart';
import '../../../file_downloader/bloc/file_download_bloc.dart';
import '../../../file_downloader/bloc/file_download_event.dart';
import '../../../file_downloader/bloc/file_download_state.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../widgets/remaining_time_card.dart';
import '../widgets/booking_info_card.dart';
import '../widgets/shared/date_time_formatter.dart';
import '../widgets/vehicle_info_card.dart';
import '../widgets/time_info_section.dart';
import '../widgets/payment_summary_card.dart';
import '../widgets/booking_action_buttons.dart';

/// Booking Details Screen
/// Displays active/completed booking details with real-time remaining time
class BookingDetailsScreen extends StatefulWidget {
  final int bookingId;
  /// مصدر الدخول: 'home' أو 'bookings' — يحدد أين نرجع بعد إلغاء الحجز
  final String openedFrom;

  const BookingDetailsScreen({
    super.key,
    required this.bookingId,
    this.openedFrom = 'home',
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  late final BookingDetailsBloc _bookingDetailsBloc;
  bool _isDownloadingInvoice = false;
  bool _invoiceDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _bookingDetailsBloc = BookingDetailsBloc();

    // Load booking details
    // Use WidgetsBinding to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bookingDetailsBloc.add(LoadBookingDetails(bookingId: widget.bookingId));
    });

    // Start remaining time timer for active bookings
    // Timer will be started after booking details are loaded
  }

  @override
  void dispose() {
    // Stop timer when screen is disposed
    _bookingDetailsBloc.add(const StopRemainingTimeTimer());
    _bookingDetailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _bookingDetailsBloc),
        BlocProvider(create: (context) => getIt<BookingActionBloc>()),
        BlocProvider(create: (context) => getIt<FileDownloadBloc>()),
      ],
      child: BlocListener<FileDownloadBloc, FileDownloadState>(
        listenWhen: (previous, current) =>
            current is FileDownloadSuccess || current is FileDownloadError,
        listener: (context, state) {
          if (!context.mounted) return;
          if (_invoiceDialogShowing) {
            Navigator.of(context, rootNavigator: true).pop();
            _invoiceDialogShowing = false;
          }
          setState(() => _isDownloadingInvoice = false);
          final loc = AppLocalizations.of(context);
          if (loc == null) return;
          if (state is FileDownloadSuccess) {
            _openDownloadedInvoice(context, state.path, loc);
          } else if (state is FileDownloadError) {
            UnifiedSnackbar.show(
              context,
              message: loc.invoiceDownloadFailed,
              type: SnackbarType.error,
            );
          }
        },
        child: BlocListener<BookingActionBloc, BookingActionState>(
          listener: (context, state) {
            final l10n = AppLocalizations.of(context);
            if (state is BookingActionSuccess) {
              if (state.action == BookingActionType.cancel) {
                _bookingDetailsBloc.add(const StopRemainingTimeTimer());
                UnifiedSnackbar.success(
                  context,
                  message: l10n?.bookingCancelledSuccess ?? state.message,
                );
                final fromBookings =
                    widget.openedFrom == 'bookings';
                if (fromBookings) {
                  getIt<BookingsListRefreshNotifier>().requestRefresh();
                  if (context.mounted) {
                    context.goAndClearStack(Routes.userMainBookingsPath);
                  }
                } else {
                  getIt<HomeRefreshNotifier>().requestRefresh();
                  if (context.mounted) {
                    context.goAndClearStack(Routes.userMainHomePath);
                  }
                }
              }
            } else if (state is BookingActionFailure) {
              if (state.action == BookingActionType.cancel) {
                String message;
                if (state.error == 'invalid_hours') {
                  message = l10n?.errorInvalidHours ?? state.error;
                } else if (state.error.toLowerCase().contains('already') &&
                    state.error.toLowerCase().contains('cancel')) {
                  message = l10n?.bookingAlreadyCancelled ?? state.error;
                } else if (state.error.toLowerCase().contains('cannot') &&
                    state.error.toLowerCase().contains('cancel')) {
                  message = l10n?.bookingCannotBeCancelled ?? state.error;
                } else {
                  message = state.error;
                }
                UnifiedSnackbar.error(context, message: message);
              }
            }
          },
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) _handleBack(context);
            },
            child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.primaryText,
                    size: 24.sp,
                  ),
                  onPressed: () => _handleBack(context),
                ),
              title: Text(
                l10n.bookingDetails,
                style: AppTextStyles.titleLarge(
                  context,
                  color: AppColors.primaryText,
                ),
              ),
              centerTitle: true,
            ),
            body: BlocListener<BookingDetailsBloc, BookingDetailsState>(
              listener: (context, state) {
                // Start timer when booking details are loaded and booking is active
                if (state is BookingDetailsLoaded) {
                  final booking = state.response.data;
                  if (booking != null && booking.isActive) {
                    _bookingDetailsBloc.add(
                      StartRemainingTimeTimer(bookingId: widget.bookingId),
                    );
                  }
                }
              },
              listenWhen: (previous, current) {
                // Only listen to BookingDetailsLoaded states
                return current is BookingDetailsLoaded;
              },
              child: BlocBuilder<BookingDetailsBloc, BookingDetailsState>(
                builder: (context, state) {
                  if (state is BookingDetailsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is BookingDetailsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.sp,
                            color: AppColors.error,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _mapBookingDetailsError(context, state.message),
                            style: AppTextStyles.bodyMedium(
                              context,
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            onPressed: () {
                              _bookingDetailsBloc.add(
                                LoadBookingDetails(bookingId: widget.bookingId),
                              );
                            },
                            child: Text(l10n.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  // Handle both BookingDetailsLoaded and RemainingTimeUpdated states
                  BookingDetailsLoaded? bookingState;
                  RemainingTimeResponse? remainingTime;
                  bool hasWarning = false;
                  bool hasExpired = false;

                  if (state is RemainingTimeUpdated) {
                    // State includes both booking details and remaining time
                    bookingState = state;
                    remainingTime = state.remainingTimeResponse;
                    hasWarning = state.hasWarning;
                    hasExpired = state.hasExpired;
                  } else if (state is BookingDetailsLoaded) {
                    // Only booking details loaded, no remaining time yet
                    bookingState = state;
                  } else if (state is RemainingTimeLoaded) {
                    // Remaining time loaded but we need booking details
                    // This shouldn't happen if flow is correct, but handle it
                    // Try to get booking details from a stored reference or reload
                    // For now, just reload booking details
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _bookingDetailsBloc.add(
                        LoadBookingDetails(bookingId: widget.bookingId),
                      );
                    });
                    // Show loading while we reload booking details
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    // Not in a loaded state, show loading
                    return const Center(child: CircularProgressIndicator());
                  }

                  final booking = bookingState.response.data;
                  if (booking == null) {
                    return Center(
                      child: Text(
                        l10n.bookingNotFound,
                        style: AppTextStyles.bodyMedium(
                          context,
                          color: AppColors.error,
                        ),
                      ),
                    );
                  }

                  // Check if booking is active or pending
                  // After payment, booking might be pending initially, then become active
                  final isActive = booking.isActive;
                  final isPending = booking.isPending;

                  // Show action buttons for active bookings only
                  // Pending bookings don't have extend/cancel options
                  final showActionButtons = isActive;

                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Remaining Time Card (only for active bookings)
                              if (isActive)
                                RemainingTimeCard(
                                  remainingTime: remainingTime,
                                  isLoading: false,
                                  hasWarning: hasWarning,
                                  hasExpired: hasExpired,
                                  startTime: DateTimeFormatter.parseDateTime(
                                      booking.startTime),
                                  endTime: DateTimeFormatter.parseDateTime(
                                      booking.endTime),
                                ),

                              if (isActive && !isPending)
                                SizedBox(height: 20.h),

                              // Booking Info Card
                              BookingInfoCard(booking: booking),
                              SizedBox(height: 20.h),

                              // Vehicle Info Card
                              VehicleInfoCard(booking: booking),
                              SizedBox(height: 20.h),

                              // Time Info Section
                              TimeInfoSection(booking: booking),
                              SizedBox(height: 20.h),

                              // Payment Summary Card
                              PaymentSummaryCard(booking: booking),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ),

                      // Fixed Bottom Action Buttons
                      BookingActionButtons(
                        isActive: showActionButtons,
                        onExtendBooking: showActionButtons
                            ? () {
                                // Navigate to extend booking screen (نمرر openedFrom ليعود المستخدم لنفس المصدر بعد التمديد والدفع)
                                final booking = bookingState?.response.data;
                                if (booking != null) {
                                  context.push(
                                    Routes.userMainBookingsExtendPath,
                                    extra: {
                                      'booking': booking,
                                      'openedFrom': widget.openedFrom,
                                    },
                                  );
                                }
                              }
                            : null,
                        onViewInvoice: () =>
                            _downloadInvoice(context, booking.bookingId),
                        onCancelBooking: showActionButtons
                            ? () => _showCancelBookingDialog(context)
                            : null,
                        invoiceDownloading: _isDownloadingInvoice,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }

  /// Download invoice PDF via [FileDownloadBloc]
  Future<void> _downloadInvoice(BuildContext context, int bookingId) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    if (_isDownloadingInvoice) return;

    setState(() => _isDownloadingInvoice = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              SizedBox(height: 16.h),
              Text(
                l10n.downloadingInvoice,
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ),
      ),
    );
    _invoiceDialogShowing = true;

    try {
      Directory? downloadDir;
      if (Platform.isAndroid) {
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          downloadDir = Directory(
            '${externalDir.path.split('/Android')[0]}/Download',
          );
          if (!await downloadDir.exists()) {
            downloadDir = await getExternalStorageDirectory();
          }
        } else {
          downloadDir = await getApplicationDocumentsDirectory();
        }
      } else {
        downloadDir = await getApplicationDocumentsDirectory();
      }

      if (downloadDir == null) {
        throw Exception('Could not access download directory');
      }

      final fileName = 'invoice_$bookingId.pdf';
      final filePath = '${downloadDir.path}/$fileName';
      final url = BookingRepository.getBookingPdfUrl(bookingId);

      context.read<FileDownloadBloc>().add(
        FileDownloadStarted(
          url: url,
          savePath: filePath,
          headers: {'Accept': 'application/pdf'},
        ),
      );
    } catch (e) {
      if (_invoiceDialogShowing) {
        Navigator.of(context, rootNavigator: true).pop();
        _invoiceDialogShowing = false;
      }
      setState(() => _isDownloadingInvoice = false);
      if (context.mounted) {
        UnifiedSnackbar.show(
          context,
          message: l10n.invoiceDownloadFailed,
          type: SnackbarType.error,
        );
      }
    }
  }

  void _openDownloadedInvoice(
    BuildContext context,
    String filePath,
    AppLocalizations l10n,
  ) async {
    final result = await OpenFilex.open(filePath);
    if (!context.mounted) return;
    if (result.type == ResultType.done) {
      UnifiedSnackbar.show(
        context,
        message: l10n.invoiceDownloaded,
        type: SnackbarType.success,
      );
    } else {
      UnifiedSnackbar.show(
        context,
        message: l10n.errorOpeningFile,
        type: SnackbarType.error,
      );
    }
  }

  /// Show cancel booking confirmation dialog
  void _showCancelBookingDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          l10n.cancelBooking,
          style: AppTextStyles.titleLarge(
            context,
            color: AppColors.primaryText,
          ),
        ),
        content: Text(
          l10n.cancelBookingConfirmation,
          style: AppTextStyles.bodyMedium(
            context,
            color: AppColors.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.cancel,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _confirmCancelBooking(context);
            },
            child: Text(
              l10n.confirm,
              style: AppTextStyles.bodyMedium(context, color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  /// Map bloc/API error messages to localized user-facing messages
  String _mapBookingDetailsError(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return message;
    if (message.contains('null') || message == 'Booking data is null') {
      return l10n.bookingNotFound;
    }
    return message;
  }

  /// Confirm and cancel booking
  void _confirmCancelBooking(BuildContext context) {
    final bookingState = _bookingDetailsBloc.state;
    if (bookingState is! BookingDetailsLoaded) {
      return;
    }

    final booking = bookingState.response.data;
    if (booking == null) {
      return;
    }

    context.read<BookingActionBloc>().add(
      CancelBooking(bookingId: booking.bookingId),
    );
  }

  /// الرجوع حسب مصدر الدخول: pre_payment → تفاصيل الموقف، home → الرئيسية، bookings → حجوزاتي
  Future<void> _handleBack(BuildContext context) async {
    final from = widget.openedFrom;

    if (from == 'home') {
      getIt<HomeRefreshNotifier>().requestRefresh();
      if (context.mounted) {
        context.goAndClearStack(Routes.userMainHomePath);
      }
      return;
    }

    if (from == 'bookings') {
      getIt<BookingsListRefreshNotifier>().requestRefresh();
      if (context.mounted) {
        context.goAndClearStack(Routes.userMainBookingsPath);
      }
      return;
    }

    // openedFrom == 'pre_payment': الرجوع لصفحة تفاصيل الموقف
    final state = _bookingDetailsBloc.state;
    if (state is! BookingDetailsLoaded) {
      if (context.mounted) Navigator.of(context).pop();
      return;
    }

    final booking = state.response.data;
    if (booking?.parkingLot == null) {
      if (context.mounted) Navigator.of(context).pop();
      return;
    }

    final lot = booking!.parkingLot!;
    try {
      final vehicles = await getIt<GetVehiclesUseCase>().call();
      final parking = ParkingModel(
        lotId: lot.lotId,
        lotName: lot.lotName,
        address: lot.address ?? '',
        latitude: lot.latitude ?? 0.0,
        longitude: lot.longitude ?? 0.0,
        totalSpaces: lot.totalSpaces ?? 0,
        availableSpaces: null,
        hourlyRate: lot.hourlyRate ?? 0.0,
        status: 'active',
        statusRequest: null,
        userId: null,
        createdAt: null,
        updatedAt: null,
      );
      final vehicleModels = vehicles
          .map(
            (e) => VehicleModel(
              vehicleId: e.vehicleId,
              platNumber: e.platNumber,
              carMake: e.carMake,
              carModel: e.carModel,
              color: e.color,
              status: e.status,
              requestStatus: e.requestStatus,
              userId: e.userId,
              createdAt: e.createdAt,
              updatedAt: e.updatedAt,
            ),
          )
          .toList();
      if (!context.mounted) return;
      context.go(
        Routes.userMainBookingsPrePaymentPath,
        extra: {'parking': parking, 'vehicles': vehicleModels},
      );
    } catch (_) {
      if (context.mounted) Navigator.of(context).pop();
    }
  }
}

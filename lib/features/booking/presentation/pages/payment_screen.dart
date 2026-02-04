import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/home_refresh_notifier.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../parking/models/parking_model.dart';
import '../../../vehicles/data/models/vehicle_model.dart';
import '../../bloc/payment/payment_bloc.dart';
import '../widgets/payment_booking_info_card.dart';
import '../widgets/payment_method_tile.dart';
import '../widgets/payment_notes_section.dart';
import '../widgets/payment_action_buttons.dart';
import '../widgets/payment_success_dialog.dart';
import '../../../../core/widgets/unified_snackbar.dart';

/// Payment Screen
/// UI screen for processing payment for booking
class PaymentScreen extends StatefulWidget {
  final ParkingModel parking;
  final VehicleModel vehicle;
  final int hours;
  final double totalAmount;
  final int bookingId; // Required: booking_id from create booking response
  final DateTime? startTime; // Optional: from booking response
  final DateTime? endTime; // Optional: from booking response
  /// مصدر الدخول: 'pre_payment' | 'home' | 'bookings' — يحدد أين نرجع من تفاصيل الحجز
  final String openedFrom;

  const PaymentScreen({
    super.key,
    required this.parking,
    required this.vehicle,
    required this.hours,
    required this.totalAmount,
    required this.bookingId,
    this.startTime,
    this.endTime,
    this.openedFrom = 'pre_payment',
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'online'; // Default: دفع إلكتروني
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void initState() {
    super.initState();
    // يبدأ من وقت الحجز (من الـ API أو الوقت الحالي)، وينتهي بعد عدد الساعات المختارة
    if (widget.startTime != null && widget.endTime != null) {
      _startTime = widget.startTime;
      _endTime = widget.endTime;
    } else {
      _startTime = DateTime.now();
      _endTime = _startTime!.add(Duration(hours: widget.hours));
    }
  }

  void _onPaymentMethodSelected(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PaymentSuccessDialog(
        bookingId: widget.bookingId,
        onViewDetails: () {
          Navigator.of(dialogContext).pop();
          getIt<HomeRefreshNotifier>().requestRefresh();
          context.pushReplacement(
            Routes.userMainBookingsDetailsPath,
            extra: {
              'bookingId': widget.bookingId,
              'openedFrom': widget.openedFrom,
            },
          );
        },
        onGoToHome: () {
          Navigator.of(dialogContext).pop();
          getIt<HomeRefreshNotifier>().requestRefresh();
          context.goAndClearStack(Routes.userMainHomePath);
        },
      ),
    );
  }

  void _onSimulateSuccess(BuildContext blocContext) {
    // Validate booking_id is present
    final l10n = AppLocalizations.of(context);
    if (widget.bookingId == 0) {
      if (l10n != null) {
        UnifiedSnackbar.error(context, message: l10n.errorInvalidBookingId);
      }
      return;
    }

    // Generate transaction ID for simulation
    final transactionId =
        'TXN_SIMULATED_${DateTime.now().millisecondsSinceEpoch}';

    // دفع إلكتروني وشام كاش يبعثان للسيرفر كـ online
    final apiPaymentMethod = (_selectedPaymentMethod == 'sham_cash' ||
            _selectedPaymentMethod == 'online')
        ? 'online'
        : _selectedPaymentMethod;

    // Process payment success (simulation)
    blocContext.read<PaymentBloc>().add(
      ProcessPaymentSuccess(
        bookingId: widget.bookingId,
        amount: widget.totalAmount,
        paymentMethod: apiPaymentMethod,
        transactionId: transactionId,
      ),
    );
  }

  /// محاكاة فشل الدفع: انتظار قصير ثم سناك بار فقط، بدون استدعاء API
  Future<void> _onSimulateFailure(BuildContext blocContext) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    if (widget.bookingId == 0) {
      UnifiedSnackbar.error(context, message: l10n.errorInvalidBookingId);
      return;
    }

    final message = l10n.paymentSimulateFailure;
    // محاكاة انتظار الطلب (بدون ريكويست حقيقي)
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!context.mounted) return;
    // عرض السناك بار في الإطار التالي لضمان ظهوره من أول ضغطة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      UnifiedSnackbar.error(context, message: message);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocProvider(
      create: (context) => getIt<PaymentBloc>(),
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentProcessed) {
            if (state.wasSuccessful) {
              // Show success dialog
              _showPaymentSuccessDialog(context);
            } else {
              UnifiedSnackbar.error(
                context,
                message: l10n.paymentSimulateFailure,
              );
            }
          } else if (state is PaymentError) {
            final message = state.message == 'invalid_amount'
                ? l10n.paymentErrorInvalidAmount
                : state.message;
            UnifiedSnackbar.error(context, message: message);
          }
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
              onPressed: () => context.pop(),
            ),
            title: Text(
              l10n.paymentTitle,
              style: AppTextStyles.titleLarge(
                context,
                color: AppColors.primaryText,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                final isLoading = state is PaymentProcessing;

                return Column(
                  children: [
                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),

                            // Booking Info Card
                            if (_startTime != null && _endTime != null)
                              PaymentBookingInfoCard(
                                parking: widget.parking,
                                vehicle: widget.vehicle,
                                startTime: _startTime!,
                                endTime: _endTime!,
                              ),

                            SizedBox(height: 16.h),

                            // Payment Method Selection
                            Text(
                              l10n.paymentSelectedMethod,
                              style: AppTextStyles.titleMedium(
                                context,
                                color: AppColors.primaryText,
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Payment Methods (Radio buttons)
                            PaymentMethodTile(
                              paymentMethod: 'cash',
                              isSelected: _selectedPaymentMethod == 'cash',
                              onTap: () => _onPaymentMethodSelected('cash'),
                            ),
                            SizedBox(height: 12.h),

                            PaymentMethodTile(
                              paymentMethod: 'credit',
                              isSelected: _selectedPaymentMethod == 'credit',
                              onTap: () => _onPaymentMethodSelected('credit'),
                            ),
                            SizedBox(height: 12.h),

                            PaymentMethodTile(
                              paymentMethod: 'online',
                              isSelected: _selectedPaymentMethod == 'online',
                              onTap: () => _onPaymentMethodSelected('online'),
                            ),
                            SizedBox(height: 12.h),

                            PaymentMethodTile(
                              paymentMethod: 'sham_cash',
                              isSelected: _selectedPaymentMethod == 'sham_cash',
                              onTap: () => _onPaymentMethodSelected('sham_cash'),
                            ),

                            SizedBox(height: 20.h),

                            // Payment Notes Section
                            const PaymentNotesSection(),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),

                    // Payment Action Buttons (Fixed at bottom)
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryText.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Required Amount
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.paymentRequiredAmount,
                                style: AppTextStyles.titleMedium(
                                  context,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.currencySymbol,
                                    style: AppTextStyles.titleLarge(
                                      context,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    widget.totalAmount.toStringAsFixed(2),
                                    style: AppTextStyles.titleLarge(
                                      context,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Action Buttons
                          PaymentActionButtons(
                            onSimulateSuccess: () =>
                                _onSimulateSuccess(context),
                            onSimulateFailure: () =>
                                _onSimulateFailure(context),
                            isLoading: isLoading,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

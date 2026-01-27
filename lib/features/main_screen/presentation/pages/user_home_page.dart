import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import '../../../../core/core.dart';
import '../../../../core/injection/service_locator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../parking_map/presentation/pages/parking_map_page.dart';
import '../../../booking/bloc/bookings_list/bookings_list_bloc.dart';
import '../../../booking/models/booking_model.dart';
import '../../../booking/models/remaining_time_response.dart';
import '../../../booking/repository/booking_repository.dart';
import '../../../booking/presentation/widgets/active_booking_card.dart';

/// User Home Page
/// Displays parking map with active bookings list
class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Timer? _countdownTimer;
  // تخزين الـ remaining seconds لكل booking
  final Map<int, int?> _remainingSecondsCache = {};
  // تخزين الـ timestamp عند استدعاء API الأخير
  final Map<int, DateTime> _lastFetchTime = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// استدعاء API مرة واحدة فقط لكل booking
  void _fetchRemainingTimeOnce(List<BookingModel> activeBookings) {
    if (activeBookings.isEmpty) return;

    // استدعاء API مرة واحدة فقط لكل booking جديد أو لم يتم تحميله بعد
    for (final booking in activeBookings) {
      final bookingId = booking.bookingId;
      
      // استدعاء API فقط إذا لم يتم تحميله من قبل أو مر أكثر من دقيقة
      final shouldFetch = !_remainingSecondsCache.containsKey(bookingId) ||
          (_lastFetchTime[bookingId] != null &&
              DateTime.now().difference(_lastFetchTime[bookingId]!).inMinutes > 1);

      if (shouldFetch) {
        _fetchRemainingTime(bookingId);
      }
    }

    // بدء countdown timer محلي
    _startCountdownTimer();
  }

  /// استدعاء API مرة واحدة فقط
  Future<void> _fetchRemainingTime(int bookingId) async {
    try {
      final response = await BookingRepository.getRemainingTime(
        bookingId: bookingId,
      );
      if (mounted && response.remainingSeconds != null) {
        setState(() {
          _remainingSecondsCache[bookingId] = response.remainingSeconds;
          _lastFetchTime[bookingId] = DateTime.now();
        });
      }
    } catch (e) {
      // Silently handle errors
    }
  }

  /// Countdown timer محلي ينقص الـ seconds كل ثانية
  void _startCountdownTimer() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        // نقص الـ seconds لكل booking
        _remainingSecondsCache.forEach((bookingId, seconds) {
          if (seconds != null && seconds > 0) {
            _remainingSecondsCache[bookingId] = seconds - 1;
          } else {
            // إذا انتهى الوقت، استدعاء API مرة أخرى للتحقق
            _fetchRemainingTime(bookingId);
          }
        });
      });
    });
  }

  /// تحويل الـ seconds إلى RemainingTimeResponse للاستخدام في الكارد
  RemainingTimeResponse? _getRemainingTimeResponse(int bookingId) {
    final seconds = _remainingSecondsCache[bookingId];
    if (seconds == null) return null;

    return RemainingTimeResponse(
      status: true,
      bookingId: bookingId,
      remainingSeconds: seconds,
      remainingTime: _formatSecondsToTime(seconds),
      warning: seconds < 600 ? 'Less than 10 minutes remaining' : null,
    );
  }

  /// تحويل الـ seconds إلى صيغة HH:MM:SS
  String _formatSecondsToTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const SizedBox.shrink();

    return BlocProvider<BookingsListBloc>(
      create: (_) {
        final bloc = getIt<BookingsListBloc>();
        // Load active bookings when bloc is created
        bloc.add(const LoadActiveBookings());
        if (kDebugMode) {
          print('🔵 [UserHomePage] BookingsListBloc created, LoadActiveBookings dispatched');
        }
        return bloc;
      },
      child: Stack(
        children: [
          // Map in the background
          const ParkingMapPage(),
          // Active bookings horizontal list overlay above bottom nav bar
          Positioned(
            bottom: 10.h, // المسافة من bottom nav bar (يمكن تعديلها)
            left: -10,
            right: -10,
            child: BlocBuilder<BookingsListBloc, BookingsListState>(
              builder: (context, state) {
                if (state is BookingsListLoaded && state.isActiveTab) {
                  final activeBookings = state.bookings;
                  
                  // استدعاء API مرة واحدة فقط عند تحميل الحجوزات
                  if (activeBookings.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _fetchRemainingTimeOnce(activeBookings);
                    });
                  }

                  if (activeBookings.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  // Horizontal bookings list with shrinkWrap for dynamic height
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 155.h, // Maximum height constraint
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: activeBookings.length,
                      itemBuilder: (context, index) {
                        final booking = activeBookings[index];
                        final remainingTime = _getRemainingTimeResponse(booking.bookingId);
                        
                        return ActiveBookingCard(
                          booking: booking,
                          remainingTime: remainingTime,
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}


import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_exception.dart';
import '../../models/booking_details_response.dart';
import '../../models/remaining_time_response.dart';
import '../../repository/booking_repository.dart';
import '../../core/services/booking_timer_service.dart';

part 'booking_details_event.dart';
part 'booking_details_state.dart';

/// Booking Details BLoC
/// Manages fetching booking details and remaining time
class BookingDetailsBloc
    extends Bloc<BookingDetailsEvent, BookingDetailsState> {
  final BookingTimerService _timerService;
  StreamSubscription<int>? _timerSubscription;
  BookingDetailsResponse? _cachedBookingDetails;
  int? _currentBookingId;

  BookingDetailsBloc({BookingTimerService? timerService})
      : _timerService = timerService ?? BookingTimerService(),
        super(const BookingDetailsInitial()) {
    on<LoadBookingDetails>(_onLoadBookingDetails);
    on<LoadRemainingTime>(_onLoadRemainingTime);
    on<RefreshBookingDetails>(_onRefreshBookingDetails);
    on<StartRemainingTimeTimer>(_onStartRemainingTimeTimer);
    on<StopRemainingTimeTimer>(_onStopRemainingTimeTimer);
    on<RemainingTimeTicked>(_onRemainingTimeTicked);
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    _timerService.stopTimer(_currentBookingId ?? 0);
    return super.close();
  }

  /// Load booking details
  Future<void> _onLoadBookingDetails(
    LoadBookingDetails event,
    Emitter<BookingDetailsState> emit,
  ) async {
    emit(BookingDetailsLoading(bookingId: event.bookingId));

    try {
      final response = await BookingRepository.getBookingDetails(
        bookingId: event.bookingId,
      );

      if (!emit.isDone) {
        // Debug: Check if data is null
        if (response.data == null) {
          emit(BookingDetailsError(
            bookingId: event.bookingId,
            message: 'Booking data is null',
          ));
          return;
        }

        // Cache booking details for timer updates
        _cachedBookingDetails = response;

        emit(BookingDetailsLoaded(
          bookingId: event.bookingId,
          response: response,
        ));
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(BookingDetailsError(
          bookingId: event.bookingId,
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e, stackTrace) {
      // Print error for debugging
      print('Error loading booking details: $e');
      print('Stack trace: $stackTrace');
      
      if (!emit.isDone) {
        emit(BookingDetailsError(
          bookingId: event.bookingId,
          message: e.toString(),
        ));
      }
    }
  }

  /// Load remaining time for a booking
  Future<void> _onLoadRemainingTime(
    LoadRemainingTime event,
    Emitter<BookingDetailsState> emit,
  ) async {
    emit(RemainingTimeLoading(bookingId: event.bookingId));

    try {
      final response = await BookingRepository.getRemainingTime(
        bookingId: event.bookingId,
      );

      if (!emit.isDone && response.remainingSeconds != null) {
        // Store remaining seconds in timer service
        _timerService.setRemainingSeconds(
          event.bookingId,
          response.remainingSeconds!,
          DateTime.now(),
        );

        // Get cached booking details
        BookingDetailsResponse? bookingResponse = _cachedBookingDetails;
        
        if (bookingResponse == null) {
          final currentState = state;
          if (currentState is BookingDetailsLoaded) {
            bookingResponse = currentState.response;
          } else if (currentState is RemainingTimeUpdated) {
            bookingResponse = currentState.response;
          }
        }

        if (bookingResponse != null) {
          emit(RemainingTimeUpdated(
            bookingId: event.bookingId,
            response: bookingResponse,
            remainingTimeResponse: response,
          ));
        } else {
          emit(RemainingTimeLoaded(
            bookingId: event.bookingId,
            response: response,
          ));
        }
      }
    } on AppException catch (e) {
      if (!emit.isDone) {
        emit(BookingDetailsError(
          bookingId: event.bookingId,
          message: e.message,
          statusCode: e.statusCode,
          errorCode: e.errorCode,
        ));
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(BookingDetailsError(
          bookingId: event.bookingId,
          message: e.toString(),
        ));
      }
    }
  }

  /// Refresh current booking details
  Future<void> _onRefreshBookingDetails(
    RefreshBookingDetails event,
    Emitter<BookingDetailsState> emit,
  ) async {
    if (state is BookingDetailsLoaded) {
      final currentState = state as BookingDetailsLoaded;
      add(LoadBookingDetails(bookingId: currentState.bookingId));
    } else if (state is RemainingTimeLoaded) {
      final currentState = state as RemainingTimeLoaded;
      add(LoadRemainingTime(bookingId: currentState.bookingId));
    }
  }

  /// Start real-time remaining time timer
  void _onStartRemainingTimeTimer(
    StartRemainingTimeTimer event,
    Emitter<BookingDetailsState> emit,
  ) {
    _currentBookingId = event.bookingId;

    // Cancel existing subscription
    _timerSubscription?.cancel();

    // Fetch from API if needed
    if (_timerService.shouldFetchFromApi(event.bookingId)) {
      add(LoadRemainingTime(bookingId: event.bookingId));
    }

    // Start timer stream
    _timerSubscription = _timerService.startTimer(event.bookingId).listen(
      (remainingSeconds) {
        if (!isClosed) {
          add(RemainingTimeTicked(bookingId: event.bookingId));
        }
      },
      onError: (error) {
        // Handle timer errors if needed
      },
    );
  }

  /// Stop real-time remaining time timer
  void _onStopRemainingTimeTimer(
    StopRemainingTimeTimer event,
    Emitter<BookingDetailsState> emit,
  ) {
    _timerSubscription?.cancel();
    _timerSubscription = null;
    if (_currentBookingId != null) {
      _timerService.stopTimer(_currentBookingId!);
    }
  }

  /// Handle remaining time tick from timer service
  Future<void> _onRemainingTimeTicked(
    RemainingTimeTicked event,
    Emitter<BookingDetailsState> emit,
  ) async {
    final remainingSeconds = _timerService.getRemainingSeconds(event.bookingId);
    
    if (remainingSeconds == null) return;

    // If expired, fetch from API to verify
    if (remainingSeconds <= 0) {
      add(LoadRemainingTime(bookingId: event.bookingId));
      return;
    }

    if (!emit.isDone) {
      // Get cached booking details
      BookingDetailsResponse? bookingResponse = _cachedBookingDetails;
      
      if (bookingResponse == null) {
        final currentState = state;
        if (currentState is BookingDetailsLoaded) {
          bookingResponse = currentState.response;
        } else if (currentState is RemainingTimeUpdated) {
          bookingResponse = currentState.response;
        }
      }

      if (bookingResponse != null) {
        // Create RemainingTimeResponse from timer service
        final remainingTimeResponse = RemainingTimeResponse(
          status: true,
          bookingId: event.bookingId,
          remainingSeconds: remainingSeconds,
          remainingTime: BookingTimerService.formatSecondsToTime(remainingSeconds),
          warning: BookingTimerService.hasWarning(remainingSeconds)
              ? 'Less than 10 minutes remaining'
              : null,
        );

        emit(RemainingTimeUpdated(
          bookingId: event.bookingId,
          response: bookingResponse,
          remainingTimeResponse: remainingTimeResponse,
        ));
      }
    }
  }
}


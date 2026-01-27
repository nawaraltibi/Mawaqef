import 'dart:async';

/// Booking Timer Service
/// Manages countdown timers for active bookings
/// 
/// Separates timer logic from BLoC for better testability and reusability
class BookingTimerService {
  final Map<int, Timer> _timers = {};
  final Map<int, int> _remainingSeconds = {};
  final Map<int, DateTime> _lastFetchTime = {};
  final Map<int, StreamController<int>> _streamControllers = {};

  /// Get remaining seconds for a booking
  int? getRemainingSeconds(int bookingId) {
    return _remainingSeconds[bookingId];
  }

  /// Get last fetch time for a booking
  DateTime? getLastFetchTime(int bookingId) {
    return _lastFetchTime[bookingId];
  }

  /// Set remaining seconds (called after API fetch)
  void setRemainingSeconds(int bookingId, int seconds, DateTime fetchTime) {
    _remainingSeconds[bookingId] = seconds;
    _lastFetchTime[bookingId] = fetchTime;
  }

  /// Start timer for a booking
  /// Returns a stream that emits remaining seconds every second
  Stream<int> startTimer(int bookingId) {
    // Cancel existing timer if any
    stopTimer(bookingId);

    // Create stream controller if not exists
    if (!_streamControllers.containsKey(bookingId)) {
      _streamControllers[bookingId] = StreamController<int>.broadcast();
    }

    final controller = _streamControllers[bookingId]!;

    // Start periodic timer
    _timers[bookingId] = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final seconds = _remainingSeconds[bookingId];
        if (seconds == null || seconds <= 0) {
          // Timer expired, emit 0 and stop
          controller.add(0);
          stopTimer(bookingId);
          return;
        }

        // Decrement and emit
        _remainingSeconds[bookingId] = seconds - 1;
        controller.add(_remainingSeconds[bookingId]!);
      },
    );

    // Emit initial value
    final initialSeconds = _remainingSeconds[bookingId] ?? 0;
    controller.add(initialSeconds);

    return controller.stream;
  }

  /// Stop timer for a booking
  void stopTimer(int bookingId) {
    _timers[bookingId]?.cancel();
    _timers.remove(bookingId);
  }

  /// Check if timer should fetch from API
  /// Returns true if:
  /// - No remaining seconds stored, OR
  /// - Last fetch was more than 1 minute ago
  bool shouldFetchFromApi(int bookingId) {
    final lastFetch = _lastFetchTime[bookingId];
    if (lastFetch == null) return true;
    
    final minutesSinceFetch = DateTime.now().difference(lastFetch).inMinutes;
    return minutesSinceFetch > 1;
  }

  /// Clear all timers and data
  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _remainingSeconds.clear();
    _lastFetchTime.clear();
    
    for (final controller in _streamControllers.values) {
      controller.close();
    }
    _streamControllers.clear();
  }

  /// Format seconds to HH:MM:SS string
  static String formatSecondsToTime(int seconds) {
    if (seconds < 0) return '00:00:00';
    
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${secs.toString().padLeft(2, '0')}';
  }

  /// Check if remaining time has warning (< 10 minutes)
  static bool hasWarning(int? seconds) {
    if (seconds == null) return false;
    return seconds > 0 && seconds < 600; // Less than 10 minutes
  }

  /// Check if time has expired
  static bool hasExpired(int? seconds) {
    if (seconds == null) return true;
    return seconds <= 0;
  }
}


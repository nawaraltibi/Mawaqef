/// Centralized duration constants for animations, transitions, and delays
/// Ensures consistent timing across the app
class AppDurations {
  // Private constructor to prevent instantiation
  AppDurations._();

  // ============================================
  // ANIMATION DURATIONS
  // ============================================

  /// Instant - no animation: 0ms
  static const Duration instant = Duration.zero;

  /// Ultra fast animation: 100ms
  static const Duration ultraFast = Duration(milliseconds: 100);

  /// Extra fast animation: 150ms
  static const Duration extraFast = Duration(milliseconds: 150);

  /// Fast animation: 200ms
  static const Duration fast = Duration(milliseconds: 200);

  /// Standard page/widget transition: 250ms
  static const Duration pageTransition = Duration(milliseconds: 250);

  /// Default animation: 300ms (Material Design standard)
  static const Duration standard = Duration(milliseconds: 300);

  /// Slightly slower animation: 350ms
  static const Duration medium = Duration(milliseconds: 350);

  /// Slow animation: 400ms
  static const Duration slow = Duration(milliseconds: 400);

  /// Extra slow animation: 500ms
  static const Duration extraSlow = Duration(milliseconds: 500);

  /// Ultra slow animation: 600ms
  static const Duration ultraSlow = Duration(milliseconds: 600);

  // ============================================
  // UI FEEDBACK DURATIONS
  // ============================================

  /// Button press feedback: 100ms
  static const Duration buttonPress = Duration(milliseconds: 100);

  /// Ripple effect: 200ms
  static const Duration ripple = Duration(milliseconds: 200);

  /// Shimmer cycle: 1500ms
  static const Duration shimmer = Duration(milliseconds: 1500);

  /// Skeleton loading pulse: 1000ms
  static const Duration skeletonPulse = Duration(milliseconds: 1000);

  // ============================================
  // SNACKBAR / TOAST DURATIONS
  // ============================================

  /// Short snackbar: 2 seconds
  static const Duration snackbarShort = Duration(seconds: 2);

  /// Standard snackbar: 3 seconds
  static const Duration snackbarStandard = Duration(seconds: 3);

  /// Long snackbar: 4 seconds
  static const Duration snackbarLong = Duration(seconds: 4);

  /// Extended snackbar: 6 seconds
  static const Duration snackbarExtended = Duration(seconds: 6);

  // ============================================
  // NETWORK / API DURATIONS
  // ============================================

  /// API request timeout: 10 seconds
  static const Duration apiTimeout = Duration(seconds: 10);

  /// API connect timeout: 10 seconds
  static const Duration apiConnectTimeout = Duration(seconds: 10);

  /// API receive timeout: 10 seconds
  static const Duration apiReceiveTimeout = Duration(seconds: 10);

  /// Retry delay: 2 seconds
  static const Duration retryDelay = Duration(seconds: 2);

  /// Long operation timeout: 30 seconds
  static const Duration longOperationTimeout = Duration(seconds: 30);

  // ============================================
  // DEBOUNCE / THROTTLE DURATIONS
  // ============================================

  /// Search debounce: 500ms
  static const Duration searchDebounce = Duration(milliseconds: 500);

  /// Input debounce: 300ms
  static const Duration inputDebounce = Duration(milliseconds: 300);

  /// Scroll throttle: 100ms
  static const Duration scrollThrottle = Duration(milliseconds: 100);

  /// Button throttle (prevent double tap): 500ms
  static const Duration buttonThrottle = Duration(milliseconds: 500);

  // ============================================
  // TIMER / REFRESH DURATIONS
  // ============================================

  /// Timer tick interval: 1 second
  static const Duration timerTick = Duration(seconds: 1);

  /// Auto refresh interval: 30 seconds
  static const Duration autoRefresh = Duration(seconds: 30);

  /// Session check interval: 5 minutes
  static const Duration sessionCheck = Duration(minutes: 5);

  /// Cache validity: 5 minutes
  static const Duration cacheValidity = Duration(minutes: 5);

  // ============================================
  // DELAY DURATIONS
  // ============================================

  /// Micro delay: 50ms
  static const Duration microDelay = Duration(milliseconds: 50);

  /// Short delay: 200ms
  static const Duration shortDelay = Duration(milliseconds: 200);

  /// Standard delay: 500ms
  static const Duration standardDelay = Duration(milliseconds: 500);

  /// Long delay: 1 second
  static const Duration longDelay = Duration(seconds: 1);

  /// Very long delay: 2 seconds
  static const Duration veryLongDelay = Duration(seconds: 2);

  // ============================================
  // SPLASH / LOADING DURATIONS
  // ============================================

  /// Splash screen minimum display: 1.5 seconds
  static const Duration splashMinDisplay = Duration(milliseconds: 1500);

  /// Loading overlay minimum display: 500ms
  static const Duration loadingMinDisplay = Duration(milliseconds: 500);

  /// Progress indicator delay before showing: 200ms
  static const Duration progressIndicatorDelay = Duration(milliseconds: 200);

  // ============================================
  // NAVIGATION DURATIONS
  // ============================================

  /// Bottom nav transition: 250ms
  static const Duration bottomNavTransition = Duration(milliseconds: 250);

  /// Tab switch transition: 300ms
  static const Duration tabTransition = Duration(milliseconds: 300);

  /// Drawer animation: 250ms
  static const Duration drawerAnimation = Duration(milliseconds: 250);

  /// Dialog animation: 200ms
  static const Duration dialogAnimation = Duration(milliseconds: 200);

  /// Bottom sheet animation: 300ms
  static const Duration bottomSheetAnimation = Duration(milliseconds: 300);

  // ============================================
  // BOOKING SPECIFIC DURATIONS
  // ============================================

  /// Booking timer warning threshold: 10 minutes
  static const Duration bookingWarningThreshold = Duration(minutes: 10);

  /// Booking timer critical threshold: 5 minutes
  static const Duration bookingCriticalThreshold = Duration(minutes: 5);

  /// Payment timeout: 5 minutes
  static const Duration paymentTimeout = Duration(minutes: 5);
}

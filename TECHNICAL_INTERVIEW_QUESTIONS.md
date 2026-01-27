# Technical Interview Questions - Parking Application

## Project Overview

This Flutter Parking Application implements a production-grade parking booking system with:
- **Architecture**: Feature-based Clean Architecture (Presentation → Domain → Data layers)
- **State Management**: BLoC pattern (flutter_bloc 8.1.6)
- **Dependency Injection**: GetIt service locator
- **Routing**: GoRouter (declarative routing)
- **Networking**: Dio with custom API request wrapper
- **Localization**: Arabic/English with RTL support
- **Offline Support**: Request queue system using Hive
- **Real-time Updates**: Timer-based countdown for active parking sessions

---

## Junior-Level Interview Questions

### 1. Widget Composition and Layout

**Question**: In `lib/features/booking/presentation/widgets/remaining_time_card.dart`, the `RemainingTimeCard` widget displays a countdown timer. Walk me through how this widget is structured and what Flutter widgets are used to build the UI.

**Why it matters**: Understanding widget composition is fundamental to Flutter development. This widget demonstrates card layouts, conditional rendering, and progress indicators.

**Expected answer points**:
- Uses `Card` widget with custom `RoundedRectangleBorder`
- `Column` for vertical layout
- `Row` for horizontal alignment (header with status badge)
- `LinearProgressIndicator` for visual progress
- Conditional rendering based on `hasWarning` and `hasExpired` states
- Uses `flutter_screenutil` for responsive sizing (`.w`, `.h`, `.r`, `.sp`)
- Color theming based on state (success/warning/error)

**Follow-up**: How would you modify this widget to show a circular progress indicator instead of linear? What considerations would you need for the layout?

---

### 2. Basic BLoC Usage

**Question**: Looking at `lib/features/booking/bloc/booking_details/booking_details_bloc.dart`, explain how the `BookingDetailsBloc` handles the `LoadBookingDetails` event. What happens when this event is dispatched?

**Why it matters**: Understanding the Event → BLoC → State → UI flow is essential for working with BLoC. This is a real-world example of async data loading.

**Expected answer points**:
- Event handler `_onLoadBookingDetails` is registered in constructor: `on<LoadBookingDetails>(_onLoadBookingDetails)`
- Emits `BookingDetailsLoading` state immediately
- Calls `BookingRepository.getBookingDetails()` asynchronously
- On success: emits `BookingDetailsLoaded` with response data
- On error: emits `BookingDetailsError` with error message
- Uses `emit.isDone` check to prevent emitting after bloc is closed
- Handles `AppException` separately from generic exceptions

**Follow-up**: Why is the `emit.isDone` check important? What could happen if we emit a state after the bloc is closed?

---

### 3. Timer Implementation

**Question**: In the same `BookingDetailsBloc`, there's a `Timer.periodic` used for countdown updates. Explain how the timer works and why it decrements `_remainingSeconds` locally instead of calling the API every second.

**Why it matters**: Understanding efficient timer usage prevents unnecessary API calls and battery drain. This demonstrates client-side state management for real-time updates.

**Expected answer points**:
- Timer is created in `_onStartRemainingTimeTimer` event handler
- Uses `Timer.periodic(Duration(seconds: 1), callback)` for 1-second intervals
- Fetches remaining time from API once (or when >1 minute has passed)
- Stores `_remainingSeconds` and `_lastFetchTime` as instance variables
- On each tick, decrements `_remainingSeconds` locally
- Emits `RemainingTimeUpdated` state with locally calculated time
- When seconds reach 0, calls API again to verify expiration
- Timer is cancelled in `close()` method to prevent memory leaks

**Follow-up**: What would happen if the app goes to background while the timer is running? How could you handle timer drift (when the timer is slightly inaccurate)?

---

### 4. API Integration Basics

**Question**: In `lib/data/datasources/network/dio_provider.dart`, the `DioProvider` class handles HTTP requests. Explain how a typical API request flows through this provider, including error handling.

**Why it matters**: Understanding HTTP client setup, interceptors, and error handling is crucial for production apps. This shows centralized networking logic.

**Expected answer points**:
- Singleton pattern using factory constructor
- Dio instance configured with base URL and timeouts
- Interceptors for logging (in debug mode)
- `request()` method accepts `APIRequest` object
- Handles `FormData` for multipart requests
- Converts `DioException` to `AppException` with specific error codes
- Different error types: timeout, connection error, bad response, cancellation
- Response handling for 200/201/202/204 status codes
- Error parsing from response body (error_code, message, errors)

**Follow-up**: Why convert `DioException` to `AppException`? What's the benefit of having a custom exception class?

---

## Mid-Level Interview Questions

### 5. BLoC Architecture and State Modeling

**Question**: The `BookingDetailsBloc` has multiple states: `BookingDetailsInitial`, `BookingDetailsLoading`, `BookingDetailsLoaded`, `RemainingTimeUpdated`, and `BookingDetailsError`. Explain the state hierarchy and why `RemainingTimeUpdated` extends `BookingDetailsLoaded` instead of being a separate state.

**Why it matters**: Proper state modeling ensures UI can handle all scenarios correctly. This demonstrates understanding of state composition and inheritance in BLoC.

**Expected answer points**:
- `RemainingTimeUpdated extends BookingDetailsLoaded` preserves booking data while updating time
- This allows UI to access both booking details and remaining time without losing context
- State hierarchy: Initial → Loading → Loaded → Updated (for timer ticks)
- Error state can occur at any point in the flow
- `RemainingTimeLoaded` is a separate state when time is loaded before booking details
- States use `Equatable` for value comparison (prevents unnecessary rebuilds)
- Each state includes `bookingId` for tracking which booking is being displayed

**Follow-up**: How would you handle a scenario where the booking expires while the user is viewing the details screen? What state transitions would occur?

---

### 6. Real-time Updates and Timer Management

**Question**: The booking details screen needs to show a live countdown timer. Explain the complete flow from when the screen opens to how the timer updates every second, including how the timer is started and stopped.

**Why it matters**: Managing real-time updates requires careful lifecycle management. This demonstrates understanding of widget lifecycle, BLoC lifecycle, and resource cleanup.

**Expected answer points**:
- Screen loads booking details via `LoadBookingDetails` event in `initState`
- `BlocListener` watches for `BookingDetailsLoaded` state
- When booking is active, dispatches `StartRemainingTimeTimer` event
- Timer starts with initial API call to get remaining seconds
- Timer.periodic decrements seconds locally every second
- Emits `RemainingTimeUpdated` state on each tick
- UI rebuilds via `BlocBuilder` showing updated countdown
- Timer stopped in `dispose()` via `StopRemainingTimeTimer` event
- Timer also cancelled in bloc's `close()` method
- Handles edge case: if seconds reach 0, calls API to verify expiration

**Follow-up**: What happens if the user navigates away and comes back? How would you ensure the timer reflects the correct remaining time?

---

### 7. Error Handling and Edge Cases

**Question**: In `lib/features/booking/presentation/pages/booking_details_screen.dart`, the screen handles multiple states including error states. Walk through the error handling strategy and how edge cases are managed (e.g., booking not found, network errors, expired sessions).

**Why it matters**: Production apps must handle all error scenarios gracefully. This demonstrates defensive programming and user experience considerations.

**Expected answer points**:
- Error state shows error icon, message, and retry button
- Checks `response.data == null` in bloc before emitting success
- Handles `AppException` with status codes and error codes separately
- Generic catch block for unexpected errors
- UI shows different states: loading, error, loaded, updated
- Handles case where booking is null (shows "Booking not found")
- Distinguishes between active, pending, and inactive bookings
- Action buttons only shown for active bookings
- Timer only started for active bookings
- Navigation handled after cancellation to prevent showing error state

**Follow-up**: How would you implement retry logic with exponential backoff for failed API calls? Where would this logic live?

---

### 8. Localization and RTL Support

**Question**: The app supports Arabic and English with RTL layout. Explain how localization is implemented and how the app switches between languages. Reference the actual implementation in `lib/main.dart` and the localization setup.

**Why it matters**: Internationalization is critical for global apps. This demonstrates understanding of Flutter's localization system and RTL support.

**Expected answer points**:
- Uses `flutter_localizations` with generated code from `.arb` files
- `LocaleCubit` manages language state (registered as singleton in service locator)
- `MaterialApp.router` configured with `localizationsDelegates` and `supportedLocales`
- Locale controlled by `BlocBuilder<LocaleCubit, LocaleState>` wrapping MaterialApp
- Language persisted via `LanguageService` (likely using SharedPreferences)
- RTL automatically handled by Flutter when locale is Arabic
- Custom fonts: `IBMPlexSansArabic` for Arabic, `Inter` for English
- All UI strings accessed via `AppLocalizations.of(context)`
- Locale changes trigger MaterialApp rebuild, updating all localized strings

**Follow-up**: How would you handle date/time formatting differently for Arabic vs English? What about number formatting?

---

### 9. Navigation and Route Protection

**Question**: The app uses GoRouter for navigation. Explain how routing is configured in `lib/core/routes/app_pages.dart` and how you would implement route protection (e.g., requiring authentication to access booking screens).

**Why it matters**: Understanding declarative routing and route guards is essential for secure navigation flows. This demonstrates navigation architecture.

**Expected answer points**:
- GoRouter configured with `initialLocation` and route list
- Routes defined as `GoRoute` objects with path and builder
- Navigation uses `context.push()` for stack navigation, `context.go()` for replacement
- Route parameters passed via `state.uri.queryParameters` or `extra` parameter
- Route protection would use `redirect` callback in GoRoute
- Check authentication status in redirect (from `AuthLocalRepository`)
- Redirect to login if not authenticated, otherwise allow access
- Can use `refreshListenable` to react to auth state changes
- Deep linking supported via path parameters

**Follow-up**: How would you implement a "guarded" route that requires both authentication AND an active booking? Show the redirect logic.

---

### 10. Dependency Injection and Service Locator

**Question**: The app uses GetIt for dependency injection (`lib/core/injection/service_locator.dart`). Explain the difference between `registerLazySingleton` and `registerFactory`, and why certain blocs are registered as singletons while others are factories.

**Why it matters**: Understanding DI patterns and object lifecycle management is crucial for scalable architecture. This demonstrates service locator pattern.

**Expected answer points**:
- `registerLazySingleton`: Creates instance once, reuses it (e.g., `LocaleCubit`, `SplashRoutingBloc`)
- `registerFactory`: Creates new instance each time it's requested (e.g., `LoginBloc`, `PaymentBloc`)
- App-wide blocs (LocaleCubit, SplashRoutingBloc) are singletons - shared across app
- Feature blocs are factories - each screen gets its own instance
- Repositories and data sources are lazy singletons - shared across features
- Use cases are lazy singletons - stateless business logic
- Benefits: Testability, loose coupling, centralized dependency management
- Service locator initialized in `main()` before `runApp()`

**Follow-up**: What are the trade-offs of using a service locator vs constructor injection? When would you prefer one over the other?

---

## Senior-Level Interview Questions

### 11. Designing Reliable Real-time Parking Sessions

**Question**: The current timer implementation in `BookingDetailsBloc` uses a local countdown that decrements every second, with periodic API sync. Analyze this approach and propose improvements for handling edge cases like: app going to background, device time changes, network interruptions, and multiple active bookings.

**Why it matters**: Real-time systems require careful consideration of accuracy, battery usage, and edge cases. This demonstrates system design thinking.

**Expected answer points**:
- **Current approach analysis**:
  - Pros: Reduces API calls, smooth UI updates
  - Cons: Timer drift, no background updates, timezone changes not handled
  
- **Improvements**:
  - Use `DateTime.now()` difference calculation instead of decrementing counter
  - Store server timestamp on initial fetch, calculate remaining = endTime - now()
  - Handle app lifecycle: pause timer in background, resume and sync on foreground
  - Use `WidgetsBindingObserver` to detect app state changes
  - Periodic API sync (every 30-60 seconds) to correct drift
  - Handle timezone changes: store UTC timestamps, convert for display
  - For multiple bookings: use separate timers or a centralized timer service
  - Background execution: consider WorkManager for critical expiration notifications

**Follow-up**: How would you implement a background service that notifies users when their parking is about to expire? What platform-specific considerations are there?

---

### 12. Offline-First Architecture and Request Queue

**Question**: The app implements an offline request queue system (`lib/core/queue/services/request_queue_manager.dart`). Explain how this system works, its limitations, and how you would improve it for production use, especially for payment requests.

**Why it matters**: Offline support is critical for mobile apps. This demonstrates understanding of queue systems, data persistence, and conflict resolution.

**Expected answer points**:
- **Current implementation**:
  - Queues POST/PUT/DELETE requests when offline
  - Stores in Hive database (persistent)
  - Processes queue when connection restored
  - Retry logic with max 3 attempts
  
- **Limitations**:
  - No request prioritization (payments should be processed first)
  - No conflict resolution (what if booking was cancelled while offline?)
  - No idempotency keys (duplicate requests possible)
  - No request expiration (old requests might be invalid)
  - No user feedback about queued requests
  
- **Improvements**:
  - Priority queue: payments > bookings > other requests
  - Idempotency: generate unique request IDs, check server before retry
  - Request expiration: discard requests older than X hours
  - Optimistic UI updates with rollback on failure
  - Show queue status to user (snackbar with pending count)
  - Conflict resolution: check server state before applying queued actions
  - For payments: require online connection, don't queue (too risky)

**Follow-up**: How would you handle a scenario where a user books parking offline, then the parking spot becomes unavailable when the request is processed? What's the user experience flow?

---

### 13. Payment Flow Safety and Idempotency

**Question**: The payment flow in `lib/features/booking/bloc/payment/payment_bloc.dart` processes payments through `ProcessPaymentSuccess` and `ProcessPaymentFailure` events. Analyze the current implementation and identify security and reliability concerns. How would you ensure payment requests are never duplicated or lost?

**Why it matters**: Payment processing requires absolute reliability and security. This demonstrates understanding of financial transaction safety.

**Expected answer points**:
- **Current concerns**:
  - No idempotency key - duplicate requests possible
  - No transaction state tracking
  - Payment queued offline (risky - should require online)
  - No receipt verification
  - No rollback mechanism
  
- **Improvements**:
  - **Idempotency**: Generate unique transaction ID client-side, send with request
  - **Server-side validation**: Check transaction ID hasn't been processed
  - **Require online**: Don't allow payment initiation when offline
  - **State machine**: pending → processing → completed/failed (prevent state changes)
  - **Receipt verification**: After payment, verify with server before showing success
  - **Retry with backoff**: For network errors, retry with exponential backoff
  - **Timeout handling**: If payment processing takes too long, show pending state
  - **Logging**: Log all payment attempts for audit trail
  - **User confirmation**: Require explicit confirmation before processing payment

**Follow-up**: How would you implement a two-phase commit pattern for payments? What happens if the payment succeeds but booking activation fails?

---

### 14. Performance and Battery Optimization

**Question**: The app uses timers, network requests, and real-time updates. Analyze the performance and battery impact of the current implementation. What optimizations would you implement to reduce battery drain while maintaining functionality?

**Why it matters**: Mobile apps must balance functionality with battery life. This demonstrates understanding of performance optimization and resource management.

**Expected answer points**:
- **Current issues**:
  - Timer runs every second even in background (wastes battery)
  - No request batching (multiple API calls could be combined)
  - No image caching strategy visible
  - Continuous location updates (if used) drain battery
  
- **Optimizations**:
  - **Timer management**:
    - Pause timer when app goes to background
    - Use `WidgetsBindingObserver` to detect app lifecycle
    - Reduce update frequency when screen not visible (every 5 seconds instead of 1)
    - Use `Stream.periodic` with `takeWhile` for automatic cleanup
  
  - **Network optimization**:
    - Batch multiple requests when possible
    - Use HTTP/2 for connection multiplexing
    - Implement request deduplication (don't fetch same data twice)
    - Cache API responses with appropriate TTL
    - Use pagination for lists (infinite scroll)
  
  - **UI optimization**:
    - Use `const` constructors where possible
    - Implement `ListView.builder` for long lists
    - Use `RepaintBoundary` for complex widgets
    - Optimize image loading (caching, compression, lazy loading)
  
  - **Background execution**:
    - Minimize background work
    - Use platform-specific background execution APIs only when necessary
    - Consider push notifications instead of polling

**Follow-up**: How would you implement a performance monitoring system to track battery usage, network calls, and memory consumption in production?

---

### 15. Scalability for Multiple Active Sessions

**Question**: Currently, the timer implementation handles one active booking at a time. How would you redesign the system to handle multiple active parking sessions simultaneously? Consider state management, UI updates, and resource usage.

**Why it matters**: Real-world apps must handle multiple concurrent operations. This demonstrates system design and architecture scalability.

**Expected answer points**:
- **Current limitation**: Each `BookingDetailsBloc` manages one booking's timer
  
- **Proposed architecture**:
  - **Centralized Timer Service**: Single service managing all active booking timers
    - Map<bookingId, Timer> to track multiple timers
    - Single periodic timer that updates all bookings
    - Broadcasts updates via StreamController
  
  - **State management**:
    - `BookingsListBloc` manages list of active bookings
    - Each booking card subscribes to timer updates for its bookingId
    - Use `StreamBuilder` or `BlocListener` to update individual cards
  
  - **Resource optimization**:
    - Single timer instead of N timers (one per booking)
    - Batch API calls: fetch remaining time for all active bookings in one request
    - Update only visible booking cards (lazy updates)
  
  - **Data structure**:
    ```dart
    class ActiveBookingsTimerService {
      final Map<int, int> _remainingSeconds = {};
      final StreamController<Map<int, int>> _updatesController;
      Timer? _globalTimer;
      
      void startTimerForBooking(int bookingId, int initialSeconds);
      void stopTimerForBooking(int bookingId);
      Stream<Map<int, int>> get updates;
    }
    ```
  
  - **UI updates**:
    - Booking cards use `StreamBuilder` listening to specific bookingId
    - Only rebuilds the specific card, not entire list
    - Use `ValueListenableBuilder` for fine-grained updates

**Follow-up**: How would you handle 100+ active bookings? What's the performance impact, and how would you optimize further?

---

### 16. Testability and Architecture Improvements

**Question**: Analyze the current architecture and identify areas that make testing difficult. How would you refactor to improve testability while maintaining the current feature set? Focus on the booking flow as an example.

**Why it matters**: Testability is crucial for maintaining code quality. This demonstrates understanding of testable architecture patterns.

**Expected answer points**:
- **Current testing challenges**:
  - Direct repository calls in BLoC (hard to mock)
  - Timer logic mixed with business logic
  - Service locator makes dependency injection opaque
  - No clear separation of concerns in some areas
  
- **Improvements**:
  - **Repository abstraction**: 
    - Create `BookingRepository` interface
    - Inject repository into BLoC via constructor
    - Easy to mock for unit tests
  
  - **Timer abstraction**:
    - Create `TimerService` interface
    - Inject timer service into BLoC
    - Mock timer for testing (control time progression)
  
  - **Use cases layer**:
    - Extract business logic to use cases (like vehicles feature does)
    - `GetBookingDetailsUseCase`, `StartBookingTimerUseCase`
    - Test use cases independently
  
  - **State testing**:
    - Test state transitions in isolation
    - Use `blocTest` from bloc_test package
    - Verify events → states flow
  
  - **Widget testing**:
    - Extract complex widgets to testable components
    - Use `MockBookingDetailsBloc` for widget tests
    - Test UI states independently
  
  - **Integration testing**:
    - Test full booking flow with real repositories (but mocked network)
    - Verify timer behavior with controlled time
    - Test error scenarios

**Follow-up**: Write a unit test for `BookingDetailsBloc` that verifies the timer decrements correctly and calls the API when seconds reach 0. Show the test setup with mocks.

---

### 17. Production Readiness and Monitoring

**Question**: This app handles financial transactions (payments) and time-sensitive operations (parking expiration). What production-ready features would you add to ensure reliability, observability, and quick issue resolution? Be specific about implementation.

**Why it matters**: Production apps require comprehensive monitoring and error tracking. This demonstrates understanding of DevOps and production concerns.

**Expected answer points**:
- **Error tracking and logging**:
  - Integrate Sentry or Firebase Crashlytics
  - Log all payment transactions (with PII redaction)
  - Structured logging with context (userId, bookingId, timestamp)
  - Log timer events (start, stop, API calls, errors)
  
- **Analytics and monitoring**:
  - Track key metrics: booking creation rate, payment success rate, timer accuracy
  - Monitor API response times and error rates
  - Track user flows (funnel analysis)
  - Alert on critical failures (payment processing down)
  
- **Feature flags**:
  - Use Firebase Remote Config or similar
  - A/B test payment flows
  - Gradual rollout of new features
  - Emergency kill switches
  
- **Performance monitoring**:
  - Track app startup time
  - Monitor memory usage and leaks
  - Track battery usage
  - Network request monitoring
  
- **Data validation**:
  - Validate all API responses against schemas
  - Sanitize user inputs
  - Validate payment amounts and booking times
  - Prevent negative remaining time displays
  
- **Security**:
  - Certificate pinning for API calls
  - Encrypt sensitive data (tokens, payment info)
  - Secure storage for credentials
  - Rate limiting for API calls
  
- **Backup and recovery**:
  - Backup user preferences and cached data
  - Handle app data migration between versions
  - Graceful degradation when services are down

**Follow-up**: How would you implement a circuit breaker pattern for the payment API? What metrics would trigger the circuit to open?

---

## Summary

These questions are based on the **actual implementation** in the Parking Application codebase. Each question:

1. ✅ References real files, blocs, events, states, or widgets
2. ✅ Explains why the question matters in a parking app context
3. ✅ Describes what a strong answer should include
4. ✅ Includes follow-up questions for deeper discussion

The questions progress from basic Flutter concepts (Junior) through architecture and real-time systems (Mid) to system design and production concerns (Senior).

---

## Key Files Referenced

- `lib/features/booking/bloc/booking_details/booking_details_bloc.dart` - Timer implementation
- `lib/features/booking/presentation/widgets/remaining_time_card.dart` - UI component
- `lib/features/booking/presentation/pages/booking_details_screen.dart` - Screen implementation
- `lib/core/queue/services/request_queue_manager.dart` - Offline queue system
- `lib/core/injection/service_locator.dart` - Dependency injection
- `lib/data/datasources/network/dio_provider.dart` - HTTP client
- `lib/main.dart` - App initialization and localization


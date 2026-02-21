# Parking Application

A production-grade, bilingual (Arabic/English) mobile application for smart parking management built with Flutter. The system serves two distinct user roles -- **drivers** who discover, book, and pay for parking spots via an interactive map, and **parking owners** who manage lots, monitor occupancy, and track revenue through a real-time dashboard. Engineered with Clean Architecture, event-driven BLoC state management, and an offline-first networking layer, the application is designed for reliability in real-world connectivity conditions.

The project emphasizes separation of concerns at every layer, strict adherence to SOLID principles, and a modular feature-based structure that scales with team size and feature count. Every network call flows through a centralized request pipeline with automatic retry, token injection, and structured error propagation -- ensuring consistent behavior from the UI down to the API boundary.

---

## Table of Contents

- [Key Features](#key-features)
- [Architecture](#architecture)
- [Technical Highlights](#technical-highlights)
- [Folder Structure](#folder-structure)
- [State Management Overview](#state-management-overview)
- [Networking Layer](#networking-layer)
- [Advanced Engineering Practices](#advanced-engineering-practices)
- [Installation and Setup](#installation-and-setup)
- [Environment Configuration](#environment-configuration)
- [Future Improvements](#future-improvements)
- [Screenshots](#screenshots)

---

## Key Features

### Driver Experience
- Interactive OpenStreetMap-based parking discovery with animated markers
- Proximity-based parking search with real-time occupancy indicators
- End-to-end booking flow: selection, pre-payment review, payment, and confirmation
- Active booking countdown timer with warning and expiration thresholds
- Booking extension and cancellation workflows
- Vehicle management (CRUD) with color picker and make/model selection
- Violation tracking with paid/unpaid filtering and in-app payment
- Push notification inbox with read/unread state management

### Owner Experience
- Parking lot creation and management with full CRUD operations
- Dashboard with occupancy statistics and revenue analytics
- Real-time parking list with search, filter, and refresh capabilities

### Platform and UX
- Full bilingual support (Arabic RTL / English LTR) with runtime locale switching
- Responsive layouts via ScreenUtil (360x690 design baseline)
- Onboarding flow for first-time users
- Unified snackbar system for success, error, and warning feedback
- Splash-based routing with token validation and role detection
- Custom reusable widget library (text fields, dropdowns, date pickers, buttons, infinite lists)

---

## Architecture

### Clean Architecture

The application follows Clean Architecture, dividing the codebase into three concentric layers with strict dependency rules: the inner layers never depend on outer layers.

```
Presentation  -->  Domain  <--  Data
   (UI)          (Business)    (API / Local)
```

**Presentation Layer** -- Contains screens, widgets, and BLoC classes. Each BLoC receives events from the UI, delegates to use cases, and emits typed states. No business logic or data access resides here.

**Domain Layer** -- Houses entities (pure Dart classes with no framework dependencies), repository interfaces (abstract contracts), and use cases (single-responsibility operations). This layer defines _what_ the application does without knowing _how_.

**Data Layer** -- Implements repository interfaces with concrete data sources. Remote data sources communicate via the Dio HTTP client through a centralized `APIRequest` builder. Local data sources use Hive for structured storage and SharedPreferences for key-value pairs.

### Dependency Injection

All dependencies are wired through **GetIt** as a service locator, configured in `service_locator.dart`. The registration strategy is:

| Registration Type | Used For |
|-------------------|----------|
| Lazy Singleton | Repositories, data sources, use cases, refresh notifiers, locale cubit |
| Factory | Feature BLoCs (new instance per screen) |
| Singleton | NotificationsBloc (shared state across navigation) |

This ensures BLoCs receive their dependencies through constructor injection, never importing concrete implementations directly.

### State Management -- BLoC (not Cubit)

The project exclusively uses the **BLoC pattern** (Business Logic Component) with explicit Event and State classes. Each feature defines:

- **Events** -- Discrete user actions or system triggers (e.g., `LoginSubmitted`, `BookingDetailsRequested`, `ParkingLotSelected`)
- **States** -- Immutable snapshots emitted in response to events (e.g., `LoginSuccess`, `BookingDetailsLoaded`, `ParkingMapError`)

BLoCs are provided via `BlocProvider` at the route level and consumed with `BlocBuilder`, `BlocListener`, and `BlocConsumer` in the widget tree.

---

## Technical Highlights

### Offline-First Request Queue

The application implements a full offline-first architecture through two complementary systems:

**RequestQueueManager** -- A singleton that listens to `connectivity_plus` stream changes. When the device goes offline, mutating requests (POST, PUT, DELETE) are persisted to a Hive-backed queue. When connectivity is restored, the manager processes the queue sequentially with retry logic and maximum retry limits (3 attempts). Real-time queue status is broadcast via Dart streams.

**AsyncRunner** -- A generic utility wrapping every async operation with:
- Connectivity-aware task differentiation (separate online/offline code paths)
- Exponential backoff retry with configurable attempt limits
- Cancellable operations via `CancelableOperation` and Dio `CancelToken`
- Duplicate call prevention (abort-new or abort-old strategies)

### Connectivity Handling

Network state is monitored globally via `connectivity_plus`. The `RequestQueueManager` emits `QueueStatus` objects (online/offline state + pending queue length) through a broadcast stream. The `AsyncRunner` checks connectivity before every task execution and routes to the appropriate online or offline handler.

### Error Handling Strategy

Errors are modeled as a single `AppException` class carrying:
- `statusCode` -- HTTP status or custom code (e.g., 503 for location disabled)
- `errorCode` -- Machine-readable identifier (e.g., `no-internet`, `location-permission-denied`)
- `message` -- Human-readable description
- `errors` -- Optional field-level validation map
- `responseData` -- Optional raw response for edge cases

Every Dio error type (timeout, cancel, connection, bad certificate, bad response) is mapped to an `AppException` in `DioProvider`. Feature-specific error handler mixins (e.g., `ProfileErrorHandlerMixin`, `VehiclesErrorHandler`) translate `AppException` into localized user-facing messages using `LocalizedErrorMessages`.

### Token and Session Management

Authentication uses Bearer token authorization stored in Hive via `AuthLocalRepository`. The flow:

1. Login BLoC saves the token and user data on successful authentication
2. `APIRequest` automatically injects the `Authorization: Bearer <token>` header for authorized endpoints
3. `SplashRoutingBloc` checks token presence and user type on cold start to determine the initial route
4. Logout clears all local auth data; password changes invalidate tokens server-side

### API Integration Structure

All HTTP communication flows through a layered pipeline:

```
UI --> BLoC --> UseCase --> Repository --> DataSource --> APIRequest --> DioProvider --> Server
```

`APIRequest` is a builder that encodes method, path, body type (JSON / FormData / multipart), query parameters, and authorization option. `DioProvider` is a singleton Dio wrapper that applies interceptors, handles timeouts, and maps all responses and errors into a consistent format.

---

## Folder Structure

```
lib/
|-- main.dart
|-- l10n/
|   |-- app_en.arb
|   |-- app_ar.arb
|   |-- app_localizations.dart
|   |-- app_localizations_en.dart
|   |-- app_localizations_ar.dart
|
|-- core/
|   |-- bloc/                        # App-wide locale cubit
|   |-- enums/                       # Shared enumerations (loading types)
|   |-- injection/                   # GetIt service locator setup
|   |-- location/                    # Location service, entity, use case
|   |-- map/                         # Map adapter, markers, coordinates
|   |-- queue/                       # Offline request queue (manager + service + model)
|   |-- routes/                      # GoRouter configuration and route constants
|   |-- services/                    # App-wide services (storage, Hive, language, cache, refresh notifiers)
|   |-- styles/                      # Colors, text styles, dimensions, durations
|   |-- theme/                       # Material theme definition
|   |-- utils/                       # Exceptions, error helpers, JSON helpers, navigation, validators
|   |-- widgets/                     # Reusable UI components (10 widgets)
|
|-- data/
|   |-- datasources/network/         # DioProvider, APIRequest builder, APIConfig
|   |-- repositories/                # Local auth and settings repositories
|
|-- features/
|   |-- auth/                        # Login, register, logout (BLoC + screens + validators)
|   |-- booking/                     # Booking lifecycle (5 BLoCs, timer service, payment flow)
|   |-- file_downloader/             # File download with progress and cancellation
|   |-- image_downloader/            # Image download with progress and cancellation
|   |-- main_screen/                 # Shell navigation for user and owner roles
|   |-- notifications/               # Full Clean Architecture (data/domain/presentation)
|   |-- onboarding/                  # First-launch onboarding pages
|   |-- parking/                     # Parking CRUD and dashboard (owner)
|   |-- parking_map/                 # Map-based discovery (Clean Architecture, 3 use cases)
|   |-- profile/                     # Profile management with error handler mixin
|   |-- splash/                      # Splash routing logic (token + role check)
|   |-- vehicles/                    # Vehicle CRUD (Clean Architecture, 4 use cases)
|   |-- violations/                  # Violation tracking and payment (3 use cases)
```

---

## State Management Overview

### Scale

| Metric | Count |
|--------|-------|
| BLoC classes | 22 |
| Event classes | 22 |
| State classes | 23 (including locale) |
| Use cases | 13 |
| Feature modules | 13 |

### Event-Driven Flow

Every user interaction dispatches a typed event to the relevant BLoC. The BLoC processes the event through use cases or repositories and emits a new immutable state. The UI rebuilds reactively via `BlocBuilder` or responds to side effects via `BlocListener`.

```
User Tap --> dispatch(Event) --> BLoC.on<Event>() --> UseCase.call() --> emit(NewState)
```

### State Emission Patterns

- **Initial / Loading / Loaded / Error** -- Standard four-state pattern for data-fetching BLoCs
- **Action states** -- Discrete failure states (e.g., `VehicleActionFailure`, `BookingActionFailure`) for CRUD operations that carry the `AppException` for localized error display
- **Composite states** -- Some BLoCs (e.g., `ParkingMapBloc`) manage multiple concurrent state properties (lots list, selected lot, user location, search results) within a single state class
- **Timer-driven states** -- `BookingDetailsBloc` subscribes to `BookingTimerService` streams and re-emits state on each tick for countdown UI updates

---

## Networking Layer

### REST Integration

The application communicates with a RESTful backend through a structured pipeline:

1. **APIConfig** -- Manages base URL, supports dynamic host switching (useful for staging/production), persists host preference in SharedPreferences
2. **APIRequest** -- Builder pattern encoding HTTP method, path, body, query parameters, headers, and authorization strategy
3. **DioProvider** -- Singleton Dio instance with configurable timeouts, logging interceptors, multipart support, and file download capabilities
4. **Response handling** -- Success (200/201/202/204) returns the raw response; all other codes throw `AppException` with parsed server error details

### Models and Mapping

Each feature defines:
- **Models** (data layer) -- JSON-serializable classes with `fromJson` / `toJson` factories
- **Entities** (domain layer) -- Pure Dart objects decoupled from serialization
- **Response wrappers** -- Typed response classes that parse paginated or nested API responses

The mapping boundary sits in the repository implementation, which converts models to entities before returning to the domain layer.

### Error Wrapping

Every network failure is caught at the `DioProvider` level and converted to an `AppException`. Repositories may add context-specific wrapping. BLoCs catch `AppException` and emit typed failure states. The UI layer uses `LocalizedErrorMessages` to convert error codes into locale-appropriate strings.

---

## Advanced Engineering Practices

### SOLID Principles

- **Single Responsibility** -- Each class has one reason to change: BLoCs handle state transitions, use cases encapsulate business rules, repositories abstract data access, data sources handle I/O
- **Open/Closed** -- New features are added as independent modules without modifying existing code; the service locator registers new dependencies additively
- **Liskov Substitution** -- Repository interfaces in the domain layer are implemented by data-layer classes; any implementation can be swapped (e.g., mock repositories for testing)
- **Interface Segregation** -- Repository contracts expose only the methods their consumers need; data sources have focused APIs
- **Dependency Inversion** -- BLoCs depend on use case abstractions, not concrete repositories; use cases depend on repository interfaces, not data sources

### Modular Design

Every feature is a self-contained module with its own BLoC, models, screens, and widgets. Features expose a barrel file (e.g., `vehicles.dart`, `violations.dart`, `parking_map.dart`) that controls the public API. Cross-feature communication happens through shared services and refresh notifiers registered in the service locator.

### Scalability Decisions

- **Factory-registered BLoCs** ensure each screen gets a fresh instance, preventing state leakage
- **Singleton NotificationsBloc** preserves notification read state across navigation without redundant API calls
- **Refresh notifiers** (`ParkingListRefreshNotifier`, `VehiclesListRefreshNotifier`, `BookingsListRefreshNotifier`, `HomeRefreshNotifier`) enable cross-feature cache invalidation without tight coupling
- **Barrel exports** prevent internal implementation details from leaking across feature boundaries

### Performance Optimizations

- **Lazy singleton registration** -- Dependencies are instantiated only when first accessed
- **CancelToken propagation** -- Long-running API calls and downloads can be cancelled when the user navigates away
- **Timer-based fetch throttling** -- `BookingTimerService` caches API responses and only re-fetches when the last fetch exceeds a configurable staleness threshold (60 seconds)
- **Infinite list pagination** -- `InfiniteListViewWidget` supports paginated loading to avoid fetching entire datasets
- **ScreenUtil** with `minTextAdapt` and `splitScreenMode` -- Efficient layout computation across device sizes

---

## Installation and Setup

### Prerequisites

- Flutter SDK >= 3.8.1
- Dart SDK (bundled with Flutter)
- Android Studio or VS Code with Flutter extensions
- A physical device or emulator (Android / iOS)

### Steps

```bash
# Clone the repository
git clone <repository-url>
cd "Parking Application"

# Install dependencies
flutter pub get

# Generate localization files (if modified)
flutter gen-l10n

# Run on a connected device
flutter run
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS (requires macOS with Xcode)
flutter build ios --release
```

---

## Environment Configuration

### API Host

The application supports both static and dynamic API host configuration:

- **Static** -- Set the base URL in `lib/data/datasources/network/api_config.dart`
- **Dynamic (debug)** -- When `useDynamicApiHost` is enabled, the app reads the host from SharedPreferences and provides a runtime dialog to change it, useful for switching between staging and production servers without rebuilding

### Localization

- Source strings are defined in `lib/l10n/app_en.arb` (English) and `lib/l10n/app_ar.arb` (Arabic)
- The app auto-generates `app_localizations.dart` via `flutter gen-l10n`
- Runtime locale switching is managed by `LocaleCubit` and persisted through `LanguageService`

### Assets

- Images: `assets/images/`
- Car logos: `assets/car_logo/`
- Fonts: IBM Plex Sans Arabic (primary), Inter (English), Cairo (Arabic fallback)

### App Icon

Configured via `flutter_launcher_icons` in `pubspec.yaml`. Regenerate with:

```bash
flutter pub run flutter_launcher_icons
```

---

## Future Improvements

- Real-time parking availability via WebSocket or Server-Sent Events
- Push notification integration (Firebase Cloud Messaging)
- Payment gateway integration (Stripe, PayPal, or local providers)
- Unit and integration test coverage with mock repositories
- CI/CD pipeline with automated build, test, and deployment
- Dark theme support leveraging the existing `AppColors` and `AppTheme` infrastructure
- Analytics and crash reporting (Firebase Analytics, Sentry)
- Accessibility audit and screen reader optimization
- Rate limiting and request deduplication in the queue manager
- Background location tracking for navigation to parking lots

---

## Screenshots

> Screenshots will be added here.

| Screen | Description |
|--------|-------------|
| ![Splash](screenshots/splash.png) | Splash and routing |
| ![Onboarding](screenshots/onboarding.png) | First-launch onboarding |
| ![Login](screenshots/login.png) | Authentication |
| ![Map](screenshots/map.png) | Parking map discovery |
| ![Booking](screenshots/booking.png) | Booking flow |
| ![Dashboard](screenshots/dashboard.png) | Owner dashboard |
| ![Vehicles](screenshots/vehicles.png) | Vehicle management |
| ![Notifications](screenshots/notifications.png) | Notification inbox |

---

**Built with Flutter** | Clean Architecture | BLoC Pattern | Offline-First Design

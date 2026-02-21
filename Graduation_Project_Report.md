# Graduation Project Report

## Smart Parking Mobile Application — Flutter Frontend

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Application Architecture](#2-application-architecture)
3. [State Management](#3-state-management)
4. [Used Technologies and Packages](#4-used-technologies-and-packages)
5. [Main Features Explanation](#5-main-features-explanation)
6. [Error Handling and User Experience](#6-error-handling-and-user-experience)
7. [Performance and Code Quality](#7-performance-and-code-quality)
8. [Security Considerations](#8-security-considerations)
9. [Conclusion](#9-conclusion)

---

## 1. Project Overview

### 1.1 General Idea

The **Smart Parking Application** is a cross-platform mobile application built with the Flutter framework. It serves as a comprehensive parking management system that connects parking lot owners with drivers seeking available parking spaces. The application provides real-time parking availability through an interactive map, enables online booking and payment, and offers a management dashboard for parking lot owners to monitor their operations.

The application communicates with a remote backend server through RESTful APIs. This report focuses exclusively on the Flutter frontend implementation.

### 1.2 Target Users

The application serves two distinct user roles:

- **Drivers (Regular Users):** Individuals who need to find nearby parking lots, view availability in real time, book and pay for parking spaces, manage their registered vehicles, and track their active bookings with countdown timers.

- **Parking Lot Owners:** Business operators who register their parking lots on the platform, monitor occupancy and revenue through a dedicated dashboard, view booking statistics, and manage their parking lot information.

### 1.3 Main Goal

The primary goal of this project is to reduce the time and effort drivers spend searching for parking by digitizing the parking discovery, reservation, and payment process. For owners, the goal is to provide a centralized tool to manage their parking operations and gain insights into occupancy and revenue performance.

---

## 2. Application Architecture

### 2.1 General Structure

The project follows **Clean Architecture** principles, which enforce a clear separation between the user interface, business logic, and data access layers. The `lib/` directory is organized into the following top-level modules:

| Directory | Responsibility |
|-----------|---------------|
| `core/` | Shared utilities, styles, themes, widgets, services, dependency injection, routing, and localization support used across all features. |
| `data/` | Application-wide data layer containing the network configuration (Dio HTTP client, API configuration) and local storage repositories for authentication tokens and app settings. |
| `features/` | Feature modules, each encapsulating its own data, domain, and presentation layers. |
| `l10n/` | Localization files supporting Arabic and English languages. |

### 2.2 Feature Module Structure

Each feature module inside `features/` is organized into up to three sub-layers following Clean Architecture:

```
feature/
├── data/
│   ├── datasources/       # Remote API data sources
│   ├── models/            # Data Transfer Objects (JSON parsing)
│   └── repositories/      # Repository implementations
├── domain/
│   ├── entities/          # Pure business objects (no framework dependency)
│   ├── repositories/      # Abstract repository interfaces
│   └── usecases/          # Business logic use cases
└── presentation/
    ├── bloc/              # BLoC classes (events, states, bloc)
    ├── pages/             # Screen-level widgets
    └── widgets/           # Reusable UI components for this feature
```

This layered approach ensures that:

- The **Data Layer** is responsible for communicating with the backend API and converting JSON responses into model objects.
- The **Domain Layer** defines pure business entities and use case classes that encapsulate a single unit of business logic. It has no dependency on Flutter or any external package.
- The **Presentation Layer** manages the UI and user interactions, relying on the BLoC pattern for state management.

### 2.3 Separation of Concerns

The architecture strictly separates concerns through the following mechanisms:

- **Repository Pattern:** Abstract repository interfaces are defined in the domain layer. Concrete implementations reside in the data layer, allowing the business logic to remain independent of how data is fetched.
- **Use Cases:** Each distinct business operation (e.g., searching for nearby parking, paying a violation) is encapsulated in its own use case class. This makes the business logic testable and reusable.
- **Dependency Injection:** The `GetIt` service locator (`service_locator.dart`) registers all data sources, repositories, use cases, and BLoC instances centrally. This promotes loose coupling, as components receive their dependencies through injection rather than direct instantiation.

### 2.4 Routing and Navigation

The application uses the `go_router` package for declarative, URL-based navigation. Key routing decisions include:

- A `StatefulShellRoute.indexedStack` is used for bottom navigation tabs, preserving the state of each tab when the user switches between them.
- Custom page transitions are applied for authentication screens to enhance the visual experience.
- Route paths are defined as constants in `app_routes.dart`, preventing hardcoded strings throughout the codebase.
- BLoC providers are scoped to specific routes, ensuring that state is created and disposed at the appropriate lifecycle point.

---

## 3. State Management

### 3.1 Chosen Approach: BLoC (Business Logic Component)

The application uses the **flutter_bloc** package (version 8.1.6) as its state management solution. BLoC was chosen for the following reasons:

1. **Clear Separation:** BLoC enforces a strict unidirectional data flow where the UI dispatches **Events** and receives **States**. This makes the logic predictable and easy to trace.
2. **Scalability:** Each feature has its own BLoC (or multiple BLoCs), which prevents a single monolithic state object and makes the application easier to maintain as it grows.
3. **Testability:** Because BLoCs are plain Dart classes that receive events and emit states, they can be unit tested without any Flutter widget dependencies.

### 3.2 How State Flows

The state management follows a consistent pattern across all features:

```
  User Interaction
        │
        ▼
  UI dispatches an Event to the BLoC
        │
        ▼
  BLoC processes the Event
   (calls Use Case → Repository → API)
        │
        ▼
  BLoC emits a new State
        │
        ▼
  UI rebuilds in response to the new State
```

**Concrete example — Login flow:**

1. The user fills in email and password fields. Each keystroke dispatches an `UpdateEmail` or `UpdatePassword` event.
2. When the user taps the login button, a `SendLoginRequest` event is dispatched.
3. The `LoginBloc` validates the input fields. If validation fails, it emits a state with field-level error messages.
4. If validation succeeds, the BLoC emits `LoginLoading`, calls the authentication API, and then emits either `LoginSuccess` (with the user data) or `LoginFailure` (with the error message).
5. The UI listens to these state changes: it shows a loading indicator during `LoginLoading`, navigates to the home screen on `LoginSuccess`, or displays an error snackbar on `LoginFailure`.

### 3.3 Application-Wide vs. Feature-Scoped BLoCs

- **Application-wide BLoCs** (such as `LocaleCubit` for language switching and `SplashRoutingBloc` for initial routing) are provided at the root of the widget tree using `MultiBlocProvider`.
- **Feature-scoped BLoCs** (such as `VehiclesBloc`, `NotificationsBloc`, `ParkingMapBloc`) are provided at the route level via `BlocProvider`, ensuring they are created when the user navigates to the feature and disposed when the user leaves.

### 3.4 Async Operations with AsyncRunner

The application introduces a custom `AsyncRunner` utility that wraps asynchronous BLoC operations with:

- **Retry logic** with exponential backoff for transient network failures.
- **Cancellation support** using Dio's `CancelToken`, allowing in-flight API requests to be cancelled when the user navigates away.
- **Duplicate call prevention**, ensuring that the same operation is not triggered multiple times concurrently.

---

## 4. Used Technologies and Packages

### 4.1 Core Framework

| Technology | Purpose |
|-----------|---------|
| **Flutter 3.8.1+** | Cross-platform UI framework for building the mobile application. |
| **Dart** | Programming language used by Flutter. |

### 4.2 Networking and API Communication

| Package | Purpose |
|---------|---------|
| **dio 5.4.0** | HTTP client used for all API communication. Chosen over the default `http` package for its support of interceptors, request cancellation, file downloads with progress tracking, and form data handling. |

The networking layer is centralized in a `DioProvider` singleton that configures:

- Base URL resolution through a dynamic `ApiConfig` class (supports switching API hosts at runtime for development and testing).
- An `APIRequest` builder that constructs requests with method, headers, query parameters, body, and authorization token injection.
- Error interceptors that convert Dio-specific exceptions into a unified `AppException` class.

### 4.3 State Management

| Package | Purpose |
|---------|---------|
| **flutter_bloc 8.1.6** | BLoC and Cubit classes for managing application state. |

### 4.4 Dependency Injection

| Package | Purpose |
|---------|---------|
| **get_it 7.7.0** | Service locator for registering and resolving dependencies throughout the application. |

### 4.5 Local Storage

| Package | Purpose |
|---------|---------|
| **hive_flutter 1.1.0** | Lightweight, fast key-value database used for storing authentication tokens and queued requests for offline support. |
| **shared_preferences** | Simple key-value storage for app settings such as language preference, onboarding completion status, and cached profile data. |

### 4.6 Navigation

| Package | Purpose |
|---------|---------|
| **go_router 14.0.0** | Declarative routing with support for nested navigation, shell routes for bottom navigation bars, and route-level BLoC providers. |

### 4.7 Maps and Location

| Package | Purpose |
|---------|---------|
| **flutter_osm_plugin 1.4.3** | Open Street Map integration for displaying parking lot locations on an interactive map. |
| **geolocator 13.0.1** | Accessing the device GPS to obtain the user's current location for nearby parking search. |

### 4.8 UI and Responsiveness

| Package | Purpose |
|---------|---------|
| **flutter_screenutil 5.9.0** | Responsive layout utility that scales dimensions based on the device screen size, ensuring consistent UI across different devices. |

### 4.9 Localization

The application supports **Arabic** and **English** languages using Flutter's built-in localization framework with ARB (Application Resource Bundle) files. The localization covers approximately **1,987 translation keys**, providing full bilingual support for all user-facing text including error messages, validation prompts, and success confirmations.

### 4.10 Additional Notable Packages

| Package | Purpose |
|---------|---------|
| **Custom Fonts** | IBM Plex Sans Arabic, Inter, and Cairo font families for a polished, multilingual typographic experience. |

---

## 5. Main Features Explanation

### 5.1 Splash Screen and Onboarding

**What it does:** When the application launches, a splash screen is displayed while the app determines where to route the user. First-time users are shown an onboarding sequence that introduces the application's purpose.

**How it works technically:** The `SplashRoutingBloc` runs a decision chain:
1. It checks whether the onboarding has been completed (via `SettingsLocalRepository`). If not, the user is routed to the onboarding screens.
2. It checks for a saved authentication token (via `AuthLocalRepository`). If no token exists, the user is routed to the login screen.
3. If a token exists, it reads the user type (owner or regular user) and routes to the corresponding main screen.

**Backend communication:** No API calls are made during splash; the decision is based entirely on locally stored data.

---

### 5.2 Authentication (Login and Registration)

**What it does:** Users can create a new account by providing their full name, email, phone number, user type (driver or owner), and password. Existing users can log in with their email and password.

**How it works technically:**
- The `LoginBloc` and `RegisterBloc` handle form field updates, client-side validation, and API request dispatching.
- Validation is performed using a centralized `AuthValidators` class that maps `ValidationErrorType` enum values to localized error messages. Errors are shown only after the user attempts to submit the form, not while typing — an intentional UX decision to reduce distraction.
- Upon successful login, the authentication token and user data are stored locally using Hive. For owners, an additional check verifies that the account is active (approved by the platform administrator); inactive owners are blocked from proceeding.

**Backend communication:**
- Login: `POST` to the login endpoint with email and password.
- Registration: `POST` to the registration endpoint with full user details.

---

### 5.3 Interactive Parking Map

**What it does:** Drivers can view all registered parking lots on an interactive OpenStreetMap-based map. Markers are color-coded based on parking availability. Users can tap a marker to view detailed information and optionally get driving directions or proceed to book a space.

**How it works technically:**
- The `ParkingMapBloc` manages the map state including parking lot data, user location, selected lot, and search mode.
- Parking lot markers are rendered with distinct colors: green for high availability, orange for moderate, red for nearly full, and gray for completely full.
- When a user taps a marker, a draggable bottom sheet (`ParkingDetailsBottomSheet`) slides up showing the lot name, address, available spaces, hourly rate, and action buttons.
- The "Get Directions" button draws a route on the map from the user's location to the selected parking lot.
- The "Search Nearby" feature uses the device GPS to find parking lots within a configurable radius.

**Backend communication:**
- `GET` all parking lots for map display (public endpoint, no authentication required).
- `GET` parking lot details by ID.
- `GET` nearby parking lots by latitude, longitude, and radius (authenticated endpoint).

---

### 5.4 Booking System

**What it does:** After selecting a parking lot, drivers can book a parking space by choosing a duration (1 hour, 2 hours, or a custom number of hours), selecting a registered vehicle, and confirming the booking. Active bookings display a real-time countdown timer.

**How it works technically:**
- The `BookingPrePaymentScreen` allows the user to select duration and vehicle. The total price is calculated locally (hourly rate × hours). Upon confirmation, a booking creation request is sent.
- The `BookingDetailsBloc` loads booking details and manages a `BookingTimerService` that provides a real-time countdown. The timer decrements locally every second and re-syncs with the server periodically (if the last API fetch was more than one minute ago).
- Visual warnings appear when the remaining time drops below 10 minutes. The booking can be extended or cancelled from the details screen.
- The `UserHomePage` displays an overlay of active bookings as a horizontally scrollable list with live countdown timers.
- A conflict handler manages the case where a user already has an active booking (HTTP 409 response), redirecting them to the existing booking's payment flow instead.

**Backend communication:**
- `POST` to create a booking.
- `GET` booking details and remaining time.
- `POST` to extend or cancel a booking.
- `GET` to download invoices (file download with progress tracking).

---

### 5.5 Vehicle Management

**What it does:** Drivers can register their vehicles (plate number, type, color, etc.), edit vehicle information, and delete vehicles that are no longer needed.

**How it works technically:**
- The `VehiclesBloc` manages the full CRUD lifecycle.
- Adding a vehicle dispatches `AddVehicleRequested`, which calls the `AddVehicleUseCase`. On success, the vehicle list is automatically reloaded.
- Updating a vehicle creates a **modification request** that may require approval, rather than applying the change immediately.
- Deleting a vehicle with an active booking returns a `409 Conflict` error, which is handled gracefully with a localized message.
- The `VehiclesListRefreshNotifier` (a `ChangeNotifier`) enables cross-feature communication, allowing other parts of the app to trigger a refresh of the vehicle list.

**Backend communication:**
- `GET` all vehicles for the authenticated user.
- `POST` to create a new vehicle.
- `PUT` to update an existing vehicle.
- `DELETE` to remove a vehicle.

---

### 5.6 Parking Management (Owner)

**What it does:** Parking lot owners can register new parking lots, update their information (name, address, hourly rate, total spaces, location coordinates), and view a dashboard with occupancy and financial statistics.

**How it works technically:**
- The `CreateParkingBloc` and `UpdateParkingBloc` manage form state for creating and editing parking lots respectively. Coordinates are selected using a dedicated `MapLocationPickerScreen` where the owner can drag the map to place a pin.
- The `ParkingListBloc` supports search and filtering (by parking status) for owners with multiple lots.
- The `ParkingStatsBloc` fetches a comprehensive dashboard from the backend containing summary statistics, occupancy rates, financial data, and booking breakdowns. The `ParkingDashboardScreen` renders these as KPI cards, occupancy indicators, and statistics sections.

**Backend communication:**
- `POST` to create a new parking lot.
- `PUT` to update a parking lot.
- `GET` owner's parking lots.
- `GET` aggregated dashboard statistics.

---

### 5.7 Violations

**What it does:** Drivers can view their parking violations, separated into unpaid and paid categories, and pay outstanding violations directly through the app.

**How it works technically:**
- The `ViolationsBloc` manages two separate lists (unpaid and paid). The UI uses a tab-based layout.
- Paying a violation dispatches `PayViolationRequested`. On success, the unpaid violations list is automatically refreshed.
- Each violation displays related parking lot and vehicle information, which are parsed from nested API response objects.

**Backend communication:**
- `GET` unpaid violations.
- `GET` paid violations (last 10 records).
- `POST` to pay a specific violation.

---

### 5.8 Notifications

**What it does:** Users receive notifications about booking confirmations, violations, and other system events. Notifications are organized into unread and read tabs.

**How it works technically:**
- The `NotificationsBloc` loads all notifications and separates them into unread and read lists within a `NotificationsResult` entity.
- Marking a notification as read uses **optimistic updates**: the UI moves the notification from the unread list to the read list immediately, without waiting for the API response. If the API call fails, the change is reverted.
- The presentation layer is optimized for performance using `BlocSelector` (to avoid unnecessary rebuilds), `RepaintBoundary` (to isolate repainting), and cached dimension calculations.
- A notification badge on the main screen indicates the count of unread notifications.

**Backend communication:**
- `GET` all notifications.
- `PUT` to mark a notification as read.

---

### 5.9 Profile Management

**What it does:** Users can view and edit their personal information, change their password, switch the application language, and delete their account.

**How it works technically:**
- The `ProfileBloc` implements a **cache-first strategy**: it immediately displays cached profile data from `ProfileCacheService` (SharedPreferences), then fetches the latest data from the API in the background. This provides an instant loading experience.
- Editing the profile enters an edit mode within the same screen. On save, the updated data is sent to the backend and the local cache is refreshed.
- Password update and account deletion clear all local authentication data and redirect the user to the login screen.
- Language switching is handled by the `LocaleCubit`, which persists the preference via `LanguageService` and rebuilds the app with the new locale.

**Backend communication:**
- `GET` user profile data.
- `PUT` to update profile information.
- `PUT` to change password.
- `POST` to delete account.

---

## 6. Error Handling and User Experience

### 6.1 Centralized Error Model

All API errors are converted into a unified `AppException` class that carries:
- An HTTP `statusCode` (e.g., 401, 404, 422, 500).
- An application-specific `errorCode` string.
- A human-readable `message`.
- Optional `fieldErrors` for form-level validation errors returned by the backend.

This centralization means that every feature handles errors through a single, consistent interface.

### 6.2 Localized Error Messages

The `LocalizedErrorMessages` utility translates `AppException` error codes into localized strings using the application's localization system. This covers categories such as:

- **Network errors:** Connection timeout, no internet connection.
- **Authentication errors:** Invalid credentials, account not active.
- **Validation errors:** Invalid email, short password, duplicate plate number.
- **Business errors:** Booking conflict, vehicle has active booking, parking lot full.
- **Server errors:** Generic server failure with a user-friendly message.

### 6.3 Loading, Success, and Error States

Every BLoC follows a consistent state pattern:

- **Loading State:** Emitted before an API call. The UI displays a `LoadingWidget` (a centered circular progress indicator).
- **Success State:** Emitted with the response data. The UI renders the content.
- **Error State:** Emitted with the error message. The UI displays an `ErrorStateWidget` with a descriptive message and a "Retry" button.
- **Empty State:** Some features (vehicles, notifications, violations) emit a dedicated empty state when the API returns an empty list, displaying a helpful illustration or message.

### 6.4 User Feedback Mechanisms

- **UnifiedSnackbar:** A custom overlay-based snackbar system that supports four types (success, error, info, warning), each with distinct colors and icons. Being overlay-based means snackbars display correctly even above dialogs and bottom sheets.
- **Form Validation Feedback:** Input fields show helper text by default and switch to error text with a red border when validation fails. Validation errors are shown only after form submission to avoid premature error messages.
- **Optimistic Updates:** The notifications feature applies UI changes immediately (e.g., moving a notification from unread to read) and reverts if the API call fails, providing a snappy user experience.
- **API Connection Error Dialog:** When a network connection error occurs, a dialog offers the user options to retry the request, change the server address (useful during development), or cancel.

---

## 7. Performance and Code Quality

### 7.1 Reusable Widgets

The `core/widgets/` directory contains a library of shared, configurable widgets that are used throughout the application:

| Widget | Purpose |
|--------|---------|
| `CustomTextField` | Standardized text input with validation, helper text, error display, and password visibility toggle. |
| `CustomElevatedButton` | Themed button with loading state support. |
| `CustomDropdownField` | Styled dropdown selector. |
| `CustomDatePickerField` | Date picker with formatted display. |
| `LoadingWidget` | Centered loading indicator. |
| `ErrorStateWidget` | Error display with retry action. |
| `InfiniteListViewWidget` | Lazy-loading list with pagination support. |
| `UnifiedSnackbar` | Overlay-based notification toasts. |

By centralizing these widgets, the codebase avoids duplication and ensures a uniform look and feel across all screens.

### 7.2 Separation of Concerns

- **BLoC classes** contain no UI code; they only process events and emit states.
- **Use case classes** contain no data-fetching logic; they delegate to repository interfaces.
- **Repository implementations** contain no business logic; they convert API responses to domain models.
- **Presentation widgets** contain no direct API calls; they interact exclusively through BLoC events.

This disciplined separation makes each component independently testable and replaceable.

### 7.3 Consistent Design System

The `core/styles/` directory defines a centralized design system:

- `AppColors`: All color values used in the application, including primary palette, status colors, gradients, and occupancy-level colors.
- `AppTextStyles`: Theme-based text style factory methods (field labels, input text, button text, card titles, etc.).
- `AppDimens`: Spacing, padding, border radius, icon size, and button height constants.
- `AppDurations`: Animation durations, snackbar display times, network timeouts, and debounce intervals.

This system ensures visual consistency and makes it straightforward to update the design globally.

### 7.4 Code Readability and Maintainability

- **Barrel exports:** Each feature module provides a barrel file (e.g., `vehicles.dart`, `notifications.dart`) that re-exports all public classes, simplifying import statements.
- **Named constants and enums:** Magic numbers and strings are replaced with named constants (`AppRoutes`, `AppDimens`, `AppDurations`) and enums (`LoadingType`, `ValidationErrorType`).
- **Error handling mixins:** Features share error handling logic through mixins (e.g., `VehiclesErrorHandlerMixin`, `ViolationsErrorHandlerMixin`), reducing code duplication in the presentation layer.
- **Refresh notifiers:** Cross-feature communication (e.g., refreshing the booking list after a payment) is handled through `ChangeNotifier` services registered in the service locator, avoiding tight coupling between features.

### 7.5 Responsive Design

The application uses `flutter_screenutil` to adapt all dimensions (font sizes, paddings, margins, icon sizes) to the device screen size. The `ScreenUtilInit` widget wraps the entire application and configures a design reference size, ensuring that the UI looks proportional on both small and large screens.

---

## 8. Security Considerations

### 8.1 API Token Handling

- Authentication tokens are stored locally using **Hive**, a fast and lightweight database that stores data in encrypted binary format on the device filesystem.
- Every authenticated API request is constructed through the `APIRequest` builder, which automatically injects the `Bearer` token into the `Authorization` header when the `authorizationOption` is set to `authorized`. This eliminates the risk of developers forgetting to include the token manually.
- On logout, password change, or account deletion, the `clearAuthData()` method in `AuthLocalRepository` removes the token and user data from local storage.

### 8.2 Sensitive Data Storage

- User credentials (email and password) are **never stored** locally. Only the authentication token and basic user profile information (name, email, user type) are persisted.
- Profile data cached for instant loading is stored in SharedPreferences, which is appropriate for non-sensitive display data. The actual authentication state is determined by the token in Hive.

### 8.3 Network Security

- The Dio HTTP client is configured with request and response interceptors. In debug mode, these interceptors log request and response details for development purposes; these logs are not active in release builds.
- The API configuration supports dynamic host switching, which is restricted to development and testing environments. This allows the team to point the app at different backend instances without rebuilding.

### 8.4 Input Validation

- All user inputs are validated on the client side before being sent to the backend. This includes email format validation, password length enforcement (minimum 8 characters), phone number format checks, and required field validation.
- Backend validation errors (HTTP 422) are also handled and displayed to the user with localized messages, providing a double layer of input verification.

---

## 9. Conclusion

### 9.1 Strengths of the Project

1. **Clean Architecture Implementation:** The strict separation into data, domain, and presentation layers ensures that each component has a single responsibility. This makes the codebase maintainable, testable, and extensible.

2. **Comprehensive Feature Set:** The application covers the full parking lifecycle — from discovering parking lots on a map, through booking and payment, to violation management and owner-side analytics. This demonstrates the team's ability to build a complete, real-world product.

3. **Professional State Management:** The consistent use of the BLoC pattern with well-defined events, states, and a custom async runner shows a mature understanding of reactive programming and unidirectional data flow.

4. **Bilingual Support:** Full localization with approximately 1,987 translation keys across Arabic and English demonstrates attention to accessibility and market readiness.

5. **User Experience Focus:** Features such as optimistic updates for notifications, cache-first profile loading, real-time countdown timers for bookings, and overlay-based snackbars reflect a strong emphasis on providing a smooth and responsive user experience.

6. **Centralized Error Handling:** The unified `AppException` model, localized error messages, and consistent loading/error/empty states across all features show a systematic approach to error management.

7. **Reusable Component Library:** The shared widget library and centralized design system (colors, text styles, dimensions, durations) promote consistency and reduce development effort.

8. **Scalable Dependency Injection:** Using GetIt as a service locator with clearly structured registration of data sources, repositories, use cases, and BLoCs enables the application to scale gracefully as new features are added.

### 9.2 Suitability as a Graduation Project

This project is well-suited as a graduation project for the following reasons:

- It addresses a **real-world problem** (urban parking inefficiency) with a practical digital solution.
- It demonstrates mastery of **advanced Flutter concepts** including Clean Architecture, BLoC state management, dependency injection, declarative routing, localization, and responsive design.
- The codebase follows **industry best practices** for structuring a medium-to-large-scale Flutter application, including separation of concerns, reusable components, and centralized configuration.
- The multi-role architecture (driver and owner) showcases the ability to handle **different user journeys** within a single application.
- The integration of **map-based features**, **real-time timers**, and **cross-feature communication** adds meaningful technical complexity beyond basic CRUD operations.

Overall, the Smart Parking Application represents a well-engineered, feature-rich mobile frontend that reflects both solid software engineering principles and practical problem-solving ability.

---

*This report was prepared to document the Flutter frontend implementation of the Smart Parking Application graduation project. The backend server and its API endpoints are assumed to be operational and are not covered in this report.*

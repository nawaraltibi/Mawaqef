# Violations Feature - Architecture Documentation

## 📁 Feature Structure

```
lib/features/violations/
├── data/
│   ├── models/
│   │   ├── violation_model.dart
│   │   ├── parking_lot_model.dart
│   │   ├── vehicle_model.dart
│   │   ├── unpaid_violations_response.dart
│   │   ├── paid_violations_response.dart
│   │   ├── pay_violation_request.dart
│   │   └── pay_violation_response.dart
│   ├── datasources/
│   │   └── violations_remote_datasource.dart
│   └── repositories/
│       └── violations_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── violation_entity.dart
│   │   ├── parking_lot_entity.dart
│   │   └── vehicle_entity.dart
│   ├── repositories/
│   │   └── violations_repository.dart
│   └── usecases/
│       ├── get_unpaid_violations.dart
│       ├── get_paid_violations.dart
│       └── pay_violation.dart
├── presentation/
│   └── bloc/
│       ├── violations_bloc.dart
│       ├── violations_event.dart
│       ├── violations_state.dart
│       └── mixins/
│           └── violations_error_handler_mixin.dart
└── violations.dart (barrel file)
```

## 🔄 Data Flow

### 1. API → Bloc → State Flow

```
UI Event
  ↓
ViolationsEvent (e.g., GetUnpaidViolationsRequested)
  ↓
ViolationsBloc
  ↓
UseCase (e.g., GetUnpaidViolationsUseCase)
  ↓
Repository Interface (ViolationsRepository)
  ↓
Repository Implementation (ViolationsRepositoryImpl)
  ↓
Remote Data Source (ViolationsRemoteDataSource)
  ↓
APIRequest → API Endpoint
  ↓
Response Model (e.g., UnpaidViolationsResponse)
  ↓
Entity Conversion (Model → Entity)
  ↓
UseCase Returns Entity
  ↓
Bloc Emits State (e.g., UnpaidViolationsLoaded)
  ↓
UI Updates
```

### 2. State Management Pattern

The feature uses **BLoC (Business Logic Component)** pattern with:

- **Events**: User actions (GetUnpaidViolationsRequested, PayViolationRequested, etc.)
- **States**: UI states (Loading, Loaded, Error, Empty, etc.)
- **AsyncRunner**: Handles async operations with retry logic and connectivity checks
- **Error Handler Mixin**: Centralized error handling

### 3. States Available

#### Initial States
- `ViolationsInitial`: Initial state when bloc is created

#### Loading States
- `ViolationsLoading`: Loading violations list
- `ViolationActionLoading`: Processing violation action (e.g., paying)

#### Success States
- `UnpaidViolationsLoaded`: Unpaid violations loaded successfully
- `PaidViolationsLoaded`: Paid violations loaded successfully
- `ViolationActionSuccess`: Action completed successfully (e.g., payment)

#### Error States
- `ViolationsError`: Error loading violations
- `ViolationActionFailure`: Error performing action

#### Empty States
- `ViolationsEmpty`: No violations found

## 🌐 API Integration

### 1. Get Unpaid Violations
- **Endpoint**: `GET /api/violation/allunpaid`
- **Response**: List of violations with parking_lot and vehicle objects
- **Use Case**: `GetUnpaidViolationsUseCase`
- **Event**: `GetUnpaidViolationsRequested`

### 2. Get Paid Violations
- **Endpoint**: `GET /api/violation/allpaid`
- **Response**: Last 10 paid violations
- **Use Case**: `GetPaidViolationsUseCase`
- **Event**: `GetPaidViolationsRequested`

### 3. Pay Violation
- **Endpoint**: `POST /api/violation/payviolation/:violationId`
- **Body**: `{ "payment_method": "cash" }`
- **Use Case**: `PayViolationUseCase`
- **Event**: `PayViolationRequested`

## 🏗️ Architecture Principles

### Clean Architecture Layers

1. **Domain Layer** (Business Logic)
   - Entities: Pure business objects
   - Repository Interfaces: Contracts for data operations
   - Use Cases: Single responsibility business operations

2. **Data Layer** (Data Sources)
   - Models: JSON serialization/deserialization
   - Data Sources: API calls
   - Repository Implementations: Domain contract implementations

3. **Presentation Layer** (UI Logic)
   - BLoC: State management
   - Events: User actions
   - States: UI states

### SOLID Principles

- **Single Responsibility**: Each use case handles one operation
- **Open/Closed**: Repository interface allows extension
- **Liskov Substitution**: Repository implementation follows interface contract
- **Interface Segregation**: Focused repository interface
- **Dependency Inversion**: Domain depends on abstractions, not implementations

## 📝 Usage Example

### In UI (Future Integration)

```dart
// Initialize Bloc
final violationsBloc = ViolationsBloc(
  getUnpaidViolationsUseCase: GetUnpaidViolationsUseCase(repository),
  getPaidViolationsUseCase: GetPaidViolationsUseCase(repository),
  payViolationUseCase: PayViolationUseCase(repository),
);

// Listen to states
BlocBuilder<ViolationsBloc, ViolationsState>(
  builder: (context, state) {
    if (state is ViolationsLoading) {
      return LoadingWidget();
    } else if (state is UnpaidViolationsLoaded) {
      return ViolationsList(violations: state.violations);
    } else if (state is ViolationsError) {
      return ErrorWidget(message: state.error);
    } else if (state is ViolationsEmpty) {
      return EmptyStateWidget();
    }
    return SizedBox.shrink();
  },
)

// Dispatch events
violationsBloc.add(GetUnpaidViolationsRequested());
violationsBloc.add(PayViolationRequested(
  violationId: 123,
  paymentMethod: 'cash',
));
```

## 🔐 Error Handling

- **AppException**: Centralized exception handling
- **Error Handler Mixin**: Extracts error messages and status codes
- **Validation Errors**: Handles field-level validation errors from API
- **Network Errors**: Handled by AsyncRunner and DioProvider

## 🚀 Future Extensions

The architecture is ready for:
- **Pagination**: Add page/limit parameters to use cases
- **Caching**: Add local data source layer
- **Offline Support**: AsyncRunner already supports offline tasks
- **Real-time Updates**: Add stream support to repository
- **Filtering/Sorting**: Extend use cases with filter parameters

## 📦 Dependencies

- `flutter_bloc`: State management
- `async`: AsyncRunner for async operations
- `dio`: HTTP client (via APIRequest)
- `equatable`: State comparison (if needed in future)

## ✅ Best Practices Followed

- ✅ Clear separation of concerns
- ✅ Immutable states
- ✅ No business logic in UI
- ✅ Proper naming conventions
- ✅ Nullable fields handled safely
- ✅ Production-ready code structure
- ✅ Ready for pagination & future extensions


# Notifications Feature - Architecture Documentation

## 📁 Feature Structure

```
lib/features/notifications/
├── data/
│   ├── models/
│   │   ├── notification_model.dart
│   │   ├── notifications_list_response.dart
│   │   └── mark_notification_read_response.dart
│   ├── datasources/
│   │   └── notifications_remote_datasource.dart
│   └── repositories/
│       └── notifications_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── notification_entity.dart
│   ├── repositories/
│   │   └── notifications_repository.dart
│   └── usecases/
│       ├── get_all_notifications.dart
│       └── mark_notification_as_read.dart
├── presentation/
│   └── bloc/
│       ├── notifications_bloc.dart
│       ├── notifications_event.dart
│       ├── notifications_state.dart
│       └── mixins/
│           └── notifications_error_handler_mixin.dart
└── notifications.dart (barrel file)


```

## 🔄 Data Flow

### 1. API → Bloc → State Flow

```
UI Event
  ↓
NotificationsEvent (e.g., GetAllNotificationsRequested)
  ↓
NotificationsBloc
  ↓
UseCase (e.g., GetAllNotificationsUseCase)
  ↓
Repository Interface (NotificationsRepository)
  ↓
Repository Implementation (NotificationsRepositoryImpl)
  ↓
Remote Data Source (NotificationsRemoteDataSource)
  ↓
APIRequest → API Endpoint
  ↓
Response Model (e.g., NotificationsListResponse)
  ↓
Entity Conversion (Model → Entity)
  ↓
Filter Unread Notifications (is_read = 0)
  ↓
UseCase Returns Entity List
  ↓
Bloc Emits State (e.g., NotificationsLoaded)
  ↓
UI Updates
```

### 2. Mark Notification as Read Flow

```
User Clicks Notification
  ↓
NotificationClickedEvent(notificationId)
  ↓
NotificationsBloc
  ↓
MarkNotificationAsReadUseCase
  ↓
Repository → DataSource → API
  ↓
PUT /api/updatestatusnotification/:notificationId
  ↓
Success Response
  ↓
Remove Notification from Current List
  ↓
Emit Updated NotificationsLoaded or NotificationsEmpty
```

## 🌐 API Integration

### 1. Get All Notifications

- **Endpoint**: `GET /api/allnotification`
- **Response**: List of all notifications (read and unread)
- **Filtering**: Repository layer filters to only return unread notifications (is_read = 0)
- **Use Case**: `GetAllNotificationsUseCase`
- **Event**: `GetAllNotificationsRequested`

### 2. Mark Notification as Read

- **Endpoint**: `PUT /api/updatestatusnotification/:notificationId`
- **Body**: None (notificationId in path)
- **Response**: Updated notification with is_read = 1
- **Use Case**: `MarkNotificationAsReadUseCase`
- **Event**: `NotificationClickedEvent(notificationId)`

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
   - **Filtering Logic**: Only unread notifications are returned to domain layer

3. **Presentation Layer** (UI Logic)
   - BLoC: State management
   - Events: User actions
   - States: UI states

### Key Behaviors

1. **Unread-Only Display**:
   - API returns all notifications, but repository filters to only unread ones
   - UI only sees unread notifications
   - When a notification is marked as read, it's immediately removed from the list

2. **Optimistic Updates**:
   - When marking as read, notification is removed from list immediately
   - If API call fails, previous state is restored

3. **State Management**:
   - Uses AsyncRunner for async operations
   - Handles loading, success, error, and empty states
   - Prevents UI flicker when clicking notifications

## 📝 Usage Example

### In UI (Future Integration)

```dart
// Initialize Bloc
final notificationsBloc = NotificationsBloc(
  getAllNotificationsUseCase: GetAllNotificationsUseCase(repository),
  markNotificationAsReadUseCase: MarkNotificationAsReadUseCase(repository),
);

// Listen to states
BlocBuilder<NotificationsBloc, NotificationsState>(
  builder: (context, state) {
    if (state is NotificationsLoading) {
      return LoadingWidget();
    } else if (state is NotificationsLoaded) {
      return NotificationsList(notifications: state.notifications);
    } else if (state is NotificationsError) {
      return ErrorWidget(message: state.error);
    } else if (state is NotificationsEmpty) {
      return EmptyStateWidget();
    }
    return SizedBox.shrink();
  },
)

// Dispatch events
notificationsBloc.add(GetAllNotificationsRequested());
notificationsBloc.add(NotificationClickedEvent(notificationId: 123));
```

## 🔐 Error Handling

- **AppException**: Centralized exception handling
- **Error Handler Mixin**: Extracts error messages and status codes
- **State Restoration**: On error, previous state is restored
- **Network Errors**: Handled by AsyncRunner and DioProvider

## 🚀 Future Extensions

The architecture is ready for:

- **Push Notifications (FCM)**: Can add stream support to repository
- **Real-time Updates**: Add WebSocket or polling support
- **Notification Categories**: Extend entity with type/category field
- **Batch Mark as Read**: Add use case for marking multiple as read
- **Notification History**: Add endpoint for read notifications

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
- ✅ Ready for push notifications & future extensions
- ✅ Only unread notifications exposed to UI
- ✅ Optimistic updates for better UX

## 🔍 Data Filtering Logic

The repository implementation filters notifications to only return unread ones:

```dart
// In NotificationsRepositoryImpl.getAllNotifications()
final unreadNotifications = response.notifications
    .where((model) => !model.isRead) // isRead = false means unread
    .map((model) => _modelToEntity(model))
    .toList();
```

This ensures:

- Domain layer only receives unread notifications
- UI never sees read notifications
- Clean separation of concerns

import 'dart:async';
import 'package:async/async.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// Multiple calls behavior enum
enum MultipleCallsBehavior { abortNew, abortOld }

/// Async Runner
/// Utility for running async tasks with retry logic, connectivity checks, and cancellation
/// 
/// Why this is valuable:
/// - Handles retry logic with exponential backoff
/// - Supports online/offline task differentiation
/// - Prevents duplicate concurrent calls
/// - Provides cancellation support
/// - Useful for API calls that need retry logic
class AsyncRunner<T> {
  CancelableOperation<T>? _currentOperation;
  CancelToken? dioCancelToken;
  T? _currentValue;

  final MultipleCallsBehavior multipleCallsBehavior;
  final int maxRetryAttempts;
  final Duration retryDelay;
  final bool useExponentialBackoff;
  final Duration? timeout;

  AsyncRunner({
    this.multipleCallsBehavior = MultipleCallsBehavior.abortNew,
    this.maxRetryAttempts = 0,
    this.retryDelay = const Duration(milliseconds: 500),
    this.useExponentialBackoff = true,
    this.timeout,
  });

  /// Getter for the current running operation.
  CancelableOperation<T>? get currentOperation => _currentOperation;

  /// Getter for the current value.
  T? get currentValue => _currentValue;

  /// Runs the asynchronous task with the provided callbacks.
  ///
  /// The [task] receives the previous result value instead of a CancelToken.
  Future<CancelableOperation<T>?> run({
    /// The asynchronous task to perform when online.
    /// It receives the previous result value.
    Future<T> Function(T? previousResult)? onlineTask,

    /// The asynchronous task to perform when offline.
    /// It receives the previous result value.
    Future<T> Function(T? previousResult)? offlineTask,

    /// The asynchronous task to perform (for backward compatibility).
    /// It receives the previous result value.
    /// If [onlineTask] is provided, this will be ignored.
    @Deprecated('Use onlineTask instead')
    Future<T> Function(T? previousResult)? task,

    /// Callback executed at the start of the operation.
    void Function()? onStart,

    /// Callback executed on success with the resulting value.
    FutureOr<void> Function(T result)? onSuccess,

    /// Callback executed when an error occurs, with the error passed.
    void Function(Object error)? onError,

    /// Callback executed when offline mode is detected.
    FutureOr<void> Function(T result)? onOffline,

    /// Callback executed when the operation is cancelled.
    void Function()? onCancel,

    /// Callback executed when multiple calls are detected.
    void Function()? onMultipleCalls,

    /// Check network connectivity before running task.
    /// If true, will use offlineTask when offline, onlineTask when online.
    bool checkConnectivity = true,
  }) async {
    // If there's an ongoing operation, handle it according to the specified behavior.
    if (_currentOperation != null && !_currentOperation!.isCompleted) {
      onMultipleCalls?.call();
      if (multipleCallsBehavior == MultipleCallsBehavior.abortNew) {
        // For abortNew behavior, ignore the new call.
        return null;
      } else {
        // For abortOld behavior, cancel the ongoing operation.
        cancel();
      }
    }

    // Create a new Dio CancelToken for the network request.
    dioCancelToken = CancelToken();

    // Execute the onStart callback.
    onStart?.call();

    int attempt = 0;
    Duration currentRetryDelay = retryDelay;
    CancelableOperation<T>? newOperation;

    // Determine which task to use
    final actualOnlineTask = onlineTask ?? task;
    final actualOfflineTask = offlineTask;

    // Check connectivity if needed
    bool isOnline = true;
    if (checkConnectivity &&
        (actualOnlineTask != null || actualOfflineTask != null)) {
      isOnline = await _checkNetworkConnectivity();
    }

    // Retry loop: keep trying until success or maximum attempts are reached.
    while (true) {
      try {
        // Determine which task to execute
        Future<T> taskFuture;
        if (checkConnectivity && !isOnline && actualOfflineTask != null) {
          // Use offline task when offline
          taskFuture = actualOfflineTask(_currentValue);
        } else if (actualOnlineTask != null) {
          // Use online task when online or when connectivity check is disabled
          taskFuture = actualOnlineTask(_currentValue);
        } else if (actualOfflineTask != null) {
          // Fallback to offline task if online task is not available
          taskFuture = actualOfflineTask(_currentValue);
        } else {
          throw Exception('No task provided');
        }

        if (timeout != null) {
          taskFuture = taskFuture.timeout(timeout!);
        }
        newOperation = CancelableOperation<T>.fromFuture(
          taskFuture,
          onCancel: () {
            onCancel?.call();
          },
        );

        // Wait for the result of the task.
        T result = await newOperation.value;
        _currentValue = result; // Store the current value

        // Call appropriate success callback
        if (checkConnectivity && !isOnline && onOffline != null) {
          await onOffline.call(result);
        } else {
          await onSuccess?.call(result);
        }

        _currentOperation = newOperation;
        return newOperation;
      } catch (e) {
        attempt++;
        if (attempt > maxRetryAttempts) {
          onError?.call(e);
          _currentOperation = newOperation;
          return newOperation;
        } else {
          await Future.delayed(currentRetryDelay);
          if (useExponentialBackoff) {
            currentRetryDelay *= 2;
          }
        }
      }
    }
  }

  /// Cancels the current operation if any.
  void cancel({
    /// Callback executed when the operation is cancelled.
    void Function()? onCancel,
  }) {
    onCancel?.call();
    _currentOperation?.cancel();
    dioCancelToken?.cancel("Cancelled by AsyncRunner");
    _currentOperation = null;
  }

  /// Resets the current value and operation.
  void reset() {
    _currentValue = null;
    _currentOperation = null;
    dioCancelToken = null;
  }

  /// Gets the current value.
  T? getValue() {
    return _currentValue;
  }

  /// Sets the current value manually.
  void setValue(T value) {
    _currentValue = value;
  }

  /// Check network connectivity
  static Future<bool> _checkNetworkConnectivity() async {
    try {
      final connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      // If connectivity check fails, assume online
      return true;
    }
  }
}


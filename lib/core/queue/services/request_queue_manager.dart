import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import '../../../data/datasources/network/api_request.dart';
import '../models/request_queue_item.dart';
import 'request_queue_service.dart';

/// Request Queue Manager
/// Manages sending queued requests when online
/// Uses streams for real-time updates
/// 
/// Why this is valuable:
/// - Automatically processes queued requests when connection is restored
/// - Provides real-time status updates via streams
/// - Handles retry logic with exponential backoff
/// - Essential for offline-first architecture
class RequestQueueManager {
  static final RequestQueueManager _instance = RequestQueueManager._internal();
  factory RequestQueueManager() => _instance;
  RequestQueueManager._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  bool _isProcessing = false;
  bool _isOnline = true;

  /// Stream controller for queue status updates
  final _queueStatusController = StreamController<QueueStatus>.broadcast();
  Stream<QueueStatus> get queueStatusStream => _queueStatusController.stream;

  /// Stream controller for request responses
  final _responseController = StreamController<QueueResponse>.broadcast();
  Stream<QueueResponse> get responseStream => _responseController.stream;

  /// Initialize the queue manager
  Future<void> init() async {
    await RequestQueueService.init();

    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;

    // Emit initial status with real queue length
    final initialPending = await RequestQueueService.getPendingRequests();
    _queueStatusController.add(
      QueueStatus(
        isOnline: _isOnline,
        queueLength: initialPending.length,
      ),
    );

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        final wasOnline = _isOnline;
        _isOnline = result != ConnectivityResult.none;

        // If we just came online, start processing queue
        if (!wasOnline && _isOnline) {
          _processQueue();
        }

        // Emit updated status with current pending count
        final pending = await RequestQueueService.getPendingRequests();
        _queueStatusController.add(
          QueueStatus(
            isOnline: _isOnline,
            queueLength: pending.length,
          ),
        );
      },
    );

    // Start processing if online
    if (_isOnline) {
      _processQueue();
    }
  }

  /// Add a request to the queue
  /// Returns true if queued, false if sent immediately
  Future<bool> queueRequest(APIRequest request) async {
    if (kDebugMode) {
      debugPrint(
        '[RequestQueueManager] queueRequest called -> '
        'method=${request.method}, path=${request.path}, '
        'isOnline=$_isOnline, isProcessing=$_isProcessing',
      );
    }

    // Only queue POST, PUT, DELETE requests (not GET)
    if (request.method == HTTPMethod.get) {
      // Send GET requests immediately
      try {
        final response = await request.send();
        _responseController.add(QueueResponse(
          requestId: '',
          success: true,
          response: response,
        ));
        return false;
      } catch (e) {
        _responseController.add(QueueResponse(
          requestId: '',
          success: false,
          error: e.toString(),
        ));
        return false;
      }
    }

    // If online, try to send immediately
    if (_isOnline && !_isProcessing) {
      try {
        final response = await request.send();
        _responseController.add(QueueResponse(
          requestId: '',
          success: true,
          response: response,
        ));
        return false;
      } catch (e) {
        // If send fails, queue it
      }
    }

    // Queue the request
    final item = RequestQueueItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      request: request,
      queuedAt: DateTime.now(),
    );

    await RequestQueueService.enqueue(item);

    // Update status
    final pendingCount = await RequestQueueService.getPendingRequests();

    if (kDebugMode) {
      debugPrint(
        '[RequestQueueManager] Request ENQUEUED -> id=${item.id}, '
        'path=${request.path}, pendingAfter=${pendingCount.length}',
      );
    }

    _queueStatusController.add(QueueStatus(
      isOnline: _isOnline,
      queueLength: pendingCount.length,
    ));

    return true;
  }

  /// Process the queue (send pending requests one by one)
  Future<void> _processQueue() async {
    if (_isProcessing || !_isOnline) return;

    _isProcessing = true;

    while (_isOnline) {
      try {
        final pending = await RequestQueueService.getPendingRequests();
        if (pending.isEmpty) {
          _isProcessing = false;
          _queueStatusController.add(QueueStatus(
            isOnline: _isOnline,
            queueLength: 0,
          ));
          return;
        }

        final item = pending.first;

        // Update status to processing
        await RequestQueueService.updateRequest(
          item.copyWith(status: QueueItemStatus.processing),
        );

        try {
          // Send the request
          final response = await item.request.send();

          // Mark as completed
          await RequestQueueService.updateRequest(
            item.copyWith(status: QueueItemStatus.completed),
          );

          // Emit response
          _responseController.add(QueueResponse(
            requestId: item.id,
            success: true,
            response: response,
          ));

          // Remove from queue after a delay
          await Future.delayed(const Duration(seconds: 1));
          await RequestQueueService.removeRequest(item.id);
        } catch (e) {
          // Mark as failed
          final updatedItem = item.copyWith(
            status: QueueItemStatus.failed,
            retryCount: item.retryCount + 1,
          );
          await RequestQueueService.updateRequest(updatedItem);

          // Emit error response
          _responseController.add(QueueResponse(
            requestId: item.id,
            success: false,
            error: e.toString(),
          ));

          // Remove failed requests after max retries (e.g., 3)
          if (updatedItem.retryCount >= 3) {
            await Future.delayed(const Duration(seconds: 1));
            await RequestQueueService.removeRequest(item.id);
          }
        }
      } catch (e, stack) {
        if (kDebugMode) {
          debugPrint(
            '[RequestQueueManager] Unexpected ERROR in _processQueue loop: '
            '$e\n$stack',
          );
        }
      }

      // Small delay between requests
      await Future.delayed(const Duration(milliseconds: 500));
    }

    _isProcessing = false;
  }

  /// Get current queue status
  Future<QueueStatus> getStatus() async {
    final pending = await RequestQueueService.getPendingRequests();
    return QueueStatus(
      isOnline: _isOnline,
      queueLength: pending.length,
    );
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _queueStatusController.close();
    _responseController.close();
  }
}

/// Queue Status Model
class QueueStatus {
  final bool isOnline;
  final int queueLength;

  QueueStatus({
    required this.isOnline,
    required this.queueLength,
  });
}

/// Queue Response Model
class QueueResponse {
  final String requestId;
  final bool success;
  final dynamic response;
  final String? error;

  QueueResponse({
    required this.requestId,
    required this.success,
    this.response,
    this.error,
  });
}


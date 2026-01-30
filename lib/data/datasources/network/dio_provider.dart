import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/utils/api_connection_error_handler.dart';
import '../../../core/utils/app_exception.dart';
import '../../repositories/auth_local_repository.dart';
import 'api_config.dart';
import 'api_request.dart';

/// Dio Provider
/// Singleton instance for making HTTP requests using Dio
/// 
/// Why this is valuable:
/// - Centralized HTTP client configuration
/// - Consistent error handling across the app
/// - Request/response logging in debug mode
/// - Handles all Dio exceptions and converts them to AppException
class DioProvider {
  static const requestTimeout = Duration(seconds: 10);
  final Dio _dio;

  static final DioProvider instance = DioProvider._internal();
  factory DioProvider() => instance;

  DioProvider._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: APIConfig.appAPI,
            connectTimeout: requestTimeout,
            receiveTimeout: requestTimeout,
          ),
        ) {
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print("REQUEST[${options.method}] => PATH: ${options.path}");
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              "RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}",
            );
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print(
              "ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}",
            );
          }
          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  Future<dynamic> request(
    APIRequest request, {
    CancelToken? cancelToken,
  }) async {
    try {
      dynamic data = request.body;

      if (data is Map<String, dynamic> &&
          data.values.any((element) => element is MultipartFile)) {
        data = FormData.fromMap(data);
      }

      final response = await _dio.request(
        request.fullUrl,
        data: data,
        cancelToken: cancelToken,
        options: Options(
          method: request.method.string.toUpperCase(),
          headers: request.headers,
        ),
        queryParameters: request.query,
      );

      return _handleResponse(response);
    } on DioException catch (e) {
      // When dynamic host is enabled, show Retry / Change IP dialog on connection error
      if (APIConfig.useDynamicApiHost &&
          (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.connectionError)) {
        final errorType = e.type == DioExceptionType.connectionTimeout
            ? ConnectionErrorType.timeout
            : ConnectionErrorType.connectionError;
        final result = await showConnectionErrorDialog(errorType);
        if (result is ConnectionErrorRetryWithNewHost) {
          await APIConfig.setHost(result.host);
        }
        if (result is ConnectionErrorRetry ||
            result is ConnectionErrorRetryWithNewHost) {
          return this.request(request, cancelToken: cancelToken);
        }
      }
      return _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  Future<dynamic> downloadFile(
    String fileUrl,
    String savePath, {
    Function(int, int)? onProgress,
    CancelToken? cancelToken,
    Map<String, String>? headers,
  }) async {
    try {
      // Get auth token if not provided in headers
      Map<String, String> downloadHeaders = headers ?? {};
      if (!downloadHeaders.containsKey('Authorization')) {
        final token = await AuthLocalRepository.retrieveToken();
        if (token.isNotEmpty) {
          downloadHeaders['Authorization'] = 'Bearer $token';
        }
      }
      
      Response response = await _dio.download(
        fileUrl,
        savePath,
        cancelToken: cancelToken,
        options: Options(
          headers: downloadHeaders,
        ),
        onReceiveProgress: (received, total) {
          if (onProgress != null) {
            onProgress(received, total);
          }
          if (total != -1) {
            if (kDebugMode) {
              print(
                "Progress: ${(received / total * 100).toStringAsFixed(0)}%",
              );
            }
          }
        },
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      throw Exception('Unexpected error occurred: $e');
    }
  }

  dynamic _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        throw AppException(
          statusCode: 499,
          errorCode: 'request-cancelled',
          message: "Request was cancelled by the user.",
        );

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw AppException(
          statusCode: 408,
          errorCode: 'timeout',
          message: "Request timed out. Please try again later.",
        );

      case DioExceptionType.connectionError:
        if (e.error is SocketException) {
          throw AppException(
            statusCode: 503,
            errorCode: 'no-internet',
            message: "No Internet connection. Please check your network.",
          );
        } else {
          throw AppException(
            statusCode: 500,
            errorCode: 'connection-error',
            message: "Connection error: ${e.error}",
          );
        }

      case DioExceptionType.badCertificate:
        throw AppException(
          statusCode: 495,
          errorCode: 'bad-certificate',
          message: "Bad certificate error occurred.",
        );

      case DioExceptionType.badResponse:
        if (e.response != null) {
          return _handleResponse(e.response!);
        } else {
          throw AppException(
            statusCode: 500,
            errorCode: 'bad-response',
            message: "Bad response error without response data.",
          );
        }

      case DioExceptionType.unknown:
        throw AppException(
          statusCode: 500,
          errorCode: 'unknown-error',
          message: "Unknown error occurred: ${e.message}",
        );
    }
  }

  dynamic _handleResponse(Response response) {
    final int statusCode = response.statusCode ?? 0;

    switch (statusCode) {
      case 200:
      case 201:
      case 202:
      case 204:
        return response;

      default:
        // Only parse error fields if response.data is a Map
        if (response.data is! Map<String, dynamic>) {
          throw AppException(
            statusCode: statusCode,
            errorCode: 'unknown-error',
            message: 'Unexpected response format',
          );
        }

        final data = response.data as Map<String, dynamic>;
        final errorCode = data['error_code'] ?? 'unknown-error';
        final errorMessage = data["message"] ?? 'An error occurred';
        final errors = data["errors"];

        // Parse errors if they exist
        Map<String, List<String>>? parsedErrors;
        if (errors != null && errors is Map) {
          parsedErrors = <String, List<String>>{};
          errors.forEach((key, value) {
            if (value is List) {
              parsedErrors![key.toString()] = value.cast<String>();
            } else if (value is String) {
              parsedErrors![key.toString()] = [value];
            }
          });
        }

        throw AppException(
          statusCode: statusCode,
          errorCode: errorCode,
          message: errorMessage,
          errors: parsedErrors,
          responseData: data, // Include full response data for special handling (e.g., 409 with booking_id)
        );
    }
  }
}


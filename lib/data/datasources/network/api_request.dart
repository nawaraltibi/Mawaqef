import 'package:dio/dio.dart';
import 'api_config.dart';
import 'dio_provider.dart';

/// Enum to specify the HTTP method used in a request.
enum HTTPMethod { get, post, delete, put, patch }

/// Enum to specify the type of body sent:
/// - [data] for sending regular data (default)
/// - [formData] for sending form data
enum BodyType { data, formData }

/// Enum to specify the type of request:
/// - [request] for regular requests (default)
/// - [download] for download requests
enum RequestType { request, download }

/// Enum to specify whether the request requires authorization:
/// - [authorized] means the request requires a token
/// - [unauthorized] means the request does not require authorization
enum AuthorizationOption { authorized, unauthorized }

/// Extension that converts HTTPMethod enum values to their corresponding string representations.
extension HTTPMethodString on HTTPMethod {
  String get string {
    switch (this) {
      case HTTPMethod.get:
        return "get";
      case HTTPMethod.post:
        return "post";
      case HTTPMethod.delete:
        return "delete";
      case HTTPMethod.patch:
        return "patch";
      case HTTPMethod.put:
        return "put";
    }
  }
}

/// APIRequest class that constructs and sends HTTP requests.
/// 
/// Why this is valuable:
/// - Clean, type-safe API request builder
/// - Handles authentication automatically
/// - Supports different request types (regular, download, form data)
/// - Serializable for queue system
class APIRequest {
  /// The base URL for the request (defaults to APIConfig.appAPI).
  String? baseUrl;

  /// Returns the full URL by concatenating the base URL and the endpoint path.
  String get fullUrl => (baseUrl ?? APIConfig.appAPI) + path;

  /// The endpoint path.
  String path;

  /// The HTTP method to be used.
  HTTPMethod method;

  /// Default headers for the request.
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Additional headers to be merged with the default headers.
  Map<String, String>? additionalHeaders;

  /// Query parameters for the request.
  Map<String, String>? query;

  /// The body of the request.
  dynamic body;

  /// The type of body to be sent (default is BodyType.data).
  BodyType bodyType;

  /// The type of request (default is RequestType.request).
  RequestType requestType;

  /// Option to indicate if the request requires authorization.
  AuthorizationOption authorizationOption;

  /// The file URL for download requests.
  String? fileUrl;

  /// The save path for the downloaded file.
  String? savePath;

  /// Token getter - should be implemented to retrieve auth token
  /// Override this in your implementation to provide actual token retrieval
  Future<String> get token async {
    // TODO: Implement token retrieval from your auth service
    // Example: return await AuthService.getToken();
    return "";
  }

  /// Whether to send app version in query parameters
  bool isSendingVersion;

  /// Whether to send platform in query parameters
  bool isSendingPlatform;

  APIRequest({
    required this.path,
    required this.method,
    this.baseUrl,
    this.additionalHeaders,
    this.query,
    this.body,
    this.bodyType = BodyType.data,
    this.requestType = RequestType.request,
    this.authorizationOption = AuthorizationOption.authorized,
    this.fileUrl,
    this.isSendingVersion = false,
    this.isSendingPlatform = false,
    this.savePath,
  }) {
    // Merge additional headers if provided.
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders!);
    }

    // Convert body to FormData if required.
    switch (bodyType) {
      case BodyType.formData:
        body = FormData.fromMap(body);
        break;
      case BodyType.data:
        break;
    }

    // Ensure query parameters are initialized.
    query ??= {};

    // Validate fileUrl and savePath if the request type is a download.
    switch (requestType) {
      case RequestType.download:
        assert(fileUrl != null && fileUrl!.isNotEmpty,
            "File URL must be provided for download requests");
        assert(savePath != null && savePath!.isNotEmpty,
            "Save path must be provided for download requests");
        break;
      case RequestType.request:
        break;
    }
  }

  /// Sends the HTTP request using DioProvider.
  Future<dynamic> send({CancelToken? cancelToken}) async {
    // Add token to headers if authorization is required
    if (authorizationOption == AuthorizationOption.authorized) {
      final tokenValue = await token;
      if (tokenValue.isNotEmpty) {
        headers['Authorization'] = "Bearer $tokenValue";
      }
    }

    // If the request type is download, handle the response differently.
    if (requestType == RequestType.request) {
      return DioProvider.instance.request(
        this,
        cancelToken: cancelToken,
      );
    } else if (requestType == RequestType.download) {
      return DioProvider.instance.downloadFile(
        fileUrl!,
        savePath!,
        cancelToken: cancelToken,
      );
    } else {
      throw Exception("Invalid request type");
    }
  }

  /// Convert APIRequest to JSON for queue storage
  Map<String, dynamic> toJson() {
    return {
      'baseUrl': baseUrl,
      'path': path,
      'method': method.string,
      'headers': headers,
      'additionalHeaders': additionalHeaders,
      'query': query,
      'body': body,
      'bodyType': bodyType.name,
      'requestType': requestType.name,
      'authorizationOption': authorizationOption.name,
      'fileUrl': fileUrl,
      'savePath': savePath,
      'isSendingVersion': isSendingVersion,
      'isSendingPlatform': isSendingPlatform,
    };
  }

  /// Create APIRequest from JSON
  factory APIRequest.fromJson(Map<String, dynamic> json) {
    return APIRequest(
      path: json['path'] as String,
      method: HTTPMethod.values.firstWhere(
        (e) => e.string == json['method'],
        orElse: () => HTTPMethod.get,
      ),
      baseUrl: json['baseUrl'] as String?,
      additionalHeaders: json['additionalHeaders'] != null
          ? Map<String, String>.from(json['additionalHeaders'] as Map)
          : null,
      query: json['query'] != null
          ? Map<String, String>.from(json['query'] as Map)
          : null,
      body: json['body'],
      bodyType: BodyType.values.firstWhere(
        (e) => e.name == json['bodyType'],
        orElse: () => BodyType.data,
      ),
      requestType: RequestType.values.firstWhere(
        (e) => e.name == json['requestType'],
        orElse: () => RequestType.request,
      ),
      authorizationOption: AuthorizationOption.values.firstWhere(
        (e) => e.name == json['authorizationOption'],
        orElse: () => AuthorizationOption.authorized,
      ),
      fileUrl: json['fileUrl'] as String?,
      savePath: json['savePath'] as String?,
      isSendingVersion: json['isSendingVersion'] as bool? ?? false,
      isSendingPlatform: json['isSendingPlatform'] as bool? ?? false,
    );
  }
}


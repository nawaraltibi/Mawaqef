import 'package:dio/dio.dart';
import '../../../data/datasources/network/dio_provider.dart';

/// File Downloader Repository
/// Handles file download operations
/// 
/// Why this is valuable:
/// - Centralized file download logic
/// - Progress tracking support
/// - Cancellation support
class FileDownloaderRepository {
  const FileDownloaderRepository._();

  /// Download file from URL
  static Future<void> downloadFile(
    String url,
    String savePath, {
    Function(int received, int total)? onProgress,
    CancelToken? cancelToken,
  }) async {
    await DioProvider.instance.downloadFile(
      url,
      savePath,
      cancelToken: cancelToken,
      onProgress: onProgress,
    );
  }
}


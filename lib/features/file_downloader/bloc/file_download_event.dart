import 'package:equatable/equatable.dart';

/// File Download Event
/// Base class for all file download events
abstract class FileDownloadEvent extends Equatable {
  const FileDownloadEvent();

  @override
  List<Object?> get props => [];
}

/// File Download Started Event
class FileDownloadStarted extends FileDownloadEvent {
  final String url;
  final String savePath;

  const FileDownloadStarted({
    required this.url,
    required this.savePath,
  });

  @override
  List<Object?> get props => [url, savePath];
}

/// File Download Cancelled Event
class FileDownloadCancelled extends FileDownloadEvent {
  const FileDownloadCancelled();
}


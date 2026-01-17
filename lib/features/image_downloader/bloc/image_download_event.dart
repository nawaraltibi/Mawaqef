import 'package:equatable/equatable.dart';

/// Image Download Event
/// Base class for all image download events
abstract class ImageDownloadEvent extends Equatable {
  const ImageDownloadEvent();

  @override
  List<Object?> get props => [];
}

/// Image Download Started Event
class ImageDownloadStarted extends ImageDownloadEvent {
  final String url;
  final String savePath;

  const ImageDownloadStarted({
    required this.url,
    required this.savePath,
  });

  @override
  List<Object?> get props => [url, savePath];
}

/// Image Download Cancelled Event
class ImageDownloadCancelled extends ImageDownloadEvent {
  const ImageDownloadCancelled();
}


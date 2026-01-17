import 'package:equatable/equatable.dart';

/// Image Download State
/// Base class for all image download states
abstract class ImageDownloadState extends Equatable {
  const ImageDownloadState();

  @override
  List<Object?> get props => [];
}

/// Image Download Initial State
class ImageDownloadInitial extends ImageDownloadState {
  const ImageDownloadInitial();

  @override
  List<Object?> get props => [];
}

/// Image Download Loading State
class ImageDownloadLoading extends ImageDownloadState {
  const ImageDownloadLoading();

  @override
  List<Object?> get props => [];
}

/// Image Download Progress State
class ImageDownloadProgress extends ImageDownloadState {
  final int received;
  final int total;

  const ImageDownloadProgress({
    required this.received,
    required this.total,
  });

  @override
  List<Object?> get props => [received, total];

  double get progress => total > 0 ? received / total : 0.0;
}

/// Image Download Success State
class ImageDownloadSuccess extends ImageDownloadState {
  final String path;

  const ImageDownloadSuccess({required this.path});

  @override
  List<Object?> get props => [path];
}

/// Image Download Error State
class ImageDownloadError extends ImageDownloadState {
  final String message;

  const ImageDownloadError({required this.message});

  @override
  List<Object?> get props => [message];
}


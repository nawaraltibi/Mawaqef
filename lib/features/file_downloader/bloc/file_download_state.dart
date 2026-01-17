import 'package:equatable/equatable.dart';

/// File Download State
/// Base class for all file download states
abstract class FileDownloadState extends Equatable {
  const FileDownloadState();

  @override
  List<Object?> get props => [];
}

/// File Download Initial State
class FileDownloadInitial extends FileDownloadState {
  const FileDownloadInitial();

  @override
  List<Object?> get props => [];
}

/// File Download Loading State
class FileDownloadLoading extends FileDownloadState {
  const FileDownloadLoading();

  @override
  List<Object?> get props => [];
}

/// File Download Progress State
class FileDownloadProgress extends FileDownloadState {
  final int received;
  final int total;

  const FileDownloadProgress({
    required this.received,
    required this.total,
  });

  @override
  List<Object?> get props => [received, total];

  double get progress => total > 0 ? received / total : 0.0;
}

/// File Download Success State
class FileDownloadSuccess extends FileDownloadState {
  final String path;

  const FileDownloadSuccess({required this.path});

  @override
  List<Object?> get props => [path];
}

/// File Download Error State
class FileDownloadError extends FileDownloadState {
  final String message;

  const FileDownloadError({required this.message});

  @override
  List<Object?> get props => [message];
}


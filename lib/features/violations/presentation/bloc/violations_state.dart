part of 'violations_bloc.dart';

/// Base class for violations states
abstract class ViolationsState {}

/// Initial state
class ViolationsInitial extends ViolationsState {
  ViolationsInitial();
}

/// Loading state - violations operation in progress
class ViolationsLoading extends ViolationsState {
  ViolationsLoading();
}

/// Loaded state - unpaid violations loaded successfully
class UnpaidViolationsLoaded extends ViolationsState {
  final List<ViolationEntity> violations;

  UnpaidViolationsLoaded({required this.violations});
}

/// Loaded state - paid violations loaded successfully
class PaidViolationsLoaded extends ViolationsState {
  final List<ViolationEntity> violations;

  PaidViolationsLoaded({required this.violations});
}

/// Empty state - no violations found
class ViolationsEmpty extends ViolationsState {
  ViolationsEmpty();
}

/// Error state - violations operation failed
class ViolationsError extends ViolationsState {
  final String error;
  final int statusCode;

  ViolationsError({
    required this.error,
    required this.statusCode,
  });
}

/// Loading state for violation actions (pay violation)
class ViolationActionLoading extends ViolationsState {
  ViolationActionLoading();
}

/// Success state for violation actions
class ViolationActionSuccess extends ViolationsState {
  final String message;
  final ViolationEntity? violation;

  ViolationActionSuccess({
    required this.message,
    this.violation,
  });
}

/// Failure state for violation actions
class ViolationActionFailure extends ViolationsState {
  final String error;
  final int statusCode;

  ViolationActionFailure({
    required this.error,
    required this.statusCode,
  });
}


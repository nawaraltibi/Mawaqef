part of 'violations_bloc.dart';

/// Base class for violations events
abstract class ViolationsEvent {}

/// Event to get unpaid violations for the authenticated user
class GetUnpaidViolationsRequested extends ViolationsEvent {
  GetUnpaidViolationsRequested();
}

/// Event to get paid violations for the authenticated user
class GetPaidViolationsRequested extends ViolationsEvent {
  GetPaidViolationsRequested();
}

/// Event to pay a violation
class PayViolationRequested extends ViolationsEvent {
  final int violationId;
  final String paymentMethod;

  PayViolationRequested({
    required this.violationId,
    required this.paymentMethod,
  });
}

/// Event to reset violations state
class ResetViolationsState extends ViolationsEvent {
  ResetViolationsState();
}


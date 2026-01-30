import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/async_runner.dart';
import '../../domain/entities/violation_entity.dart';
import '../../domain/usecases/get_unpaid_violations.dart';
import '../../domain/usecases/get_paid_violations.dart';
import '../../domain/usecases/pay_violation.dart';
import 'mixins/violations_error_handler_mixin.dart';

part 'violations_event.dart';
part 'violations_state.dart';

/// Violations Bloc
/// Manages violations state and business logic using Bloc pattern with AsyncRunner
class ViolationsBloc extends Bloc<ViolationsEvent, ViolationsState>
    with ViolationsErrorHandlerMixin {
  final GetUnpaidViolationsUseCase getUnpaidViolationsUseCase;
  final GetPaidViolationsUseCase getPaidViolationsUseCase;
  final PayViolationUseCase payViolationUseCase;

  final AsyncRunner<List<ViolationEntity>> getUnpaidViolationsRunner =
      AsyncRunner<List<ViolationEntity>>();
  final AsyncRunner<List<ViolationEntity>> getPaidViolationsRunner =
      AsyncRunner<List<ViolationEntity>>();
  final AsyncRunner<ViolationEntity> payViolationRunner =
      AsyncRunner<ViolationEntity>();

  ViolationsBloc({
    required this.getUnpaidViolationsUseCase,
    required this.getPaidViolationsUseCase,
    required this.payViolationUseCase,
  }) : super(ViolationsInitial()) {
    on<GetUnpaidViolationsRequested>(_onGetUnpaidViolationsRequested);
    on<GetPaidViolationsRequested>(_onGetPaidViolationsRequested);
    on<PayViolationRequested>(_onPayViolationRequested);
    on<ResetViolationsState>(_onResetViolationsState);
  }

  /// Get unpaid violations for the authenticated user
  Future<void> _onGetUnpaidViolationsRequested(
    GetUnpaidViolationsRequested event,
    Emitter<ViolationsState> emit,
  ) async {
    emit(ViolationsLoading());

    await getUnpaidViolationsRunner.run(
      onlineTask: (previousResult) async {
        return await getUnpaidViolationsUseCase();
      },
      onSuccess: (violations) async {
        if (!emit.isDone) {
          if (violations.isEmpty) {
            emit(ViolationsEmpty());
          } else {
            emit(UnpaidViolationsLoaded(violations: violations));
          }
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleError(error, emit);
        }
      },
    );
  }

  /// Get paid violations for the authenticated user
  Future<void> _onGetPaidViolationsRequested(
    GetPaidViolationsRequested event,
    Emitter<ViolationsState> emit,
  ) async {
    emit(ViolationsLoading());

    await getPaidViolationsRunner.run(
      onlineTask: (previousResult) async {
        return await getPaidViolationsUseCase();
      },
      onSuccess: (violations) async {
        if (!emit.isDone) {
          if (violations.isEmpty) {
            emit(ViolationsEmpty());
          } else {
            emit(PaidViolationsLoaded(violations: violations));
          }
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleError(error, emit);
        }
      },
    );
  }

  /// Pay a violation
  Future<void> _onPayViolationRequested(
    PayViolationRequested event,
    Emitter<ViolationsState> emit,
  ) async {
    emit(ViolationActionLoading());

    await payViolationRunner.run(
      onlineTask: (previousResult) async {
        return await payViolationUseCase(
          violationId: event.violationId,
          paymentMethod: event.paymentMethod,
        );
      },
      onSuccess: (violation) async {
        if (!emit.isDone) {
          emit(ViolationActionSuccess(
            message: 'Violation paid successfully',
            violation: violation,
          ));
          // Reload unpaid violations after successful payment
          add(GetUnpaidViolationsRequested());
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          handleViolationActionError(error, emit);
        }
      },
    );
  }

  /// Reset violations state
  void _onResetViolationsState(
    ResetViolationsState event,
    Emitter<ViolationsState> emit,
  ) {
    if (state is UnpaidViolationsLoaded) {
      emit(UnpaidViolationsLoaded(
        violations: (state as UnpaidViolationsLoaded).violations,
      ));
    } else if (state is PaidViolationsLoaded) {
      emit(PaidViolationsLoaded(
        violations: (state as PaidViolationsLoaded).violations,
      ));
    } else {
      emit(ViolationsInitial());
    }
  }
}


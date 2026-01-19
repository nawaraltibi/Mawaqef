import 'package:flutter_bloc/flutter_bloc.dart';

part 'owner_main_event.dart';
part 'owner_main_state.dart';

/// Owner Main Bloc
/// Manages tab navigation for owner main screen
class OwnerMainBloc extends Bloc<OwnerMainEvent, OwnerMainState> {
  OwnerMainBloc() : super(OwnerMainInitial(selectedIndex: 0)) {
    on<ChangeOwnerTab>(_onChangeTab);
  }

  void _onChangeTab(
    ChangeOwnerTab event,
    Emitter<OwnerMainState> emit,
  ) {
    final current = state is OwnerMainInitial
        ? (state as OwnerMainInitial).selectedIndex
        : 0;
    
    // Skip emit if the requested tab is already selected
    if (current == event.index) return;

    emit(OwnerMainInitial(selectedIndex: event.index));
  }
}


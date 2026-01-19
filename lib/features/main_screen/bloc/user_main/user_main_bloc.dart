import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_main_event.dart';
part 'user_main_state.dart';

/// User Main Bloc
/// Manages tab navigation for user main screen
class UserMainBloc extends Bloc<UserMainEvent, UserMainState> {
  UserMainBloc() : super(UserMainInitial(selectedIndex: 0)) {
    on<ChangeUserTab>(_onChangeTab);
  }

  void _onChangeTab(
    ChangeUserTab event,
    Emitter<UserMainState> emit,
  ) {
    final current = state is UserMainInitial
        ? (state as UserMainInitial).selectedIndex
        : 0;
    
    // Skip emit if the requested tab is already selected
    if (current == event.index) return;

    emit(UserMainInitial(selectedIndex: event.index));
  }
}


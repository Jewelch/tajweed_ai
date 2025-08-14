part of '../bloc/shift_handover_bloc.dart';

//- ACCESS HOME
extension on ShiftHandoverBloc {
  void _accessHome(AccessHome event, Emitter<ShiftHandoverState> emit) async {
    Debugger.white('$ShiftHandoverBloc is accessing home');

    accessingHomeObs.enable();

    await Future.delayed(const Duration(seconds: 1));

    accessingHomeObs.disable();
  }
}

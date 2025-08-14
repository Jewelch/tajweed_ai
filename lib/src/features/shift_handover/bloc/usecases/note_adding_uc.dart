part of '../bloc/shift_handover_bloc.dart';

//- ADD NOTE
extension on ShiftHandoverBloc {
  void _addNote(AddShiftNote event, Emitter<ShiftHandoverState> emit) async {
    isLoadingObs.enable();

    await Future.delayed(const Duration(seconds: 1));

    isLoadingObs.disable();
  }
}

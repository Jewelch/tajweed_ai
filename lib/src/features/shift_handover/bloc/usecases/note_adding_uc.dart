part of '../shift_handover_bloc.dart';

//- ADD NOTE
extension AddNoteExt on ShiftHandoverBloc {
  void addNote() async {
    isLoadingObs.enable();

    await Future.delayed(const Duration(seconds: 1));

    isLoadingObs.disable();
  }
}

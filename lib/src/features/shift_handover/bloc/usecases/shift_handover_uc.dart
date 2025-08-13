part of '../shift_handover_bloc.dart';

//- GET SHIFT REPORT
extension on ShiftHandoverBloc {
  void _loadShiftReport(GetShiftReport event, Emitter<ShiftHandoverState> emit) async {
    emit(Loading());

    await shiftHandoverDataSource
        .getShiftReport('current-user-id')
        .then(
          (result) => result.fold(
            (exception) => _handleShiftHandoverFailure(exception, emit),
            (ShiftReportDATO shiftReport) => _handleLoadShiftReport(shiftReport, emit),
          ),
        );
  }

  void _handleShiftHandoverFailure(Exception exception, Emitter<ShiftHandoverState> emit) {
    ScaffoldMessenger.of(globalContext).showSnackBar(FailureSnackbar(exception: exception));
    emit(Error.from(exception));
  }

  void _handleLoadShiftReport(ShiftReportDATO? shiftReport, Emitter<ShiftHandoverState> emit) =>
      (shiftReport == null) ? emit(Empty()) : emit(Success(shiftReport: shiftReport));
}

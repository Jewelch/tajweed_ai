import 'package:equatable/equatable.dart';

import '../../data/models/shift_report_model.dart';

sealed class ShiftHandoverState extends Equatable {
  @override
  List<Object> get props => [];
}

final class Loading extends ShiftHandoverState {}

final class Empty extends ShiftHandoverState {}

final class Success extends ShiftHandoverState {
  final ShiftReportDATO shiftReport;

  Success({required this.shiftReport});

  @override
  List<Object> get props => [shiftReport];
}

final class Error extends ShiftHandoverState implements Exception {
  final String message;

  Error({Exception? exception}) : message = exception?.toString() ?? '';

  factory Error.from(Exception exception) => Error(exception: exception);

  @override
  List<Object> get props => [message];
}

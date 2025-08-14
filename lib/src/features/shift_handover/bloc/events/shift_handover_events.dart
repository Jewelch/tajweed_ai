import 'package:equatable/equatable.dart';

sealed class ShiftHandoverEvent extends Equatable {
  const ShiftHandoverEvent();

  @override
  List<Object> get props => [];
}

//- GET SHIFT REPORT
final class GetShiftReport extends ShiftHandoverEvent {
  final String caregiverId;

  const GetShiftReport(this.caregiverId);

  @override
  List<Object> get props => [caregiverId];
}

//- ANOTHER EVENTS
final class GetAnotherEvent extends ShiftHandoverEvent {
  const GetAnotherEvent();

  @override
  List<Object> get props => [];
}

//- ADD NOTE
final class AddShiftNote extends ShiftHandoverEvent {
  const AddShiftNote();
}

//- ACCESS HOME
final class AccessHome extends ShiftHandoverEvent {
  const AccessHome();
}

import 'package:tajweed_ai/src/base/screens/exports.dart';

import '../../../../base/bloc/exports.dart';
import '../../data/datasource/shift_handover_datasource_impl.dart';
import '../../data/models/shift_report_do.dart';
import '../events/shift_handover_events.dart';
import '../states/shift_handover_states.dart';

//$ USE CASES
part '../usecases/access_home_uc.dart';
part '../usecases/another_uc.dart';
part '../usecases/note_adding_uc.dart';
part '../usecases/shift_handover_uc.dart';

class ShiftHandoverBloc extends BaseBloc<ShiftHandoverEvent, ShiftHandoverState> {
  final ShiftHandoverDataSource shiftHandoverDataSource;

  ShiftHandoverBloc(this.shiftHandoverDataSource) : super(Loading(), debugginEnabled: true) {
    on<GetShiftReport>(_loadShiftReport);
    on<AddShiftNote>(_addNote);
    on<AccessHome>(_accessHome);
  }

  //? OBERVABLES
  final isLoadingObs = Observable<bool>(false);

  //& LIFECYCLE
  @override
  void onReady() {
    add(GetShiftReport('current-user-id'));
    super.onReady();
  }
}

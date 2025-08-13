import '../../../../base/screens/exports.dart';
import '../../bloc/states/shift_handover_states.dart';

class SuccessSnackbar extends SnackBar {
  final Success state;

  SuccessSnackbar(this.state, {super.key})
    : super(
        content: Text("successfully loaded ${state.shiftReport.notes.length} notes"),
        backgroundColor: Theme.of(globalContext).colorScheme.primary,
      );
}

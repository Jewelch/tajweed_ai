import '../../../../base/screens/exports.dart';
import '../../manager/bloc/shift_handover_bloc.dart';
import '../../manager/events/shift_handover_events.dart';

class FailureSnackbar extends CommonSnackbar {
  FailureSnackbar({required BuildContext context, required super.message})
    : super(
        type: SnackbarType.error,
        actionTitle: 'Retry',
        onActionPressed: () => context.read<ShiftHandoverBloc>().add(GetShiftReport("3")),
      );
}

import '../../../../base/screens/exports.dart';
import '../../bloc/events/shift_handover_events.dart';
import '../../bloc/shift_handover_bloc.dart';
import '../../bloc/states/shift_handover_states.dart';

final class ShiftHandoverAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShiftHandoverAppBar({super.key});

  @override
  Widget build(BuildContext context) => AppBar(
    title: Text('Shift Handover Report'),
    actions: [
      BlocBuilder<ShiftHandoverBloc, ShiftHandoverState>(
        builder: (context, state) => (state is Loading)
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(Icons.refresh, color: AppColors.scaffold),
                tooltip: 'Refresh Report',
                onPressed: () =>
                    context.read<ShiftHandoverBloc>().add(GetShiftReport('current-user-id')),
              ),
      ),
    ],
  );

  @override
  Size get preferredSize => Size.fromHeight(AppMetrics.topBar.height);
}

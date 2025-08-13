import '../../../../base/screens/exports.dart';
import '../../binding/shift_handover_deps.dart';
import '../../bloc/shift_handover_bloc.dart';
import '../../bloc/states/shift_handover_states.dart';
import '../snackbars/success_snackbar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/report_view_widget.dart';
import '../widgets/shift_handover_app_bar.dart';

final class ShiftHandoverScreen extends BlocProviderWidget<ShiftHandoverBloc> {
  static final path = "/shift-handover";

  ShiftHandoverScreen({super.key})
    : super(
        dependencies: ShiftHandoverDependencies(),
        listenWhen: (previous, current) => current is Success,
        onUpdate: (context, state) =>
            ScaffoldMessenger.of(context).showSnackBar(SuccessSnackbar(state)),
        fullRebuildWhen: (_, currentStete) {
          Debugger.magenta('ShiftHandoverScreen $currentStete');
          return false;
        },
      );

  @override
  Widget build(BuildContext context) {
    Debugger.white('ShiftHandoverScreen rebuilt');

    return Scaffold(
      appBar: const ShiftHandoverAppBar(),
      body: BlocBuilder<ShiftHandoverBloc, ShiftHandoverState>(
        builder: (context, state) => switch (state) {
          Loading() => const LoadingWidget(),
          Error() => ShiftHandoverErrorWidget("state.message"),
          Empty() => const ShiftHandoverEmptyWidget(),
          Success() => ReportViewWidget(state.shiftReport),
        },
      ),
    );
  }
}

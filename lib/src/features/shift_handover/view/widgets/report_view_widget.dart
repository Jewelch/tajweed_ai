import '../../../../base/dependencies/dependencies.dart';
import '../../../../base/screens/exports.dart';
import '../../data/models/shift_report_do.dart';
import '../../vm/bloc/shift_handover_bloc.dart';
import '../../vm/events/shift_handover_events.dart';
import '../../vm/usecases/note_adding_uc/note_adding_bloc.dart';
import 'note_card.dart';

final class ReportViewWidget extends StatelessWidget {
  const ReportViewWidget(this.report, {super.key});

  final ShiftReportDO report;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      (report.notes.isEmpty)
          ? Text(
              'No notes added yet.\nUse the form below to add the first note.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ).center().expanded()
          : Column(
              children: [
                ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: report.notes.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      NoteCard(key: ValueKey(report.notes[index].id), note: report.notes[index]),
                ).expanded(),

                Observer(
                  observes: context.read<ShiftHandoverBloc>().isLoadingObs,
                  builder: (context, isLoading) => LoadingButton(
                    isLoading: isLoading,
                    title: 'Add Note',
                    titleFontSize: AppStyles.title.fontSize,
                    onTap: () => context.read<ShiftHandoverBloc>().add(const AddShiftNote()),
                  ).customPadding(bottom: 40),
                ),

                _NoteAddingButton(),

                LoadingButton(
                  isLoading: false,
                  title: 'Access Home',
                  titleFontSize: AppStyles.title.fontSize,
                  onTap: () => context.read<ShiftHandoverBloc>().add(const AccessHome()),
                ).customPadding(bottom: 40),
              ],
            ).expanded(),
    ],
  ).symmetricPadding(horizontal: AppMetrics.scaffold.horizontalBodyPadding);
}

class NoteAddingDependencies implements Dependencies {
  @override
  void inject() {
    di.registerFactory(() => NoteAddingBloc());
  }
}

class _NoteAddingButton extends Feature<NoteAddingBloc> {
  _NoteAddingButton() : super(dependencies: NoteAddingDependencies());

  @override
  Widget build(BuildContext context) => BlocBuilder<NoteAddingBloc, NoteAddingState>(
    builder: (context, state) => LoadingButton(
      isLoading: state is Loading,
      title: 'Add Note',
      titleFontSize: AppStyles.title.fontSize,
      onTap: () => context.read<NoteAddingBloc>().add(const AddNote()),
    ).customPadding(bottom: 40),
  );
}

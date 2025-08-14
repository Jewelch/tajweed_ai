//= Note ADDING USE CASE

import '../../../../../../base/screens/exports.dart';
import '../vm/bloc/note_adding_bloc.dart';

class NoteAddingUC extends SubFeature<NoteAddingBloc> {
  NoteAddingUC() : super(dependencies: () => di.registerFactory(() => NoteAddingBloc()));

  @override
  Widget build(BuildContext context) => BlocBuilder<NoteAddingBloc, NoteAddingState>(
    builder: (context, state) => LoadingButton(
      isLoading: state is Loading,
      title: 'Add Note',
      titleFontSize: AppStyles.title.fontSize,
      onTap: () => bloc.add(const AddNote()),
    ),
  );
}

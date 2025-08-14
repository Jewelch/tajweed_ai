//= Note ADDING USE CASE

import '../../../../../../base/screens/exports.dart';
import '../vm/bloc/note_adding_bloc.dart';

class NoteAddingUC extends SubFeature<NoteAddingBloc, NoteAddingState> {
  NoteAddingUC() : super(dependencies: () => di.registerInstance(NoteAddingBloc()));

  @override
  Widget build(BuildContext context, NoteAddingState state) => LoadingButton(
    isLoading: state is Loading,
    title: 'Add Note',
    titleFontSize: AppStyles.title.fontSize,
    onTap: () => bloc.add(const AddNote()),
  );
}

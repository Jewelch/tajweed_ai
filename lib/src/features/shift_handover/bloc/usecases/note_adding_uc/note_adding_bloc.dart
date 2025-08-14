import 'package:equatable/equatable.dart';

import '../../../../../base/bloc/exports.dart';

class NoteAddingBloc extends BaseBloc<NoteAddingEvent, NoteAddingState> {
  NoteAddingBloc() : super(Idle(), debugginEnabled: true) {
    on<AddNote>(_addNote);
  }

  //? OBERVABLES

  void _addNote(AddNote event, Emitter<NoteAddingState> emit) async {
    emit(Loading());

    await Future.delayed(const Duration(seconds: 1));

    emit(NoteAdded());
  }
}

//$ EVENTS

sealed class NoteAddingEvent with EquatableMixin {
  const NoteAddingEvent();

  @override
  List<Object?> get props => [];
}

class AddNote extends NoteAddingEvent {
  const AddNote();
}

//$ STATES

sealed class NoteAddingState with EquatableMixin {
  const NoteAddingState();

  @override
  List<Object?> get props => [];
}

class Idle extends NoteAddingState {
  const Idle();
}

class Loading extends NoteAddingState {
  const Loading();
}

class NoteAdded extends NoteAddingState {
  const NoteAdded();
}

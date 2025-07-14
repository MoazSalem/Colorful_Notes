import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/domain/usecases/add_note.dart';
import 'package:colorful_notes/features/notes/domain/usecases/delete_note.dart';
import 'package:colorful_notes/features/notes/domain/usecases/get_notes.dart';
import 'package:colorful_notes/features/notes/domain/usecases/update_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notes_provider.dart';

class NotesNotifier extends AsyncNotifier<List<Note>> {
  late final GetNotesUseCase _getNotes;
  late final AddNoteUseCase _addNote;
  late final UpdateNoteUseCase _updateNote;
  late final DeleteNoteUseCase _deleteNote;

  @override
  Future<List<Note>> build() async {
    _getNotes = ref.read(getNotesUseCaseProvider);
    _addNote = ref.read(addNoteUseCaseProvider);
    _updateNote = ref.read(updateNoteUseCaseProvider);
    _deleteNote = ref.read(deleteNoteUseCaseProvider);

    return _getNotes();
  }

  Future<void> add(Note note) async {
    await _addNote(note);
    state = await AsyncValue.guard(() => _getNotes());
  }

  Future<void> updateNote(Note note) async {
    await _updateNote(note);
    state = await AsyncValue.guard(() => _getNotes());
  }

  Future<void> delete(String id) async {
    await _deleteNote(id);
    state = await AsyncValue.guard(() => _getNotes());
  }
}

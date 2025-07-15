import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/domain/usecases/add_note.dart';
import 'package:colorful_notes/features/notes/domain/usecases/delete_note.dart';
import 'package:colorful_notes/features/notes/domain/usecases/get_notes.dart';
import 'package:colorful_notes/features/notes/domain/usecases/get_notes_of_type.dart';
import 'package:colorful_notes/features/notes/domain/usecases/update_note.dart';
import 'package:colorful_notes/features/notes/ui/providers/notes_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesNotifier extends AsyncNotifier<List<Note>> {
  late final GetNotesUseCase _getNotes = ref.read(getNotesUseCaseProvider);
  late final AddNoteUseCase _addNote = ref.read(addNoteUseCaseProvider);
  late final UpdateNoteUseCase _updateNote = ref.read(
    updateNoteUseCaseProvider,
  );
  late final DeleteNoteUseCase _deleteNote = ref.read(
    deleteNoteUseCaseProvider,
  );
  late final GetNotesOfTypeUseCase _getNotesOfType = ref.read(
    getNotesOfTypeUseCaseProvider,
  );

  @override
  Future<List<Note>> build() async {
    return [];
  }

  Future<void> getNotes() async {
    state = await AsyncValue.guard(() => _getNotes());
  }

  Future<void> getNotesOfType(bool voice) async {
    state = await AsyncValue.guard(() => _getNotesOfType(voice));
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

import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/services/homescreen_widgets_service.dart';
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
  bool updatedWidgetsNotes = false;

  @override
  Future<List<Note>> build() async {
    return [];
  }

  Future<void> getNotes(bool? voice) async {
    state = await AsyncValue.guard(
      () => voice == null ? _getNotes() : _getNotesOfType(voice),
    );
    if (!updatedWidgetsNotes) {
      HomescreenWidgetsService.update(
        notes: state.value!,
        color: AppConsts.lightColors,
      );
      updatedWidgetsNotes = true;
    }
  }

  Future<void> searchNote(String query, int type) async {
    if (type == 0) {
      state = await AsyncValue.guard(() => _getNotes());
    } else {
      state = await AsyncValue.guard(() => _getNotesOfType(type == 2));
    }
    final List<Note> notes = state.value!;
    state = await AsyncValue.guard(
      () async => notes
          .where(
            (element) => element.type == 1
                ? element.title.toLowerCase().contains(query.toLowerCase())
                : element.title.toLowerCase().contains(query.toLowerCase()) ||
                      element.content.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
          )
          .toList(),
    );
  }

  Future<void> add(Note note) async {
    await _addNote(note);
    updatedWidgetsNotes = false;
    state = await AsyncValue.guard(() => _getNotes());
  }

  Future<void> updateNote(Note note) async {
    await _updateNote(note);
    updatedWidgetsNotes = false;
    state = await AsyncValue.guard(() => _getNotes());
  }

  Future<void> delete(String id) async {
    await _deleteNote(id);
    updatedWidgetsNotes = false;
    state = await AsyncValue.guard(() => _getNotes());
  }
}

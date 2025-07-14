import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/domain/repositories/note_repository.dart';

class AddNoteUseCase {
  final NoteRepository repository;
  AddNoteUseCase(this.repository);

  Future<void> call(Note note) async => await repository.addNote(note);
}

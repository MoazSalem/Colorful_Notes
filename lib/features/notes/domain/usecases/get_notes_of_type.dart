import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/domain/repositories/note_repository.dart';

class GetNotesOfTypeUseCase {
  final NoteRepository repository;
  GetNotesOfTypeUseCase(this.repository);

  Future<List<Note>> call(bool voice) async =>
      await repository.getNotesOfType(voice);
}

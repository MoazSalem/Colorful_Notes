import 'package:colorful_notes/features/notes/data/datasources/notes_database.dart';
import 'package:colorful_notes/features/notes/data/models/note_model.dart';
import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NotesDatabase database;
  NoteRepositoryImpl(this.database);

  @override
  Future<List<Note>> getNotes() async {
    final models = await database.getAllNotes();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addNote(Note note) async {
    final model = NoteModel.fromEntity(note);
    await database.insertToDatabase(note: model);
  }

  @override
  Future<void> deleteNote(String id) async {
    await database.deleteFromDatabase(id: id);
  }

  @override
  Future<void> updateNote(Note note) async {
    final model = NoteModel.fromEntity(note);
    await database.editDatabaseItem(note: model);
  }
}

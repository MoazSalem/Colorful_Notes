import 'package:colorful_notes/features/notes/data/repository/note_repo_impl.dart';
import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/domain/repositories/note_repository.dart';
import 'package:colorful_notes/features/notes/domain/usecases/add_note.dart';
import 'package:colorful_notes/features/notes/domain/usecases/delete_note.dart';
import 'package:colorful_notes/features/notes/domain/usecases/get_notes.dart';
import 'package:colorful_notes/features/notes/domain/usecases/update_note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorful_notes/features/notes/ui/providers/database_provider.dart';
import 'notifier_provider.dart';

final notesNotifierProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(
  NotesNotifier.new,
);

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  final database = ref.watch(databaseProvider).value!;
  return NoteRepositoryImpl(database);
});

final getNotesUseCaseProvider = Provider<GetNotesUseCase>((ref) {
  final repo = ref.watch(noteRepositoryProvider);
  return GetNotesUseCase(repo);
});

final addNoteUseCaseProvider = Provider<AddNoteUseCase>((ref) {
  final repo = ref.watch(noteRepositoryProvider);
  return AddNoteUseCase(repo);
});

final updateNoteUseCaseProvider = Provider<UpdateNoteUseCase>((ref) {
  final repo = ref.watch(noteRepositoryProvider);
  return UpdateNoteUseCase(repo);
});

final deleteNoteUseCaseProvider = Provider<DeleteNoteUseCase>((ref) {
  final repo = ref.watch(noteRepositoryProvider);
  return DeleteNoteUseCase(repo);
});

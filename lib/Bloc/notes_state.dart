part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class NotesInitial extends NotesState {
}
class DatabaseInitial extends NotesState {}
class NavigationBarChanged extends NotesState {}
class NoteCreate extends NotesState {}
class PrefsChanged extends NotesState {}
class Searched extends NotesState {}
class ViewChanged extends NotesState {}
class ColorsChanged extends NotesState {}

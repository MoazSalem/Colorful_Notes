import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/ui/providers/notes_provider.dart';
import 'package:colorful_notes/core/shared_widgets/custom_appbar.dart';
import 'package:colorful_notes/features/notes/ui/screens/voice_note.dart';
import 'package:colorful_notes/features/notes/ui/widgets/appbar_action_widgets.dart';
import 'package:colorful_notes/features/notes/ui/widgets/notes/large_note.dart';
import 'package:colorful_notes/features/notes/ui/widgets/notes/wide_small_note_widget.dart';
import 'package:colorful_notes/features/notes/ui/widgets/search_bar_widget.dart';
import 'package:colorful_notes/features/notes/ui/screens/text_note.dart';
import 'package:colorful_notes/features/notes/ui/widgets/notes/small_grid_note.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:colorful_notes/core/services/service_locator.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/core/services/settings_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final TextEditingController searchController = TextEditingController();

class NotesList extends StatefulWidget {
  const NotesList({super.key, required this.typeIndex});
  final int typeIndex;

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  int viewIndex = 0;
  @override
  Widget build(BuildContext context) {
    final settingsService = serviceLocator<SettingsService>();
    final String pageTitle = getPageTitle(widget.typeIndex);
    bool isSearching = false;

    return ValueListenableBuilder<SettingsModel>(
      valueListenable: settingsService.settings,
      builder: (context, settings, child) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            CustomAppbar(
              title: pageTitle,
              top: 65,
              leading: AppbarActionWidgets(
                searchController: searchController,
                settings: settings,
                onToggle: () => setState(() => isSearching = !isSearching),
                switchView: () =>
                    setState(() => viewIndex = (viewIndex + 1) % 3),
                viewIndex: viewIndex,
              ),
            ),
            SearchBarWidget(
              isSearching: isSearching,
              searchController: searchController,
            ),
            Consumer(
              builder: (context, ref, child) {
                final notes = ref.watch(notesNotifierProvider);
                if (widget.typeIndex == 0) {
                  Future.microtask(() {
                    ref.read(notesNotifierProvider.notifier).getNotes();
                  });
                } else {
                  Future.microtask(() {
                    ref
                        .read(notesNotifierProvider.notifier)
                        .getNotesOfType(widget.typeIndex == 2);
                  });
                }
                return notes.when(
                  data: (data) =>
                      _buildNotesList(context, settings, data, viewIndex),
                  error: (Object error, StackTrace stackTrace) {
                    return Center(child: Text(error.toString()));
                  },
                  loading: () {
                    // should be unnoticeable, so no loading widget
                    return Container();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotesList(
    BuildContext context,
    SettingsModel settings,
    List<Note> notes,
    int viewIndex,
  ) {
    final theme = Theme.of(context).colorScheme;
    final double padding = settings.sbIndex == 4 ? 28 : 12;
    if (notes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 200),
        child: Center(
          child: Text(
            "N${widget.typeIndex}".tr(),
            style: TextStyle(
              color: settings.colorful
                  ? AppConsts.lightColors[widget.typeIndex]
                  : theme.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.only(
        top: settings.sbIndex == 4 ? 16 : 0,
        bottom: 32,
        left: padding,
        right: padding,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: viewIndex == 2 ? 2 : 1,
        childAspectRatio: viewIndex == 1
            ? settings.sbIndex == 4
                  ? 3.25
                  : 3.05
            : 1.0,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(4.0),
          child: _buildNoteItem(
            context,
            settings,
            notes.reversed.toList()[index],
            viewIndex,
          ),
        );
      },
    );
  }

  Widget _buildNoteItem(
    BuildContext context,
    SettingsModel settings,
    Note note,
    int viewIndex,
  ) {
    Widget noteView;
    if (viewIndex == 2) {
      noteView = SmallGridNote(note: note, settings: settings);
    } else if (viewIndex == 0) {
      noteView = LargeNote(note: note, settings: settings);
    } else {
      noteView = WideSmallNoteWidget(note: note, settings: settings);
    }
    return GestureDetector(
      onTap: () => _editNote(context, note),
      child: noteView,
    );
  }

  void _editNote(BuildContext context, Note note) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => note.type == 0
          ? TextNote(note: note, isEditing: false)
          : VoiceNote(note: note, isEditing: false),
    );
  }
}

String getPageTitle(int index) {
  switch (index) {
    case 0:
      return "Home".tr();
    case 1:
      return "Text Note".tr();
    case 2:
      return "Voice Note".tr();
    default:
      return "Home".tr();
  }
}

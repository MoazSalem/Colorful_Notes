import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/helpers/widgets_helper.dart';
import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/ui/providers/notes_provider.dart';
import 'package:colorful_notes/core/shared_widgets/custom_appbar.dart';
import 'package:colorful_notes/features/notes/ui/screens/voice_note.dart';
import 'package:colorful_notes/features/notes/ui/widgets/appbar_action_widgets.dart';
import 'package:colorful_notes/features/notes/ui/widgets/search_bar_widget.dart';
import 'package:colorful_notes/features/notes/ui/screens/text_note.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:colorful_notes/core/services/service_locator.dart';
import 'package:colorful_notes/features/notes/ui/widgets/notes.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/core/services/settings_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final TextEditingController searchController = TextEditingController();

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  int viewIndex = 0;
  @override
  Widget build(BuildContext context) {
    final settingsService = serviceLocator<SettingsService>();
    bool isSearching = false;

    return ValueListenableBuilder<SettingsModel>(
      valueListenable: settingsService.settings,
      builder: (context, settings, child) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            CustomAppbar(
              title: "Home".tr(),
              top: 65,
              locale: settings.lang,
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
                return notes.when(
                  data: (data) =>
                      _buildNotesList(context, settings, data, viewIndex),
                  error: (Object error, StackTrace stackTrace) {
                    return Center(child: Text(error.toString()));
                  },
                  loading: () {
                    return Center(child: CircularProgressIndicator());
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
    if (notes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 200),
        child: Center(
          child: Text(
            "N1".tr(),
            style: TextStyle(
              color: settings.colorful
                  ? AppConsts.lightColors[0]
                  : theme.primary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );
    }

    if (viewIndex == 2) {
      // Grid View
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return _buildNoteItem(
            context,
            settings,
            notes,
            notes.length - 1 - index,
            viewIndex,
            isGridView: true,
          );
        },
      );
    } else {
      // List View (Normal or Small)
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return _buildNoteItem(
            context,
            settings,
            notes,
            notes.length - 1 - index,
            viewIndex,
          );
        },
      );
    }
  }

  Widget _buildNoteItem(
    BuildContext context,
    SettingsModel settings,
    List<Note> notes,
    int index,
    int viewIndex, {
    bool isGridView = false,
  }) {
    final note = notes[index];
    final bool noTitle = note.title == "";
    final bool noContent = note.content == "";
    final String date = WidgetsHelper.parsedDate(note.time, settings.lang);
    final int dateValue = WidgetsHelper.calculateDifference(note.time);

    Widget noteView;
    if (isGridView) {
      noteView = gridView(
        context: context,
        notes: notes,
        colors: AppConsts.lightColors,
        index: index,
        dateValue: dateValue,
        date: date,
        noTitle: noTitle,
        noContent: noContent,
        showDate: settings.showDate,
        showShadow: settings.showShadow,
        showEdited: settings.showEdited,
        lang: settings.lang,
        width: MediaQuery.of(context).size.width,
      );
    } else if (viewIndex == 0) {
      noteView = listView(
        context: context,
        notes: notes,
        colors: AppConsts.lightColors,
        index: index,
        dateValue: dateValue,
        date: date,
        noTitle: noTitle,
        noContent: noContent,
        showDate: settings.showDate,
        showShadow: settings.showShadow,
        showEdited: settings.showEdited,
        lang: settings.lang,
        width: MediaQuery.of(context).size.width,
      );
    } else {
      noteView = smallListView(
        context: context,
        notes: notes,
        colors: AppConsts.lightColors,
        index: index,
        dateValue: dateValue,
        date: date,
        noTitle: noTitle,
        noContent: noContent,
        showDate: settings.showDate,
        showShadow: settings.showShadow,
        showEdited: settings.showEdited,
        lang: settings.lang,
        width: MediaQuery.of(context).size.width,
      );
    }

    return Stack(
      alignment: note.layout == 0 || note.layout == 2
          ? Alignment.topRight
          : Alignment.topLeft,
      children: [
        GestureDetector(onTap: () => _editNote(context, note), child: noteView),
        IconButton(
          onPressed: () =>
              {}, //notesCubit.showDeleteDialog(context, notes, index),
          icon: Icon(
            Icons.highlight_remove,
            color: note.tIndex == 0 ? Colors.white : Colors.black,
            size: 20,
          ),
        ),
      ],
    );
  }

  void _editNote(BuildContext context, Note note) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) =>
          note.type == 0 ? TextNote(note: note) : VoiceNote(note: note),
    );
  }
}

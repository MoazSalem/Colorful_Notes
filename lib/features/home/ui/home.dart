import 'dart:ui' as ui;
import 'package:colorful_notes/core/shared_widgets/custom_appbar.dart';
import 'package:colorful_notes/features/home/ui/widgets/appbar_action_widgets.dart';
import 'package:colorful_notes/features/home/ui/widgets/search_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colorful_notes/core/services/service_locator.dart';
import 'package:colorful_notes/features/home/ui/widgets/custom_fab.dart';
import 'package:colorful_notes/features/home/ui/widgets/notes.dart';
import 'package:colorful_notes/features/notes_creation/ui/create_note.dart';
import 'package:colorful_notes/features/notes_creation/ui/create_voice.dart';
import 'package:colorful_notes/features/notes_creation/ui/edit_note.dart';
import 'package:colorful_notes/features/notes_creation/ui/edit_voice.dart';
import 'package:colorful_notes/main.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/old_logic/notes_cubit.dart';
import 'package:colorful_notes/core/services/settings_service.dart';

final TextEditingController searchController = TextEditingController();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final settingsService = serviceLocator<SettingsService>();
    final notesCubit = context.watch<NotesCubit>();
    bool isSearching = false;

    return ValueListenableBuilder<SettingsModel>(
      valueListenable: settingsService.settings,
      builder: (context, settings, child) {
        return BlocBuilder<NotesCubit, NotesState>(
          builder: (context, noteState) {
            final notes = isSearching
                ? notesCubit.notes['homeSearched']!
                : notesCubit.notes['homeNotes']!;

            return Scaffold(
              backgroundColor: C.theme.surface,
              floatingActionButtonLocation: settings.fabIndex == 0
                  ? FloatingActionButtonLocation.endFloat
                  : FloatingActionButtonLocation.startFloat,
              floatingActionButton: _buildFab(context, settings),
              body: ListView(
                padding: EdgeInsets.zero,
                children: [
                  CustomAppbar(
                    title: "Home".tr(),
                    top: 65,
                    locale: settings.lang,
                    leading: AppbarActionWidgets(
                      searchController: searchController,
                      C: notesCubit,
                      settings: settings,
                      onToggle: () =>
                          setState(() => isSearching = !isSearching),
                    ),
                  ),
                  SearchBarWidget(
                    isSearching: isSearching,
                    searchController: searchController,
                    C: C,
                  ),
                  _buildNotesList(context, settings, notes, notesCubit),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFab(BuildContext context, SettingsModel settings) {
    final fab = customFab(
      theme: C.theme,
      colors: C.colors,
      action1: () => _createNote(context),
      action2: () => _createVoice(context),
      colorful: settings.colorful,
      isTablet: C.isTablet,
    );

    return settings.fabIndex == 0
        ? fab
        : Directionality(
            textDirection: settings.lang == 'en'
                ? ui.TextDirection.rtl
                : ui.TextDirection.ltr,
            child: fab,
          );
  }

  Widget _buildNotesList(
    BuildContext context,
    SettingsModel settings,
    List<Map> notes,
    NotesCubit notesCubit,
  ) {
    final int viewIndex = C.box.get('viewIndex') ?? 0;

    if (notes.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 200),
        child: Center(
          child: Text(
            "N1".tr(),
            style: TextStyle(
              color: settings.colorful ? C.colors[0] : C.theme.primary,
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
            notesCubit,
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
            notesCubit,
          );
        },
      );
    }
  }

  Widget _buildNoteItem(
    BuildContext context,
    SettingsModel settings,
    List<Map> notes,
    int index,
    NotesCubit notesCubit, {
    bool isGridView = false,
  }) {
    final note = notes[index];
    final bool noTitle = note["title"] == "";
    final bool noContent = note["content"] == "";
    final String date = C.parseDate(note["time"]);
    final int dateValue = C.calculateDifference(note["time"]);
    final int viewIndex = C.box.get('viewIndex') ?? 0;

    Widget noteView;
    if (isGridView) {
      noteView = gridView(
        context: context,
        notes: notes,
        colors: C.colors,
        index: index,
        dateValue: dateValue,
        date: date,
        noTitle: noTitle,
        noContent: noContent,
        showDate: settings.showDate,
        showShadow: settings.showShadow,
        showEdited: settings.showEdited,
        isTablet: C.isTablet,
        lang: settings.lang,
        width: C.width,
      );
    } else if (viewIndex == 0) {
      noteView = listView(
        context: context,
        notes: notes,
        colors: C.colors,
        index: index,
        dateValue: dateValue,
        date: date,
        noTitle: noTitle,
        noContent: noContent,
        showDate: settings.showDate,
        showShadow: settings.showShadow,
        showEdited: settings.showEdited,
        isTablet: C.isTablet,
        lang: settings.lang,
        width: C.width,
      );
    } else {
      noteView = smallListView(
        context: context,
        notes: notes,
        colors: C.colors,
        index: index,
        dateValue: dateValue,
        date: date,
        noTitle: noTitle,
        noContent: noContent,
        showDate: settings.showDate,
        showShadow: settings.showShadow,
        showEdited: settings.showEdited,
        isTablet: C.isTablet,
        lang: settings.lang,
        width: C.width,
      );
    }

    return Stack(
      alignment: note["layout"] == 0 || note["layout"] == 2
          ? Alignment.topRight
          : Alignment.topLeft,
      children: [
        GestureDetector(onTap: () => _editNote(context, note), child: noteView),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: C.isTablet ? 8.0 : 0,
            vertical: C.isTablet ? 8.0 : 0,
          ),
          child: IconButton(
            onPressed: () => notesCubit.showDeleteDialog(context, notes, index),
            icon: Icon(
              Icons.highlight_remove,
              color: note['tindex'] == 0 ? Colors.white : Colors.black,
              size: C.width * 0.0662,
            ),
          ),
        ),
      ],
    );
  }

  void _createNote(BuildContext context) {
    showBottomSheet(context: context, builder: (context) => const CreateNote());
  }

  void _createVoice(BuildContext context) {
    showBottomSheet(
      context: context,
      enableDrag: false,
      builder: (context) => const CreateVoice(),
    );
  }

  void _editNote(BuildContext context, Map note) {
    showBottomSheet(
      context: context,
      builder: (context) =>
          note['type'] == 0 ? EditNote(note: note) : EditVoice(note: note),
    );
  }
}

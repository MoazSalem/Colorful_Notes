import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Cubit/notes_cubit.dart';
import 'package:notes/Screens/Actions/create_note.dart';
import 'package:notes/Screens/Actions/edit_note.dart';
import 'package:notes/Screens/SideBar/home.dart';
import 'package:notes/Screens/home_screen.dart';
import 'package:notes/Widgets/notes.dart';
import 'package:notes/main.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late int viewIndex;
  late List<Map> notes;
  bool noTitle = false;
  bool noContent = false;
  bool searchOn = false;
  bool openFab = false;

  @override
  void initState() {
    viewIndex = C.box.get('viewIndexN') ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        notes = (searchOn ? C.notes['textSearched'] : C.notes['textNotes'])!;
        return Scaffold(
          backgroundColor: C.isDark
              ? C.theme.background
              : C.theme.surfaceVariant.withOpacity(0.6),
          floatingActionButtonLocation: C.settings["fabIndex"] == 0
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            splashColor: C.colors[0],
            elevation: 0,
            backgroundColor: C.settings["colorful"] ? C.colors[1] : primaryColor,
            onPressed: () async {
              create();
            },
            child: Icon(
              Icons.add,
              color: C.theme.surfaceVariant,
            ),
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              C.customAppBar("Text".tr(), 65, leading()),
              searchOn
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextFormField(
                            autofocus: true,
                            controller: searchController,
                            onChanged: (query) => C.search(query: query, where: "text"),
                            maxLines: 1,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: C.isTablet ? 20 : 5, horizontal: 20),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(0)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: primaryColor),
                                  borderRadius: BorderRadius.circular(0)),
                              hintText: "Search".tr(),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                            )),
                      ),
                    )
                  : Container(),
              notes.isNotEmpty
                  ? viewIndex != 2
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                int reverseIndex = notes.length - index - 1;
                                notes[reverseIndex]["title"] == ""
                                    ? noTitle = true
                                    : noTitle = false;
                                notes[reverseIndex]["content"] == ""
                                    ? noContent = true
                                    : noContent = false;
                                int dateValue = C.calculateDifference(notes[reverseIndex]["time"]);
                                String date = C.parseDate(notes[reverseIndex]["time"]);
                                Widget chosenView = viewIndex == 0
                                    ? Stack(
                                        alignment: notes[reverseIndex]["layout"] == 0
                                            ? Alignment.topRight
                                            : Alignment.topLeft,
                                        children: [
                                          GestureDetector(
                                            onTap: () => edit(reverseIndex),
                                            child: listView(
                                              context: context,
                                              notes: notes,
                                              colors: C.colors,
                                              index: reverseIndex,
                                              dateValue: dateValue,
                                              date: date,
                                              noTitle: noTitle,
                                              noContent: noContent,
                                              showDate: C.settings["showDate"],
                                              showShadow: C.settings["showShadow"],
                                              showEdited: C.settings["showEdited"],
                                              isTablet: C.isTablet,
                                              lang: context.locale.toString(),
                                              width: C.width,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: notes[reverseIndex]["layout"] == 0
                                                    ? 10
                                                    : C.isTablet
                                                        ? 15
                                                        : 10,
                                                vertical: C.width * 0.02037),
                                            child: IconButton(
                                                focusColor: Colors.blue,
                                                onPressed: () async {
                                                  showDelete(reverseIndex);
                                                },
                                                icon: Icon(
                                                  Icons.highlight_remove,
                                                  color: notes[reverseIndex]['tindex'] == 0
                                                      ? Colors.white
                                                      : Colors.black,
                                                  size: C.width * 0.06620,
                                                )),
                                          ),
                                        ],
                                      )
                                    : Stack(
                                        alignment: notes[reverseIndex]["layout"] == 0
                                            ? Alignment.topRight
                                            : Alignment.topLeft,
                                        children: [
                                          GestureDetector(
                                            onTap: () => edit(reverseIndex),
                                            child: smallListView(
                                              context: context,
                                              notes: notes,
                                              colors: C.colors,
                                              index: reverseIndex,
                                              dateValue: dateValue,
                                              date: date,
                                              noTitle: noTitle,
                                              noContent: noContent,
                                              showDate: C.settings["showDate"],
                                              showShadow: C.settings["showShadow"],
                                              showEdited: C.settings["showEdited"],
                                              isTablet: C.isTablet,
                                              lang: context.locale.toString(),
                                              width: C.width,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: C.isTablet ? 8.0 : 0,
                                                vertical: C.isTablet ? 8.0 : 0),
                                            child: IconButton(
                                                focusColor: Colors.blue,
                                                onPressed: () async {
                                                  showDelete(reverseIndex);
                                                },
                                                icon: Icon(
                                                  Icons.highlight_remove,
                                                  color: notes[reverseIndex]['tindex'] == 0
                                                      ? Colors.white
                                                      : Colors.black,
                                                  size: C.width * 0.0662,
                                                )),
                                          ),
                                        ],
                                      );
                                return chosenView;
                              }),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          child: GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                int reverseIndex = notes.length - index - 1;
                                notes[reverseIndex]["title"] == ""
                                    ? noTitle = true
                                    : noTitle = false;
                                notes[reverseIndex]["content"] == ""
                                    ? noContent = true
                                    : noContent = false;
                                int dateValue = C.calculateDifference(notes[reverseIndex]["time"]);
                                String date = C.parseDate(notes[reverseIndex]["time"]);
                                return Stack(
                                  alignment: notes[reverseIndex]["layout"] == 0
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  children: [
                                    GestureDetector(
                                      onTap: () => edit(reverseIndex),
                                      child: gridView(
                                        context: context,
                                        notes: notes,
                                        colors: C.colors,
                                        index: reverseIndex,
                                        dateValue: dateValue,
                                        date: date,
                                        noTitle: noTitle,
                                        noContent: noContent,
                                        showDate: C.settings["showDate"],
                                        showShadow: C.settings["showShadow"],
                                        showEdited: C.settings["showEdited"],
                                        isTablet: C.isTablet,
                                        lang: context.locale.toString(),
                                        width: C.width,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: C.isTablet ? 8.0 : 0,
                                          vertical: C.isTablet ? 8.0 : 0),
                                      child: IconButton(
                                          focusColor: Colors.blue,
                                          onPressed: () async {
                                            showDelete(reverseIndex);
                                          },
                                          icon: Icon(
                                            Icons.highlight_remove,
                                            color: notes[reverseIndex]['tindex'] == 0
                                                ? Colors.white
                                                : Colors.black,
                                            size: C.width * 0.0662,
                                          )),
                                    ),
                                  ],
                                );
                              }),
                        )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 200),
                      child: Center(
                          child: Text(
                        "N2".tr(),
                        style: TextStyle(
                            color: C.settings["colorful"] ? C.colors[1] : primaryColor,
                            fontWeight: FontWeight.w400),
                      )),
                    ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget leading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            searchOn = !searchOn;
            C.search(query: searchController.text, where: "text");
            C.onChanged();
          },
          icon: Icon(
            Icons.search,
            size: 30,
            color: searchOn
                ? C.settings["colorful"]
                    ? C.colors[1]
                    : primaryColor
                : C.theme.onSurfaceVariant,
          ),
        ),
        IconButton(
          onPressed: () {
            viewIndex < 2 ? viewIndex++ : viewIndex = 0;
            C.box.put("viewIndexN", viewIndex);
            C.onChanged();
          },
          icon: viewIndex == 0
              ? const Icon(Icons.indeterminate_check_box)
              : viewIndex == 1
                  ? const Icon(Icons.view_agenda_sharp)
                  : const Icon(Icons.grid_view_sharp),
        )
      ],
    );
  }

  create() {
    showBottomSheet(context: context, builder: (context) => const CreateNote());
  }

  edit(reverseIndex) {
    showBottomSheet(
      context: context,
      builder: (context) => EditNote(note: notes[reverseIndex]),
    );
  }

  showDelete(index) {
    C.showDeleteDialog(context, notes, index);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Bloc/notes_bloc.dart';
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
  late int value;
  late List<Map> notes;
  bool noTitle = false;
  bool noContent = false;
  bool searchOn = false;
  bool openFab = false;

  @override
  void initState() {
    value = B.viewIndexN;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    notes = searchOn ? B.searchedNotes : B.notesMap;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor:
              B.isDarkMode ? B.theme.background : B.theme.surfaceVariant.withOpacity(0.6),
          floatingActionButtonLocation: B.fabIndex == 0
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            splashColor: B.colors[0],
            elevation: 0,
            backgroundColor: B.colorful ? B.colors[1] : primaryColor,
            onPressed: () async {
              create();
            },
            child: Icon(
              Icons.add,
              color: B.theme.surfaceVariant,
            ),
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar("Text".tr(), 65, leading()),
              searchOn
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextFormField(
                            autofocus: true,
                            controller: searchController,
                            onChanged: B.searchNotes,
                            maxLines: 1,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: B.isTablet ? 20 : 5, horizontal: 20),
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
                  ? B.viewIndexN != 2
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
                                int dateValue = B.calculateDifference(notes[reverseIndex]["time"]);
                                String date = B.parseDate(notes[reverseIndex]["time"]);
                                Widget chosenView = B.viewIndexN == 0
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
                                              colors: B.colors,
                                              reverseIndex: reverseIndex,
                                              dateValue: dateValue,
                                              date: date,
                                              noTitle: noTitle,
                                              noContent: noContent,
                                              showDate: B.showDate,
                                              showShadow: B.showShadow,
                                              showEdited: B.showEdited,
                                              isTablet: B.isTablet,
                                              lang: context.locale.toString(),
                                              width: B.width,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: notes[reverseIndex]["layout"] == 0
                                                    ? 10
                                                    : B.isTablet
                                                        ? 15
                                                        : 10,
                                                vertical: B.width * 0.02037),
                                            child: IconButton(
                                                focusColor: Colors.blue,
                                                onPressed: () async {
                                                  showDelete(reverseIndex);
                                                },
                                                icon: Icon(
                                                  Icons.highlight_remove,
                                                  color: Colors.white,
                                                  size: B.width * 0.06620,
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
                                              colors: B.colors,
                                              reverseIndex: reverseIndex,
                                              dateValue: dateValue,
                                              date: date,
                                              noTitle: noTitle,
                                              noContent: noContent,
                                              showDate: B.showDate,
                                              showShadow: B.showShadow,
                                              showEdited: B.showEdited,
                                              isTablet: B.isTablet,
                                              lang: context.locale.toString(),
                                              width: B.width,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: B.isTablet ? 8.0 : 0,
                                                vertical: B.isTablet ? 8.0 : 0),
                                            child: IconButton(
                                                focusColor: Colors.blue,
                                                onPressed: () async {
                                                  showDelete(reverseIndex);
                                                },
                                                icon: Icon(
                                                  Icons.highlight_remove,
                                                  color: Colors.white,
                                                  size: B.width * 0.0662,
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
                                int dateValue = B.calculateDifference(notes[reverseIndex]["time"]);
                                String date = B.parseDate(notes[reverseIndex]["time"]);
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
                                        colors: B.colors,
                                        reverseIndex: reverseIndex,
                                        dateValue: dateValue,
                                        date: date,
                                        noTitle: noTitle,
                                        noContent: noContent,
                                        showDate: B.showDate,
                                        showShadow: B.showShadow,
                                        showEdited: B.showEdited,
                                        isTablet: B.isTablet,
                                        lang: context.locale.toString(),
                                        width: B.width,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: B.isTablet ? 8.0 : 0,
                                          vertical: B.isTablet ? 8.0 : 0),
                                      child: IconButton(
                                          focusColor: Colors.blue,
                                          onPressed: () async {
                                            showDelete(reverseIndex);
                                          },
                                          icon: Icon(
                                            Icons.highlight_remove,
                                            color: Colors.white,
                                            size: B.width * 0.0662,
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
                            color: B.colorful ? B.colors[1] : primaryColor,
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
            B.searchNotes(searchController.text);
            B.onSearch();
          },
          icon: Icon(
            Icons.search,
            size: 30,
            color: searchOn
                ? B.colorful
                    ? B.colors[1]
                    : primaryColor
                : B.theme.onSurfaceVariant,
          ),
        ),
        IconButton(
          onPressed: () {
            value < 2 ? value++ : value = 0;
            B.box.put("viewIndexN", value);
            B.viewIndexN = value;
            B.onViewChanged();
          },
          icon: B.viewIndexN == 0
              ? const Icon(Icons.indeterminate_check_box)
              : B.viewIndexN == 1
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
    B.showDeleteDialog(context, notes, index);
  }
}

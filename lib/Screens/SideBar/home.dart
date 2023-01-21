import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/Actions/edit_note.dart';
import 'package:notes/Screens/Actions/edit_voice.dart';
import 'package:notes/Widgets/custom_fab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notes/Widgets/notes.dart';
import 'package:notes/Screens/Actions/create_note.dart';
import 'package:notes/Screens/Actions/create_voice.dart';
import 'dart:ui' as ui;

bool noTitle = false;
bool noContent = false;
bool searchOn = false;
bool openFab = false;
final TextEditingController searchAC = TextEditingController();

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        var B = NotesBloc.get(context);
        int value = B.viewIndex;
        List<Map> notes = searchOn ? B.searchedALL : B.allNotesMap;
        Widget leading() {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  searchOn = !searchOn;
                  B.searchHome(searchAC.text);
                  B.onSearch();
                },
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: searchOn ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant,//const Color(0xffff8b34)
                ),
              ),
              IconButton(
                onPressed: () async {
                  value < 2 ? value++ : value = 0;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setInt("viewIndex", value);
                  B.viewIndex = value;
                  B.onViewChanged();
                },
                icon: B.viewIndex == 0
                    ? const Icon(Icons.view_agenda_sharp)
                    : B.viewIndex == 1
                        ? const Icon(Icons.view_day_sharp)
                        : const Icon(Icons.grid_view_sharp),
              )
            ],
          );
        }

        create1() {
          showBottomSheet(context: context, builder: (context) => createNote(context, false));
        }

        create2() {
          showBottomSheet(enableDrag: false, context: context, builder: (context) => createVoice(context));
        }

        edit(reverseIndex) {
          showBottomSheet(
            context: context,
            builder: (context) => notes[reverseIndex]['type'] == 0 ? editNote(note: notes[reverseIndex]) : editVoice(note: notes[reverseIndex]),
          );
        }

        showDelete(index) {
          B.showDeleteDialog(context, notes, index);
        }

        return Scaffold(
          backgroundColor: B.isDarkMode ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
          floatingActionButtonLocation: B.fabIndex == 0 ? FloatingActionButtonLocation.endFloat : FloatingActionButtonLocation.startFloat,
          floatingActionButton: B.fabIndex == 0
              ? customFab(context, openFab, B.colors, B.shadeColors, false, 0, 2, create1, create2)
              : Directionality(textDirection: B.lang == 'en' ? ui.TextDirection.rtl : ui.TextDirection.ltr, child: customFab(context, openFab, B.colors, B.shadeColors, false, 0, 2, create1, create2)),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar(context, "Home".tr(), 65, leading()),
              searchOn
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextFormField(
                            autofocus: true,
                            controller: searchAC,
                            onChanged: B.searchHome,
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: B.isTablet ? 20 : 5, horizontal: 20),
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(0)),
                              hintText: "Search".tr(),
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(0)),
                            )),
                      ),
                    )
                  : Container(),
              notes.isNotEmpty
                  ? B.viewIndex != 2
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                int reverseIndex = notes.length - index - 1;
                                notes[reverseIndex]["title"] == "" ? noTitle = true : noTitle = false;
                                notes[reverseIndex]["content"] == "" ? noContent = true : noContent = false;
                                int dateValue = B.calculateDifference(notes[reverseIndex]["time"]);
                                String date = B.parseDate(notes[reverseIndex]["time"]);
                                Widget chosenView = B.viewIndex == 0
                                    ? Stack(
                                        alignment: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? Alignment.topRight : Alignment.topLeft,
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
                                                showEdited: B.showEdited),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2
                                                    ? 20
                                                    : B.isTablet
                                                        ? 15
                                                        : 10,
                                                vertical: B.width * 0.02037),
                                            child: IconButton(
                                                constraints: BoxConstraints.tightFor(width: B.width * 0.083, height: B.width * 0.083),
                                                focusColor: Colors.blue,
                                                onPressed: () async {
                                                  showDelete(reverseIndex);
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: B.width * 0.06620,
                                                )),
                                          ),
                                        ],
                                      )
                                    : Stack(
                                        alignment: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? Alignment.topRight : Alignment.topLeft,
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
                                                showEdited: B.showEdited),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: B.isTablet
                                                    ? 8.0
                                                    : notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2
                                                    ? 10
                                                        : 0,
                                                vertical: B.isTablet ? 8.0 : 0),
                                            child: IconButton(
                                                constraints: BoxConstraints.tightFor(width: B.width * 0.083, height: B.width * 0.083),
                                                focusColor: Colors.blue,
                                                onPressed: () async {
                                                  showDelete(reverseIndex);
                                                },
                                                icon: Icon(
                                                  Icons.close,
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
                                notes[reverseIndex]["title"] == "" ? noTitle = true : noTitle = false;
                                notes[reverseIndex]["content"] == "" ? noContent = true : noContent = false;
                                int dateValue = B.calculateDifference(notes[reverseIndex]["time"]);
                                String date = B.parseDate(notes[reverseIndex]["time"]);
                                return Stack(
                                  alignment: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2  ? Alignment.topRight : Alignment.topLeft,
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
                                          showEdited: B.showEdited),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: B.isTablet
                                              ? 8.0
                                              : notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2
                                              ? 10
                                                  : 0,
                                          vertical: B.isTablet ? 8.0 : 0),
                                      child: IconButton(
                                          constraints: BoxConstraints.tightFor(width: B.width * 0.083, height: B.width * 0.083),
                                          focusColor: Colors.blue,
                                          onPressed: () async {
                                            showDelete(reverseIndex);
                                          },
                                          icon: Icon(
                                            Icons.close,
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
                        "N1".tr(),
                        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w400), //B.colors[0]
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
}

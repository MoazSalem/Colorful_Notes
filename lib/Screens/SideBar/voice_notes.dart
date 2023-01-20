import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/Actions/edit_voice.dart';
import 'package:notes/Widgets/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Actions/create_voice.dart';

late bool noTitle;
bool searchOn = false;
final TextEditingController searchVC = TextEditingController();

class VoiceNotesPage extends StatelessWidget {
  const VoiceNotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        var B = NotesBloc.get(context);
        int value = B.viewIndexV;
        List<Map> notes = searchOn ? B.searchedVoice : B.voiceMap;

        showDelete(index) {
          B.showDeleteDialog(context, notes, index);
        }

        Widget leading() {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  searchOn = !searchOn;
                  B.searchVoice(searchVC.text);
                  B.onSearch();
                },
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: searchOn ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant, //Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              IconButton(
                onPressed: () async {
                  value < 2 ? value++ : value = 0;
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setInt("viewIndex", value);
                  B.viewIndexV = value;
                  B.onViewChanged();
                },
                icon: B.viewIndexV == 0
                    ? const Icon(Icons.view_agenda_sharp)
                    : B.viewIndexV == 1
                        ? const Icon(Icons.view_day_sharp)
                        : const Icon(Icons.grid_view_sharp),
              )
            ],
          );
        }

        edit(index) {
          showBottomSheet(
            context: context,
            builder: (context) => editVoice(note: notes[index]),
          );
        }

        return Scaffold(
          backgroundColor: B.isDarkMode ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
          floatingActionButtonLocation: B.fabIndex == 0 ? FloatingActionButtonLocation.endFloat : FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton(
            splashColor: B.colors[1].harmonizeWith(Theme.of(context).colorScheme.primary),
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            //B.colors[3].harmonizeWith(Theme.of(context).colorScheme.primary),
            onPressed: () async {
              showBottomSheet(enableDrag: false, context: context, builder: (context) => createVoice(context));
            },
            child: Icon(
              Icons.add,
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar(context, "Voice".tr(), 65, leading()),
              searchOn
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextFormField(
                            autofocus: true,
                            controller: searchVC,
                            onChanged: B.searchVoice,
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
                  ? B.viewIndexV != 2
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
                                int dateValue = B.calculateDifference(notes[reverseIndex]["time"]);
                                String date = B.parseDate(notes[reverseIndex]["time"]);
                                Widget chosenView = B.viewIndexV == 0
                                    ? Stack(
                                        alignment: Alignment.topRight,
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
                                                noContent: false,
                                                showDate: B.showDate,
                                                showShadow: B.showShadow,
                                                showEdited: B.showEdited),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 15 : 20, vertical: B.width * 0.02037),
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
                                        alignment: Alignment.topRight,
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
                                                noContent: false,
                                                showDate: B.showDate,
                                                showShadow: B.showShadow,
                                                showEdited: B.showEdited),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 8.0 : 10, vertical: B.isTablet ? 8.0 : 0),
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
                                int dateValue = B.calculateDifference(notes[reverseIndex]["time"]);
                                String date = B.parseDate(notes[reverseIndex]["time"]);
                                return Stack(
                                  alignment: Alignment.topRight,
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
                                          noContent: false,
                                          showDate: B.showDate,
                                          showShadow: B.showShadow,
                                          showEdited: B.showEdited),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 8.0 : 10, vertical: B.isTablet ? 8.0 : 0),
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
                        "N3".tr(),
                        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w400), //B.colors[3]
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

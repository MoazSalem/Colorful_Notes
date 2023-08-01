import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/Actions/edit_voice.dart';
import 'package:notes/Screens/SideBar/home.dart';
import 'package:notes/Screens/home_screen.dart';
import 'package:notes/Widgets/notes.dart';
import 'package:notes/Screens/Actions/create_voice.dart';
import 'package:notes/main.dart';

class VoiceNotesPage extends StatefulWidget {
  const VoiceNotesPage({Key? key}) : super(key: key);

  @override
  State<VoiceNotesPage> createState() => _VoiceNotesPageState();
}

class _VoiceNotesPageState extends State<VoiceNotesPage> {
  late bool noTitle;
  late int value;
  late List<Map> notes;
  bool searchOn = false;

  @override
  void initState() {
    value = B.viewIndexV;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    notes = searchOn ? B.searchedVoice : B.voiceMap;
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
            splashColor: B.colors[1],
            elevation: 0,
            backgroundColor: B.colorful ? B.colors[3] : primaryColor,
            onPressed: () async {
              showBottomSheet(
                  enableDrag: false, context: context, builder: (context) => const CreateVoice());
            },
            child: Icon(
              Icons.add,
              color: B.theme.surfaceVariant,
            ),
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar("Voice".tr(), 65, leading()),
              searchOn
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: TextFormField(
                            autofocus: true,
                            controller: searchController,
                            onChanged: B.searchVoice,
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
                                notes[reverseIndex]["title"] == ""
                                    ? noTitle = true
                                    : noTitle = false;
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
                                              showEdited: B.showEdited,
                                              isTablet: B.isTablet,
                                              lang: context.locale.toString(),
                                              width: B.width,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: B.isTablet ? 15 : 10,
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
                        "N3".tr(),
                        style: TextStyle(
                            color: B.colorful ? B.colors[3] : primaryColor,
                            fontWeight: FontWeight.w400), //B.colors[3]
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
            B.searchVoice(searchController.text);
            B.onSearch();
          },
          icon: Icon(
            Icons.search,
            size: 30,
            color: searchOn
                ? B.colorful
                    ? B.colors[3]
                    : primaryColor
                : B.theme.onSurfaceVariant, //Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        IconButton(
          onPressed: () {
            value < 2 ? value++ : value = 0;
            B.box.put("viewIndexV", value);
            B.viewIndexV = value;
            B.onViewChanged();
          },
          icon: B.viewIndexV == 0
              ? const Icon(Icons.indeterminate_check_box)
              : B.viewIndexV == 1
                  ? const Icon(Icons.view_agenda_sharp)
                  : const Icon(Icons.grid_view_sharp),
        )
      ],
    );
  }

  edit(index) {
    showBottomSheet(
      context: context,
      builder: (context) => EditVoice(note: notes[index]),
    );
  }
}

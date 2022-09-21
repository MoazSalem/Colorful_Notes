import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/Actions/EditNote.dart';
import 'package:notes/Screens/Actions/CreateNote.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool noTitle = false;
bool noContent = false;
bool SearchOn = false;
Map<String, int> viewModes = {"Large View": 0, "Long View": 1, "Grid View": 2};
List<Map> searchedNotes = [];
final TextEditingController searchC = TextEditingController();

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var B = NotesBloc.get(context);
        List<Map> Notes = SearchOn ? searchedNotes : B.notesMap;

        void searchNotes(String query) {
          final searched = B.notesMap.where((note) {
            final title = note['title'].toString().toLowerCase();
            final content = note['content'].toString().toLowerCase();
            return title.contains(query) || content.contains(query);
          }).toList();
          searchedNotes = searched;
          B.onSearch();
        }

        Widget leading() {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  showBottomSheet(
                      context: context,
                      builder: (context) => createNote(context));
                },
                icon: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  SearchOn = !SearchOn;
                  searchNotes(searchC.text);
                  B.onSearch();
                },
                icon: Icon(
                  Icons.search,
                  size: 30,
                  color: SearchOn
                      ? Color(0xffff8b34)
                      : Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setInt("viewIndex", viewModes[value]!);
                  B.viewIndex = viewModes[value]!;
                  B.onViewChanged();
                },
                itemBuilder: (BuildContext context) {
                  return {"Large View", "Long View", "Grid View"}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList();
                },
              ),
            ],
          );
        }

        Future<void> showDeleteDialog(
            {required List<Map> Notes, required int index}) async {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Remove Note",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                content: Text("Are you sure you want to remove this note?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel")),
                  TextButton(
                      onPressed: () async {
                        await B.deleteFromDatabase(id: Notes[index]["id"]);
                        searchNotes(searchC.text);
                        Navigator.of(context).pop();
                        B.onCreateNote();
                      },
                      child: Text("Yes"))
                ],
              );
            },
          );
        }

        Widget nListView(
            List<Map> Notes, int reverseIndex, int dateValue, String date) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: B.showShadow ? 2 : 0),
              child: Stack(alignment: Alignment.topRight, children: [
                GestureDetector(
                  onTap: () => showBottomSheet(
                    context: context,
                    builder: (context) => EditNote(context,
                        ID: Notes[reverseIndex]['id'],
                        Title: Notes[reverseIndex]["title"],
                        Content: Notes[reverseIndex]["content"],
                        index: Notes[reverseIndex]['cindex']),
                  ),
                  child: Container(
                    height: 300,
                    width: 300,
                    child: Card(
                      color: B.colors[Notes[reverseIndex]['cindex']],
                      elevation: B.showShadow ? 4 : 0,
                      shadowColor: B.colors[Notes[reverseIndex]['cindex']],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 40.0,
                            right: 40.0,
                            top: 40,
                            bottom: B.showDate ? 15 : 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              noTitle
                                  ? Container()
                                  : Expanded(
                                      flex: 2,
                                      child: Text(Notes[reverseIndex]["title"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 24,
                                              color: Colors.white)),
                                    ),
                              Expanded(
                                flex: 7,
                                child: Text(
                                    noContent
                                        ? "Empty"
                                        : Notes[reverseIndex]["content"],
                                    maxLines: B.showDate ? 8 : 9,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: noContent
                                            ? Colors.white38
                                            : Colors.white,
                                        fontSize: noTitle ? 21 : 16)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              B.showDate
                                  ? Expanded(
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          Text(
                                            dateValue == 0
                                                ? "Today"
                                                : dateValue == -1
                                                    ? "Yesterday"
                                                    : date,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                Notes[reverseIndex]["edited"] ==
                                                        "yes"
                                                    ? "Edited"
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.white38),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ]),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: IconButton(
                      focusColor: Colors.blue,
                      onPressed: () async {
                        showDeleteDialog(index: reverseIndex, Notes: Notes);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 26,
                      )),
                ),
              ]),
            ),
          );
        }

        Widget nSmallListView(
            List<Map> Notes, int reverseIndex, int dateValue, String date) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: B.showShadow ? 2 : 0),
              child: Stack(alignment: Alignment.topRight, children: [
                GestureDetector(
                  onTap: () => showBottomSheet(
                    context: context,
                    builder: (context) => EditNote(
                      context,
                      ID: Notes[reverseIndex]['id'],
                      Title: Notes[reverseIndex]["title"],
                      Content: Notes[reverseIndex]["content"],
                      index: Notes[reverseIndex]['cindex'],
                    ),
                  ),
                  child: Container(
                    height: 110,
                    width: 300,
                    child: Card(
                      color: B.colors[Notes[reverseIndex]['cindex']],
                      elevation: B.showShadow ? 4 : 0,
                      shadowColor: B.colors[Notes[reverseIndex]['cindex']],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15.0,
                            right: noTitle ? 30.0 : 20.0,
                            top: noTitle ? 14.0 : 12.0,
                            bottom: B.showDate ? 10 : 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              noTitle
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 6, right: 40),
                                      child: Text(Notes[reverseIndex]["title"],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 24,
                                              color: Colors.white)),
                                    ),
                              Expanded(
                                flex: noTitle ? 2 : 1,
                                child: Text(
                                    noContent
                                        ? "Empty"
                                        : Notes[reverseIndex]["content"],
                                    maxLines: noTitle
                                        ? B.showDate
                                            ? 2
                                            : 3
                                        : B.showDate
                                            ? 1
                                            : 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: noContent
                                            ? Colors.white38
                                            : Colors.white,
                                        fontSize: noTitle ? 21 : 16)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              B.showDate
                                  ? Expanded(
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          Text(
                                            dateValue == 0
                                                ? "Today"
                                                : dateValue == -1
                                                    ? "Yesterday"
                                                    : date,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                Notes[reverseIndex]["edited"] ==
                                                        "yes"
                                                    ? "Edited"
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.white38),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ]),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: IconButton(
                      focusColor: Colors.blue,
                      onPressed: () async {
                        showDeleteDialog(index: reverseIndex, Notes: Notes);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 26,
                      )),
                ),
              ]),
            ),
          );
        }

        Widget nGridView(
            List<Map> Notes, int reverseIndex, int dateValue, String date) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: B.showShadow ? 2 : 0),
              child: Stack(alignment: Alignment.topRight, children: [
                GestureDetector(
                  onTap: () => showBottomSheet(
                    context: context,
                    builder: (context) => EditNote(
                      context,
                      ID: Notes[reverseIndex]['id'],
                      Title: Notes[reverseIndex]["title"],
                      Content: Notes[reverseIndex]["content"],
                      index: Notes[reverseIndex]['cindex'],
                    ),
                  ),
                  child: Container(
                    height: 180,
                    width: 180,
                    child: Card(
                      color: B.colors[Notes[reverseIndex]['cindex']],
                      elevation: B.showShadow ? 4 : 0,
                      shadowColor: B.colors[Notes[reverseIndex]['cindex']],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15.0,
                            right: 20.0,
                            top: noTitle ? 14.0 : 14.0,
                            bottom: B.showDate ? 10 : 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              noTitle
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 6, right: 40),
                                      child: Text(Notes[reverseIndex]["title"],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18,
                                              color: Colors.white)),
                                    ),
                              Expanded(
                                flex: noTitle ? 3 : 2,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: noTitle ? 20.0 : 0),
                                  child: Text(
                                      noContent
                                          ? "Empty"
                                          : Notes[reverseIndex]["content"],
                                      maxLines: noTitle
                                          ? B.showDate
                                              ? 3
                                              : 4
                                          : B.showDate
                                              ? 2
                                              : 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: noContent
                                              ? Colors.white38
                                              : Colors.white,
                                          fontSize: noTitle ? 20 : 13)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              B.showDate
                                  ? Expanded(
                                      child: Stack(
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          Text(
                                            dateValue == 0
                                                ? "Today"
                                                : dateValue == -1
                                                    ? "Yesterday"
                                                    : date,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                Notes[reverseIndex]["edited"] ==
                                                        "yes"
                                                    ? "Edited"
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.white38),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ]),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: IconButton(
                      focusColor: Colors.blue,
                      onPressed: () async {
                        showDeleteDialog(index: reverseIndex, Notes: Notes);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 26,
                      )),
                ),
              ]),
            ),
          );
        }

        return Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar(context, "Notes", 65, leading()),
              SearchOn
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: TextFormField(
                            autofocus: true,
                            controller: searchC,
                            onChanged: searchNotes,
                            maxLines: 1,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(0)),
                              hintText: "Search",
                              filled: true,
                              fillColor: Theme.of(context).cardColor,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0)),
                            )),
                      ),
                    )
                  : Container(),
              B.notesMap.length != 0
                  ? B.viewIndex != 2
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: Notes.length,
                              itemBuilder: (context, index) {
                                int reverseIndex = Notes.length - index - 1;
                                B.notesMap[reverseIndex]["title"] == ""
                                    ? noTitle = true
                                    : noTitle = false;
                                B.notesMap[reverseIndex]["content"] == ""
                                    ? noContent = true
                                    : noContent = false;
                                int dateValue = B.calculateDifference(
                                    B.notesMap[reverseIndex]["time"]);
                                String date =
                                    B.parseDate(B.notesMap[reverseIndex]["time"]);
                                Widget chosenView = B.viewIndex == 0
                                    ? nListView(
                                        Notes, reverseIndex, dateValue, date)
                                    : nSmallListView(
                                        Notes, reverseIndex, dateValue, date);
                                return chosenView;
                              }),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          child: GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: Notes.length,
                              itemBuilder: (context, index) {
                                int reverseIndex = Notes.length - index - 1;
                                B.notesMap[reverseIndex]["title"] == ""
                                    ? noTitle = true
                                    : noTitle = false;
                                B.notesMap[reverseIndex]["content"] == ""
                                    ? noContent = true
                                    : noContent = false;
                                int dateValue = B.calculateDifference(
                                    B.notesMap[reverseIndex]["time"]);
                                String date =
                                    B.parseDate(B.notesMap[reverseIndex]["time"]);
                                return nGridView(
                                    Notes, reverseIndex, dateValue, date);
                              }),
                        )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 200),
                      child: Center(
                          child: Text(
                        "You don't have any notes",
                        style: TextStyle(
                            color: Colors.pink, fontWeight: FontWeight.w400),
                      )),
                    ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        );
      },
    );
  }
}

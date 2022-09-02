import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/Screens/Actions/EditNote.dart';
import 'package:notes/Screens/Actions/CreateNote.dart';
import 'package:notes/Screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool noTitle = false;
bool noContent = false;
Map<String, int> viewModes = {"Large View" : 0,"Long View" : 1,"Grid View" : 2};

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Widget leading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(builder: (context) => createNote()),
                )
                .then((_) => setState(() {}));
          },
          icon: Icon(
            Icons.add,
            size: 30,
          ),
        ),
        PopupMenuButton<String>(

          onSelected: (value) async{
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt("viewIndex", viewModes[value]!);
            setState(() {
              viewIndex = viewModes[value]!;
            });
            },
          itemBuilder: (BuildContext context) {
            return {"Large View","Long View","Grid View"}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice,style: TextStyle(fontWeight: FontWeight.w500 ),),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  Widget nListView(int reverseIndex, int dateValue, String date) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 8, vertical: showShadow ? 4 : 2),
        child: Stack(alignment: Alignment.topRight, children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EditNote(
                          Title: notesMap[reverseIndex]["title"],
                          Content: notesMap[reverseIndex]["content"],
                          index: notesMap[reverseIndex]['cindex'],
                        )))
                .then((value) => setState(() {})),
            child: Container(
              height: 300,
              width: 300,
              child: Card(
                color: colors[notesMap[reverseIndex]['cindex']],
                elevation: showShadow ? 4 : 0,
                shadowColor: colors[notesMap[reverseIndex]['cindex']],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                      top: 40,
                      bottom: showDate ? 15 : 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        noTitle
                            ? Container()
                            : Expanded(
                                flex: 2,
                                child: Text(notesMap[reverseIndex]["title"],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 24,
                                        color: Colors.white)),
                              ),
                        Expanded(
                          flex: 6,
                          child: Text(
                              noContent
                                  ? "Empty"
                                  : notesMap[reverseIndex]["content"],
                              maxLines: showDate ? 8 : 9,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:
                                      noContent ? Colors.white38 : Colors.white,
                                  fontSize: noTitle ? 21 : 16)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        showDate
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
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          notesMap[reverseIndex]["edited"] ==
                                                  "yes"
                                              ? "Edited"
                                              : "",
                                          style:
                                              TextStyle(color: Colors.white38),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: IconButton(
                focusColor: Colors.blue,
                onPressed: () async {
                  showDeleteDialog(index: reverseIndex);
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

  Widget nSmallListView(int reverseIndex, int dateValue, String date) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 8, vertical: showShadow ? 4 : 2),
        child: Stack(alignment: Alignment.topRight, children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EditNote(
                          Title: notesMap[reverseIndex]["title"],
                          Content: notesMap[reverseIndex]["content"],
                          index: notesMap[reverseIndex]['cindex'],
                        )))
                .then((value) => setState(() {})),
            child: Container(
              height: 110,
              width: 300,
              child: Card(
                color: colors[notesMap[reverseIndex]['cindex']],
                elevation: showShadow ? 4 : 0,
                shadowColor: colors[notesMap[reverseIndex]['cindex']],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15.0,
                      right: noTitle ? 30.0 : 20.0,
                      top: noTitle ? 14.0 : 12.0,
                      bottom: showDate ? 10 : 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        noTitle
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 6, right: 40),
                                child: Expanded(
                                  child: Text(notesMap[reverseIndex]["title"],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 24,
                                          color: Colors.white)),
                                ),
                              ),
                        Expanded(
                          flex: noTitle ? 2 : 1,
                          child: Text(
                              noContent
                                  ? "Empty"
                                  : notesMap[reverseIndex]["content"],
                              maxLines: noTitle
                                  ? showDate
                                      ? 2
                                      : 3
                                  : showDate
                                      ? 1
                                      : 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:
                                      noContent ? Colors.white38 : Colors.white,
                                  fontSize: noTitle ? 21 : 16)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        showDate
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
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          notesMap[reverseIndex]["edited"] ==
                                                  "yes"
                                              ? "Edited"
                                              : "",
                                          style:
                                              TextStyle(color: Colors.white38),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: IconButton(
                focusColor: Colors.blue,
                onPressed: () async {
                  showDeleteDialog(index: reverseIndex);
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

  Widget nGridView(int reverseIndex, int dateValue, String date) {
    return Center(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 0, vertical: showShadow ? 2 : 0),
        child: Stack(alignment: Alignment.topRight, children: [
          GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => EditNote(
                          Title: notesMap[reverseIndex]["title"],
                          Content: notesMap[reverseIndex]["content"],
                          index: notesMap[reverseIndex]['cindex'],
                        )))
                .then((value) => setState(() {})),
            child: Container(
              height: 180,
              width: 180,
              child: Card(
                color: colors[notesMap[reverseIndex]['cindex']],
                elevation: showShadow ? 4 : 0,
                shadowColor: colors[notesMap[reverseIndex]['cindex']],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15.0,
                      right: noTitle ? 38.0 : 20.0,
                      top: noTitle ? 14.0 : 14.0,
                      bottom: showDate ? 10 : 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        noTitle
                            ? Container()
                            : Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 6, right: 40),
                                child: Expanded(
                                  child: Text(notesMap[reverseIndex]["title"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          color: Colors.white)),
                                ),
                              ),
                        Expanded(
                          flex: noTitle ? 3 : 2,
                          child: Text(
                              noContent
                                  ? "Empty"
                                  : notesMap[reverseIndex]["content"],
                              maxLines: noTitle
                                  ? showDate
                                      ? 3
                                      : 4
                                  : showDate
                                      ? 3
                                      : 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color:
                                      noContent ? Colors.white38 : Colors.white,
                                  fontSize: noTitle ? 21 : 16)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        showDate
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
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          notesMap[reverseIndex]["edited"] ==
                                                  "yes"
                                              ? "Edited"
                                              : "",
                                          style:
                                              TextStyle(color: Colors.white38),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: IconButton(
                focusColor: Colors.blue,
                onPressed: () async {
                  showDeleteDialog(index: reverseIndex);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          customAppBar("Notes", leading()),
          notesMap.length != 0
              ? viewIndex != 2
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notesMap.length,
                      itemBuilder: (context, index) {
                        int reverseIndex = notesMap.length - index - 1;
                        notesMap[reverseIndex]["title"] == ""
                            ? noTitle = true
                            : noTitle = false;
                        notesMap[reverseIndex]["content"] == ""
                            ? noContent = true
                            : noContent = false;
                        int dateValue =
                            calculateDifference(notesMap[reverseIndex]["time"]);
                        String date = parseDate(notesMap[reverseIndex]["time"]);
                        Widget chosenView = viewIndex == 0
                            ? nListView(reverseIndex, dateValue, date)
                            : nSmallListView(reverseIndex, dateValue, date);
                        return chosenView;
                      })
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 2),
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notesMap.length,
                          itemBuilder: (context, index) {
                            int reverseIndex = notesMap.length - index - 1;
                            notesMap[reverseIndex]["title"] == ""
                                ? noTitle = true
                                : noTitle = false;
                            notesMap[reverseIndex]["content"] == ""
                                ? noContent = true
                                : noContent = false;
                            int dateValue = calculateDifference(
                                notesMap[reverseIndex]["time"]);
                            String date =
                                parseDate(notesMap[reverseIndex]["time"]);
                            return nGridView(reverseIndex, dateValue, date);
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
  }

  int calculateDifference(String stringDate) {
    var date = DateTime.parse(stringDate);
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  String parseDate(String stringDate) {
    var date = DateTime.parse(stringDate);
    String parsedDate = DateFormat.MMMMd().format(date);
    return parsedDate;
  }

  Future<void> showDeleteDialog({required int index}) async {
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
                  await deleteFromDatabase(id: notesMap[index]["id"]);
                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: Text("Yes"))
          ],
        );
      },
    );
  }
}
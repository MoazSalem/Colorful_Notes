import 'package:flutter/material.dart';
import 'package:notes/Screens/Actions/EditNote.dart';
import 'package:notes/Screens/Actions/CreateNote.dart';
import 'package:notes/Screens/HomeScreen.dart';

bool isGrid = false;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget NlistView(int reverseIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          child: Card(
            color: colors[notesMap[reverseIndex]['cindex']],
            elevation: 4,
            shadowColor: colors[notesMap[reverseIndex]['cindex']],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60, left: 10, right: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Text(notesMap[reverseIndex]["title"],
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.white)),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(notesMap[reverseIndex]["content"],
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white)),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 113),
                    child: Text(
                      notesMap[reverseIndex]["time"],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
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
    );
  }

  Widget NgridView(int reverseIndex) {
    return Stack(alignment: Alignment.topRight, children: [
      GestureDetector(
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => EditNote(
                      Title: notesMap[reverseIndex]["title"],
                      Content: notesMap[reverseIndex]["content"],
                      index: notesMap[reverseIndex]['cindex'],
                    )))
            .then((value) => setState(() {})),
        child: SizedBox(
          height: 200,
          width: 200,
          child: Card(
            color: colors[notesMap[reverseIndex]['cindex']],
            elevation: 2,
            shadowColor: colors[notesMap[reverseIndex]['cindex']],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 17),
                  child: Text(
                    notesMap[reverseIndex]["title"],
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(notesMap[reverseIndex]["content"],
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white)),
              ]),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          elevation: 6,
          backgroundColor: Colors.amber,
          onPressed: () => Navigator.of(context)
              .push(
                MaterialPageRoute(builder: (context) => createNote()),
              )
              .then((_) => setState(() {})),
          child: const Icon(Icons.add)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 40, top: 60),
            child: Row(
              children: [
                Text(
                  "Notes",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, top: 6),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          isGrid = !isGrid;
                        });
                      },
                      icon: !isGrid
                          ? Icon(
                              Icons.grid_view_rounded,
                              size: 30,
                            )
                          : Icon(Icons.featured_play_list_rounded, size: 30)),
                )
              ],
            ),
          ),
          notesMap.length != 0
              ? !isGrid
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notesMap.length,
                      itemBuilder: (context, index) {
                        int reverseIndex = notesMap.length - index - 1;
                        return NlistView(reverseIndex);
                      })
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
                            return NgridView(reverseIndex);
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

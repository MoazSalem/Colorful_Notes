import 'package:flutter/material.dart';
import 'package:notes/Screens/Actions/EditNote.dart';
import 'package:notes/Screens/Actions/CreateNote.dart';
import 'package:notes/Screens/HomeScreen.dart';

class HomePageT extends StatefulWidget {
  const HomePageT({Key? key}) : super(key: key);

  @override
  State<HomePageT> createState() => _HomePageTState();
}

class _HomePageTState extends State<HomePageT> {
  Widget NgridView(int reverseIndex) {
    return Center(
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
          child: SizedBox(
            height: 400,
            width: 400,
            child: Card(
              color: colors[notesMap[reverseIndex]['cindex']],
              elevation: 2,
              shadowColor: colors[notesMap[reverseIndex]['cindex']],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20),
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      notesMap[reverseIndex]["title"],
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 28,
                          color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(notesMap[reverseIndex]["content"],
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white,fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.only(right: 100,top: 20),
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
          padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 20),
          child: IconButton(
              focusColor: Colors.blue,
              onPressed: () async {
                showDeleteDialog(index: reverseIndex);
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 46,
              )),
        ),
      ]),
    );
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
            padding: const EdgeInsets.only(left: 60, bottom: 60, top: 60),
            child: Row(
              children: [
                Text(
                  "Notes",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          notesMap.length != 0
              ?  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Center(
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
                      ),
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

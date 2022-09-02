import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/Screens/HomeScreen.dart';

final TextEditingController titleC = TextEditingController();
final TextEditingController contentC = TextEditingController();
late String title;
late String content;
late String time;
late int Index;
int chosenIndex = 0;

class createNote extends StatefulWidget {
  createNote({
    Key? key,
  }) : super(key: key);

  @override
  State<createNote> createState() => _CreatNoteState();
}

class _CreatNoteState extends State<createNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[chosenIndex],
      body: SafeArea(
          child: ListView(children: [
        SizedBox(
          height: 60,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              controller: titleC,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w500),
              decoration:
                  InputDecoration(border: InputBorder.none, hintText: "Title")),
        ),
        SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
              textInputAction: TextInputAction.done,
              controller: contentC,
              maxLines: 16,
              showCursor: true,
              style: TextStyle(color: Colors.white, fontSize: 30),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  constraints: BoxConstraints.expand(height: 450, width: 200),
                  hintText: "Write Your Note Here")),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            height: 60,
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                itemBuilder: (BuildContext context, Index) => GestureDetector(
                  onTap: () {
                    chosenIndex = Index;
                    setState(() {});
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: colors[Index],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: TextButton(
            onPressed: () async {
              time = DateTime.now().toString();
              title = titleC.text;
              content = contentC.text;
              titleC.text != "" || contentC.text != ""
                  ? {
                      await insertToDatabase(
                          title: title,
                          time: time,
                          content: content,
                          index: chosenIndex),
                      titleC.text = "",
                      contentC.text = "",
                      Navigator.pop(context)
                    }
                  : Navigator.pop(context);
            },
            child: Text(
              "Done",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        )
      ])),
    );
  }
}

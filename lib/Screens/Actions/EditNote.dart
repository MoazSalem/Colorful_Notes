import 'package:flutter/material.dart';
import 'package:notes/Screens/HomeScreen.dart';

final TextEditingController titleC = TextEditingController();
final TextEditingController contentC = TextEditingController();
late int Index;
int chosenIndex = 0;

class EditNote extends StatefulWidget {
  String Title = "";
  String Content = "";
  int index = 0;

  EditNote(
      {Key? key,
      required this.Title,
      required this.Content,
      required this.index})
      : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  @override
  void initState() {
    super.initState();
    titleC.text = widget.Title;
    contentC.text = widget.Content;
    Index = widget.index;
    chosenIndex = Index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors[chosenIndex],
      body: SafeArea(
          child: ListView(children: [
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
            maxLines: 2,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              controller: titleC,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: "No Title")),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: TextFormField(
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              controller: contentC,
              maxLines: 15,
              showCursor: true,
              style: TextStyle(color: Colors.white, fontSize: 24),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  constraints: BoxConstraints.expand(height: 460, width: 200),
                  hintText: "Write Your Note Here")),
        ),
        FittedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 20),
          child: TextButton(
            onPressed: () async {
              var time = DateTime.now().toString();
              titleC.text != widget.Title ||
                      contentC.text != widget.Content ||
                      chosenIndex != widget.index
                  ? {
                      await editDatabaseItem(
                          time: "$time",
                          content: contentC.text,
                          title: widget.Title,
                          title2: titleC.text,
                          index: chosenIndex),
                      Navigator.of(context).pop(),
                    }
                  : Navigator.of(context).pop();
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';

final TextEditingController titleC = TextEditingController();
final TextEditingController contentC = TextEditingController();
late int Index;

Widget EditNote(BuildContext context,
    {required String Title,
    required String Content,
    required int index,
    required int ID}) {
  titleC.text = Title;
  contentC.text = Content;
  int bIndex = index;
  return BlocConsumer<NotesBloc, NotesState>(
    listener: (context, state) {
      // TODO: implement listener
    },
    builder: (context, state) {
      var B = NotesBloc.get(context);
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: B.colors[bIndex],
        body: SafeArea(
            child: ListView(children: [
          SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
                onSaved: B.onViewChanged(),
                maxLines: 2,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                controller: titleC,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: B.isTablet ? 60 : 36,
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
                onSaved: B.onSearch(),
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                controller: contentC,
                maxLines: B.isTablet ? 20 : 15,
                showCursor: true,
                style: TextStyle(
                    color: Colors.white, fontSize: B.isTablet ? 40 : 24),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    constraints: BoxConstraints.expand(
                        height: B.isTablet ? 800 : 460, width: 200),
                    hintText: "Write Your Note Here")),
          ),
          FittedBox(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: B.isTablet ? 100 : 20.0),
              child: Container(
                height: 60,
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: B.colors.length,
                    itemBuilder: (BuildContext context, Index) =>
                        GestureDetector(
                      onTap: () {
                        bIndex = Index;
                        B.ColorChanged(Index);
                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: B.colors[Index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: TextButton(
              onPressed: () async {
                var time = DateTime.now().toString();
                titleC.text != Title ||
                        contentC.text != Content ||
                        bIndex != index
                    ? {
                        await B.editDatabaseItem(
                            time: "$time",
                            content: contentC.text,
                            id: ID,
                            title2: titleC.text,
                            index: B.chosenIndex,
                            type: 0),
                        Navigator.of(context).pop(),
                        B.onCreateNote()
                      }
                    : Navigator.of(context).pop();
              },
              child: Text("Done",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          )
        ])),
      );
    },
  );
}

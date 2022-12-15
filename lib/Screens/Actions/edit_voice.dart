import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';

final TextEditingController titleC = TextEditingController();
final TextEditingController contentC = TextEditingController();

Widget editVoice({required Map note}) {
  titleC.text = note["title"];
  int bIndex = note["cindex"];
  return BlocConsumer<NotesBloc, NotesState>(
    listener: (context, state) {},
    builder: (context, state) {
      var B = NotesBloc.get(context);
      return Container(
        color: B.colors[bIndex],
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            height: B.isTablet ? 50 : 30,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 80 : 40),
            child: TextFormField(
                onSaved: B.onViewChanged(),
                maxLines: 2,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                controller: titleC,
                style: TextStyle(color: Colors.white, fontSize: B.isTablet ? 60 : 36, fontWeight: FontWeight.w500),
                decoration: InputDecoration(border: InputBorder.none, hintText: "No Title".tr())),
          ),
          SizedBox(
            height: B.isTablet ? 40 : 10,
          ),
          Column(
            children: [
              FittedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 100 : 20.0),
                  child: SizedBox(
                    height: 65,
                    child: Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, index2) => GestureDetector(
                          onTap: () {
                            bIndex = index2;
                            B.onColorChanged();
                          },
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: bIndex == index2 ? Colors.white : Colors.white54,
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: B.colors[index2],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: FittedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 100 : 20.0),
                    child: SizedBox(
                      height: 65,
                      child: Center(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, index3) => GestureDetector(
                            onTap: () {
                              index3 += 5;
                              bIndex = index3;
                              B.onColorChanged();
                            },
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: bIndex == (index3 + 5) ? Colors.white : Colors.white54,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: B.colors[index3 + 5],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 50 : 30),
                    child: TextButton(
                      onPressed: () {
                        titleC.clear();
                        contentC.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Discard".tr(),
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 60 : 40),
                    child: TextButton(
                      onPressed: () async {
                        var time = DateTime.now().toString();
                        titleC.text != note["title"]
                            ? {
                                await B.insertToDatabase(title: titleC.text, time: time, content: note["content"], index: bIndex, type: 1, edited: 'yes', layout: note['layout']),
                                await B.deleteFromDatabase(id: note["id"]),
                                Navigator.of(context).pop(),
                                B.onCreateNote()
                              }
                            : bIndex != note["cindex"]
                                ? {
                                    await B.editDatabaseItem(
                                        time: note['time'], content: note['content'], id: note["id"], title: note['title'], index: bIndex, type: 1, edited: 'no', layout: note['layout']),
                                    Navigator.of(context).pop(),
                                    B.onCreateNote()
                                  }
                                : Navigator.of(context).pop();
                      },
                      child: Text(
                        "Save".tr(),
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      );
    },
  );
}

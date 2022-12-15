import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';

final TextEditingController titleC = TextEditingController();
final TextEditingController contentC = TextEditingController();
bool isEditing = false;

Widget editNote({required Map note}) {
  titleC.text = note["title"];
  contentC.text = note["content"];
  int bIndex = note["cindex"];
  return BlocConsumer<NotesBloc, NotesState>(
    listener: (context, state) {},
    builder: (context, state) {
      var B = NotesBloc.get(context);
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: B.colors[bIndex],
        body: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      flex: B.isTablet ? 8 : 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                              onPressed: () {
                                titleC.clear();
                                contentC.clear();
                                isEditing = false;
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                size: 40,
                                color: Colors.white,
                              )),
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                        constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                        onPressed: isEditing
                            ? () async {
                                var time = DateTime.now().toString();
                                titleC.text != note["title"] || contentC.text != note["content"]
                                    ? {
                                        await B.detectLanguage("${titleC.text} ${contentC.text}"),
                                        await B.insertToDatabase(title: titleC.text, time: time, content: contentC.text, index: bIndex, edited: 'yes', layout: B.detectedLanguage == 'ar' ? 1 : 0),
                                        await B.deleteFromDatabase(id: note["id"]),
                                        isEditing = false,
                                        B.onCreateNote(),
                                      }
                                    : bIndex != note["cindex"]
                                        ? {
                                            await B.editDatabaseItem(
                                                time: note['time'], content: note['content'], id: note["id"], title: note['title'], index: bIndex, type: 0, edited: 'no', layout: note['layout']),
                                            isEditing = false,
                                            B.onCreateNote()
                                          }
                                        : {isEditing = false, B.onCreateNote()};
                              }
                            : () {
                                isEditing = true;
                                B.onCreateNote();
                              },
                        icon: Icon(
                          isEditing ? Icons.done : Icons.edit_note,
                          size: 40,
                          color: Colors.white,
                        )),
                  )
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: B.isTablet ? 8 : 4,
                      child: ListView(children: [
                        Padding(
                          padding: isEditing
                              ? B.lang == 'en'
                                  ? EdgeInsets.only(left: B.isTablet ? 60 : 20)
                                  : EdgeInsets.only(right: B.isTablet ? 60 : 20)
                              : EdgeInsets.symmetric(horizontal: B.isTablet ? 60 : 20),
                          child: TextFormField(
                              textDirection: note['layout'] == 0 ? TextDirection.ltr : TextDirection.rtl,
                              onSaved: B.onViewChanged(),
                              maxLines: 2,
                              cursorColor: Colors.white,
                              readOnly: isEditing ? false : true,
                              textInputAction: TextInputAction.done,
                              controller: titleC,
                              style: TextStyle(color: Colors.white, fontSize: B.isTablet ? 60 : 36, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(border: InputBorder.none, hintText: "No Title".tr())),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: isEditing
                              ? B.lang == 'en'
                                  ? EdgeInsets.only(left: B.isTablet ? 60 : 20)
                                  : EdgeInsets.only(right: B.isTablet ? 60 : 20)
                              : EdgeInsets.symmetric(horizontal: B.isTablet ? 60 : 20),
                          child: TextFormField(
                              textDirection: note['layout'] == 0 ? TextDirection.ltr : TextDirection.rtl,
                              onSaved: B.onSearch(),
                              cursorColor: Colors.white,
                              controller: contentC,
                              readOnly: isEditing ? false : true,
                              maxLines: 20,
                              style: TextStyle(color: Colors.white, fontSize: B.isTablet ? 40 : 24),
                              decoration: InputDecoration(border: InputBorder.none, hintText: "Content".tr())),
                        ),
                      ]),
                    ),
                    isEditing
                        ? Expanded(
                            flex: 1,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: B.colors.length,
                              itemBuilder: (BuildContext context, index2) => GestureDetector(
                                onTap: () {
                                  bIndex = index2;
                                  B.onColorChanged();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: bIndex == index2 ? Colors.white : Colors.white54,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: B.colors[index2],
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

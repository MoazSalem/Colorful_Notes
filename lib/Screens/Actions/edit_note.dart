import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:notes/Bloc/notes_bloc.dart';

final TextEditingController titleC = TextEditingController();
final TextEditingController contentC = TextEditingController();
late ValueNotifier<TextDirection> _titleDir;
late ValueNotifier<TextDirection> _contentDir;
bool isEditing = false;

Widget editNote({required Map note}) {
  titleC.text = note["title"];
  contentC.text = note["content"];
  int bIndex = note["cindex"];
  _titleDir = note["layout"] == 0 || note["layout"] == 2
      ? ValueNotifier(TextDirection.ltr)
      : ValueNotifier(TextDirection.rtl);
  _contentDir = note["layout"] == 0 || note["layout"] == 3
      ? ValueNotifier(TextDirection.ltr)
      : ValueNotifier(TextDirection.rtl);
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                titleC.clear();
                                contentC.clear();
                                isEditing = false;
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.black54,
                                radius: 25,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: B.colors[bIndex],
                                  size: 36,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        onTap: isEditing
                            ? () async {
                                var time = DateTime.now().toString();
                                titleC.text != note["title"] || contentC.text != note["content"]
                                    ? {
                                        await B.insertToDatabase(
                                            title: titleC.text,
                                            time: time,
                                            content: contentC.text,
                                            index: bIndex,
                                            edited: 'yes',
                                            layout: getLayout()),
                                        await B.deleteFromDatabase(id: note["id"]),
                                        isEditing = false,
                                        B.onCreateNote(),
                                      }
                                    : bIndex != note["cindex"]
                                        ? {
                                            await B.editDatabaseItem(
                                                time: note['time'],
                                                content: note['content'],
                                                id: note["id"],
                                                title: note['title'],
                                                index: bIndex,
                                                type: 0,
                                                edited: 'no',
                                                layout: note['layout']),
                                            isEditing = false,
                                            B.onCreateNote()
                                          }
                                        : {isEditing = false, B.onCreateNote()};
                              }
                            : () {
                                isEditing = true;
                                B.onCreateNote();
                              },
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 25,
                          child: Icon(
                            isEditing ? Icons.done : Icons.edit_note,
                            color: B.colors[bIndex],
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
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
                          child: ValueListenableBuilder<TextDirection>(
                            valueListenable: _titleDir,
                            builder: (context, value, child) => TextFormField(
                                textDirection: value,
                                onChanged: (input) {
                                  if (input.trim().length < 2) {
                                    final dir = B.getDirection(input);
                                    if (dir != value) _titleDir.value = dir;
                                  }
                                },
                                onSaved: B.onViewChanged(),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                cursorColor: Colors.white,
                                readOnly: isEditing ? false : true,
                                textInputAction: TextInputAction.done,
                                controller: titleC,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: B.isTablet ? 60 : 36,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "No Title".tr(),
                                    hintStyle: const TextStyle(color: Colors.black54))),
                          ),
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
                          child: ValueListenableBuilder<TextDirection>(
                            valueListenable: _contentDir,
                            builder: (context, value, child) => TextFormField(
                                textDirection: value,
                                onChanged: (input) {
                                  if (input.trim().length < 2) {
                                    final dir = B.getDirection(input);
                                    if (dir != value) _contentDir.value = dir;
                                  }
                                },
                                onSaved: B.onSearch(),
                                cursorColor: Colors.white,
                                controller: contentC,
                                readOnly: isEditing ? false : true,
                                maxLines: 20,
                                style:
                                    TextStyle(color: Colors.white, fontSize: B.isTablet ? 40 : 24),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Content".tr(),
                                    hintStyle: const TextStyle(color: Colors.black54))),
                          ),
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
                                    backgroundColor:
                                        bIndex == index2 ? Colors.white : Colors.white54,
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

int getLayout() {
  int layout = 0;
  if (_titleDir.value == TextDirection.ltr && _contentDir.value == TextDirection.ltr) {
    layout = 0;
  } else if (_titleDir.value == TextDirection.rtl && _contentDir.value == TextDirection.rtl) {
    layout = 1;
  } else if (_titleDir.value == TextDirection.ltr && _contentDir.value == TextDirection.rtl) {
    if (titleC.text == "") {
      layout = 1;
    } else {
      layout = 2;
    }
  } else {
    if (contentC.text == "") {
      layout = 1;
    } else {
      layout = 3;
    }
  }
  return layout;
}

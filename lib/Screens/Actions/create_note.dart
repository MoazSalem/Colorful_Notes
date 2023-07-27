import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/main.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({Key? key}) : super(key: key);

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final TextEditingController titleC = TextEditingController();
  final TextEditingController contentC = TextEditingController();
  late ValueNotifier<TextDirection> titleDir;
  late ValueNotifier<TextDirection> contentDir;
  late String title;
  late String content;
  late String time;
  int chosenIndex = 0;

  @override
  void initState() {
    titleDir = ValueNotifier(TextDirection.ltr);
    contentDir = ValueNotifier(TextDirection.ltr);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: B.colors[chosenIndex],
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
                                onTap: () async {
                                  titleC.clear();
                                  contentC.clear();
                                  chosenIndex = 0;
                                  Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.black54,
                                  radius: 25,
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: B.colors[chosenIndex],
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
                          onTap: () async {
                            time = DateTime.now().toString();
                            title = titleC.text;
                            content = contentC.text;
                            titleC.text != "" || contentC.text != ""
                                ? {
                                    await B.insertToDatabase(
                                        title: title,
                                        time: time,
                                        content: content,
                                        index: chosenIndex,
                                        layout: getLayout()),
                                    titleC.text = "",
                                    contentC.text = "",
                                    B.onCreateNote(),
                                    Navigator.pop(context),
                                    B.onCreateNote()
                                  }
                                : Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25,
                            child: Icon(
                              Icons.done,
                              color: B.colors[chosenIndex],
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
                            padding: B.lang == 'en'
                                ? EdgeInsets.only(left: B.isTablet ? 60 : 20)
                                : EdgeInsets.only(right: B.isTablet ? 60 : 20),
                            child: ValueListenableBuilder<TextDirection>(
                              valueListenable: titleDir,
                              builder: (context, value, child) => TextFormField(
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  textDirection: value,
                                  onChanged: (input) {
                                    if (input.trim().length < 2) {
                                      final dir = B.getDirection(input);
                                      if (dir != value) titleDir.value = dir;
                                    }
                                  },
                                  cursorColor: Colors.white,
                                  autofocus: true,
                                  textInputAction: TextInputAction.done,
                                  controller: titleC,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: B.isTablet ? 60 : 36,
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Title".tr(),
                                      hintStyle: const TextStyle(color: Colors.black54))),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: B.lang == 'en'
                                ? EdgeInsets.only(left: B.isTablet ? 60 : 20)
                                : EdgeInsets.only(right: B.isTablet ? 60 : 20),
                            child: ValueListenableBuilder<TextDirection>(
                              valueListenable: contentDir,
                              builder: (context, value, child) => TextFormField(
                                  textDirection: value,
                                  onChanged: (input) {
                                    if (input.trim().length < 2) {
                                      final dir = B.getDirection(input);
                                      if (dir != value) contentDir.value = dir;
                                    }
                                  },
                                  cursorColor: Colors.white,
                                  controller: contentC,
                                  maxLines: 20,
                                  showCursor: true,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: B.isTablet ? 40 : 24),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Content".tr(),
                                      hintStyle: const TextStyle(color: Colors.black54))),
                            ),
                          ),
                        ]),
                      ),
                      Expanded(
                          flex: 1,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: B.colors.length,
                            itemBuilder: (BuildContext context, index) => GestureDetector(
                              onTap: () {
                                chosenIndex = index;
                                B.onColorChanged();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      chosenIndex == index ? Colors.white : Colors.white54,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: B.colors[index],
                                  ),
                                ),
                              ),
                            ),
                          ))
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
    if (titleDir.value == TextDirection.ltr && contentDir.value == TextDirection.ltr) {
      layout = 0;
    } else if (titleDir.value == TextDirection.rtl && contentDir.value == TextDirection.rtl) {
      layout = 1;
    } else if (titleDir.value == TextDirection.ltr && contentDir.value == TextDirection.rtl) {
      if (title == "") {
        layout = 1;
      } else {
        layout = 2;
      }
    } else {
      if (content == "") {
        layout = 1;
      } else {
        layout = 3;
      }
    }
    return layout;
  }
}

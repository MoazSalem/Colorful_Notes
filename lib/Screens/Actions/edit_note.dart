import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:notes/Bloc/notes_bloc.dart';

class EditNote extends StatefulWidget {
  final Map note;

  const EditNote({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final TextEditingController titleC = TextEditingController();
  final TextEditingController contentC = TextEditingController();
  late ValueNotifier<TextDirection> _titleDir;
  late ValueNotifier<TextDirection> _contentDir;
  late int bIndex;
  late NotesBloc B;
  bool isEditing = false;

  @override
  void initState() {
    B = NotesBloc.get(context);
    titleC.text = widget.note["title"];
    contentC.text = widget.note["content"];
    bIndex = widget.note["cindex"];
    _titleDir = widget.note["layout"] == 0 || widget.note["layout"] == 2
        ? ValueNotifier(TextDirection.ltr)
        : ValueNotifier(TextDirection.rtl);
    _contentDir = widget.note["layout"] == 0 || widget.note["layout"] == 3
        ? ValueNotifier(TextDirection.ltr)
        : ValueNotifier(TextDirection.rtl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
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
                                  titleC.text != widget.note["title"] ||
                                          contentC.text != widget.note["content"]
                                      ? {
                                          await B.insertToDatabase(
                                              title: titleC.text,
                                              time: time,
                                              content: contentC.text,
                                              index: bIndex,
                                              edited: 'yes',
                                              layout: getLayout()),
                                          await B.deleteFromDatabase(id: widget.note["id"]),
                                          isEditing = false,
                                          B.onCreateNote(),
                                        }
                                      : bIndex != widget.note["cindex"]
                                          ? {
                                              await B.editDatabaseItem(
                                                  time: widget.note['time'],
                                                  content: widget.note['content'],
                                                  id: widget.note["id"],
                                                  title: widget.note['title'],
                                                  index: bIndex,
                                                  type: 0,
                                                  edited: 'no',
                                                  layout: widget.note['layout']),
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
}

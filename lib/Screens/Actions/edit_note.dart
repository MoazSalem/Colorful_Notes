import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes/Cubit/notes_cubit.dart';
import 'package:notes/main.dart';

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
  late int textColor;
  bool isEditing = false;
  late Color pickerColor;
  late Color currentColor;

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    titleC.text = widget.note["title"];
    contentC.text = widget.note["content"];
    bIndex = widget.note["cindex"];
    textColor = widget.note['tindex'];
    _titleDir = widget.note["layout"] == 0 || widget.note["layout"] == 2
        ? ValueNotifier(TextDirection.ltr)
        : ValueNotifier(TextDirection.rtl);
    _contentDir = widget.note["layout"] == 0 || widget.note["layout"] == 3
        ? ValueNotifier(TextDirection.ltr)
        : ValueNotifier(TextDirection.rtl);
    if (bIndex == 99) {
      pickerColor = Color(int.parse(widget.note['extra']));
      currentColor = Color(int.parse(widget.note['extra']));
    } else {
      pickerColor = const Color(0xfffdcb71);
      currentColor = const Color(0xfffdcb71);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: bIndex == 99 ? pickerColor : C.colors[bIndex],
          body: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: C.isTablet ? 8 : 4,
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
                                  backgroundColor: textColor == 0 ? Colors.white54 : Colors.black54,
                                  radius: 25,
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: bIndex == 99 ? pickerColor : C.colors[bIndex],
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
                                          await C.insertToDatabase(
                                              title: titleC.text,
                                              time: time,
                                              content: contentC.text,
                                              index: bIndex,
                                              tIndex: textColor,
                                              extra:
                                                  bIndex == 99 ? pickerColor.value.toString() : "",
                                              edited: 'yes',
                                              layout: getLayout()),
                                          await C.deleteFromDatabase(id: widget.note["id"]),
                                          isEditing = false,
                                          C.onCreateNote(),
                                        }
                                      : bIndex != widget.note["cindex"] ||
                                              textColor != widget.note['tindex'] ||
                                              bIndex == 99
                                          ? {
                                              await C.editDatabaseItem(
                                                  time: widget.note['time'],
                                                  content: widget.note['content'],
                                                  id: widget.note["id"],
                                                  title: widget.note['title'],
                                                  index: bIndex,
                                                  tIndex: textColor,
                                                  extra: bIndex == 99
                                                      ? pickerColor.value.toString()
                                                      : "",
                                                  type: 0,
                                                  edited: 'no',
                                                  layout: widget.note['layout']),
                                              isEditing = false,
                                              C.onCreateNote()
                                            }
                                          : {isEditing = false, C.onCreateNote()};
                                }
                              : () {
                                  isEditing = true;
                                  C.onCreateNote();
                                },
                          child: CircleAvatar(
                            backgroundColor: textColor == 0 ? Colors.white : Colors.black,
                            radius: 25,
                            child: Icon(
                              isEditing ? Icons.done : Icons.edit_note,
                              color: bIndex == 99 ? pickerColor : C.colors[bIndex],
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
                        flex: C.isTablet ? 8 : 4,
                        child: ListView(children: [
                          Padding(
                            padding: isEditing
                                ? C.lang == 'en'
                                    ? EdgeInsets.only(left: C.isTablet ? 60 : 20)
                                    : EdgeInsets.only(right: C.isTablet ? 60 : 20)
                                : EdgeInsets.symmetric(horizontal: C.isTablet ? 60 : 20),
                            child: ValueListenableBuilder<TextDirection>(
                              valueListenable: _titleDir,
                              builder: (context, value, child) => TextFormField(
                                  textDirection: value,
                                  onChanged: (input) {
                                    if (input.trim().length < 2) {
                                      final dir = C.getDirection(input);
                                      if (dir != value) _titleDir.value = dir;
                                    }
                                  },
                                  onSaved: C.onViewChanged(),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  cursorColor: textColor == 0 ? Colors.white : Colors.black,
                                  readOnly: isEditing ? false : true,
                                  textInputAction: TextInputAction.done,
                                  controller: titleC,
                                  style: TextStyle(
                                      color: textColor == 0 ? Colors.white : Colors.black,
                                      fontSize: C.isTablet ? 60 : 36,
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "No Title".tr(),
                                      hintStyle: TextStyle(
                                          color:
                                              textColor == 0 ? Colors.white54 : Colors.black54))),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: isEditing
                                ? C.lang == 'en'
                                    ? EdgeInsets.only(left: C.isTablet ? 60 : 20)
                                    : EdgeInsets.only(right: C.isTablet ? 60 : 20)
                                : EdgeInsets.symmetric(horizontal: C.isTablet ? 60 : 20),
                            child: ValueListenableBuilder<TextDirection>(
                              valueListenable: _contentDir,
                              builder: (context, value, child) => TextFormField(
                                  textDirection: value,
                                  onChanged: (input) {
                                    if (input.trim().length < 2) {
                                      final dir = C.getDirection(input);
                                      if (dir != value) _contentDir.value = dir;
                                    }
                                  },
                                  onSaved: C.onSearch(),
                                  cursorColor: textColor == 0 ? Colors.white : Colors.black,
                                  controller: contentC,
                                  readOnly: isEditing ? false : true,
                                  maxLines: 20,
                                  style: TextStyle(
                                      color: textColor == 0 ? Colors.white : Colors.black,
                                      fontSize: C.isTablet ? 40 : 24),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Content".tr(),
                                      hintStyle: TextStyle(
                                          color:
                                              textColor == 0 ? Colors.white54 : Colors.black54))),
                            ),
                          ),
                        ]),
                      ),
                      isEditing
                          ? Expanded(
                              flex: 1,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: C.colors.length,
                                itemBuilder: (BuildContext context, index2) => index2 == 0
                                    ? Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              textColor = textColor == 0 ? 1 : 0;
                                              C.onColorChanged();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Text(
                                                "Ab".tr(),
                                                style: TextStyle(
                                                    color: textColor == 0
                                                        ? Colors.white
                                                        : Colors.black,
                                                    fontSize: C.isTablet ? 40 : 24,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              bIndex = 99;
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) => AlertDialog(
                                                  title: const Text('Choose Color'),
                                                  content: SingleChildScrollView(
                                                    child: ColorPicker(
                                                      pickerColor: pickerColor,
                                                      onColorChanged: changeColor,
                                                      enableAlpha: false,
                                                      hexInputBar: true,
                                                      paletteType: PaletteType.hueWheel,
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    ElevatedButton(
                                                      child: const Text('Done'),
                                                      onPressed: () {
                                                        setState(() => currentColor = pickerColor);
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: bIndex == 99
                                                    ? textColor == 0
                                                        ? Colors.white
                                                        : Colors.black
                                                    : textColor == 0
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                child:
                                                    Stack(alignment: Alignment.center, children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundColor: pickerColor,
                                                  ),
                                                  Text(
                                                    "#",
                                                    style: TextStyle(
                                                        color: textColor == 0
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 26),
                                                  )
                                                ]),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              bIndex = index2;
                                              C.onColorChanged();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: bIndex == index2
                                                    ? textColor == 0
                                                        ? Colors.white
                                                        : Colors.black
                                                    : textColor == 0
                                                        ? Colors.white54
                                                        : Colors.black54,
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: C.colors[index2],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          bIndex = index2;
                                          C.onColorChanged();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: bIndex == index2
                                                ? textColor == 0
                                                    ? Colors.white
                                                    : Colors.black
                                                : textColor == 0
                                                    ? Colors.white54
                                                    : Colors.black54,
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: C.colors[index2],
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

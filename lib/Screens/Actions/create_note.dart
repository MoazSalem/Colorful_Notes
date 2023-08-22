import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes/Cubit/notes_cubit.dart';
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
  int textColor = 0;
  int chosenIndex = 0;
  Color pickerColor = const Color(0xfffdcb71);
  Color currentColor = const Color(0xfffdcb71);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    titleDir = ValueNotifier(TextDirection.ltr);
    contentDir = ValueNotifier(TextDirection.ltr);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: chosenIndex == 99 ? pickerColor : C.colors[chosenIndex],
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
                                onTap: () async {
                                  titleC.clear();
                                  contentC.clear();
                                  chosenIndex = 0;
                                  Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  backgroundColor: textColor == 0 ? Colors.white54 : Colors.black54,
                                  radius: 25,
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: chosenIndex == 99 ? pickerColor : C.colors[chosenIndex],
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
                                    await C.insertToDatabase(
                                        title: title,
                                        time: time,
                                        content: content,
                                        index: chosenIndex,
                                        tIndex: textColor,
                                        extra: chosenIndex == 99 ? pickerColor.value.toString() : "",
                                        layout: getLayout()),
                                    titleC.text = "",
                                    contentC.text = "",
                                    C.onCreateNote(),
                                    Navigator.pop(context)
                                  }
                                : Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: textColor == 0 ? Colors.white : Colors.black,
                            radius: 25,
                            child: Icon(
                              Icons.done,
                              color: chosenIndex == 99 ? pickerColor : C.colors[chosenIndex],
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
                            padding: C.lang == 'en'
                                ? EdgeInsets.only(left: C.isTablet ? 60 : 20)
                                : EdgeInsets.only(right: C.isTablet ? 60 : 20),
                            child: ValueListenableBuilder<TextDirection>(
                              valueListenable: titleDir,
                              builder: (context, value, child) => TextFormField(
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  textDirection: value,
                                  onChanged: (input) {
                                    if (input.trim().length < 2) {
                                      final dir = C.getDirection(input);
                                      if (dir != value) titleDir.value = dir;
                                    }
                                  },
                                  cursorColor: textColor == 0 ? Colors.white : Colors.black,
                                  autofocus: true,
                                  textInputAction: TextInputAction.done,
                                  controller: titleC,
                                  style: TextStyle(
                                      color: textColor == 0 ? Colors.white : Colors.black,
                                      fontSize: C.isTablet ? 60 : 36,
                                      fontWeight: FontWeight.w500),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Title".tr(),
                                      hintStyle: TextStyle(
                                          color:
                                              textColor == 0 ? Colors.white54 : Colors.black54))),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: C.lang == 'en'
                                ? EdgeInsets.only(left: C.isTablet ? 60 : 20)
                                : EdgeInsets.only(right: C.isTablet ? 60 : 20),
                            child: ValueListenableBuilder<TextDirection>(
                              valueListenable: contentDir,
                              builder: (context, value, child) => TextFormField(
                                  textDirection: value,
                                  onChanged: (input) {
                                    if (input.trim().length < 2) {
                                      final dir = C.getDirection(input);
                                      if (dir != value) contentDir.value = dir;
                                    }
                                  },
                                  cursorColor: textColor == 0 ? Colors.white : Colors.black,
                                  controller: contentC,
                                  maxLines: 20,
                                  showCursor: true,
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
                      Expanded(
                          flex: 1,
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: C.colors.length,
                            itemBuilder: (BuildContext context, index) => index == 0
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
                                                color: textColor == 0 ? Colors.white : Colors.black,
                                                fontSize: C.isTablet ? 40 : 24,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          chosenIndex = 99;
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
                                            backgroundColor: chosenIndex == 99
                                                ? textColor == 0
                                                    ? Colors.white
                                                    : Colors.black
                                                : textColor == 0
                                                    ? Colors.white54
                                                    : Colors.black54,
                                            child: Stack(alignment: Alignment.center, children: [
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
                                          chosenIndex = index;
                                          C.onColorChanged();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundColor: chosenIndex == index
                                                ? textColor == 0
                                                    ? Colors.white
                                                    : Colors.black
                                                : textColor == 0
                                                    ? Colors.white54
                                                    : Colors.black54,
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: C.colors[index],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      chosenIndex = index;
                                      C.onColorChanged();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: chosenIndex == index
                                            ? textColor == 0
                                                ? Colors.white
                                                : Colors.black
                                            : textColor == 0
                                                ? Colors.white54
                                                : Colors.black54,
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: C.colors[index],
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

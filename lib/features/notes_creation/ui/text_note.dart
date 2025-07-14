import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/helpers/widgets_helper.dart';
import 'package:colorful_notes/core/models/note_model.dart';
import 'package:colorful_notes/core/providers/database_provider.dart';
import 'package:colorful_notes/core/providers/notes_provider.dart';
import 'package:colorful_notes/features/notes_creation/ui/widgets/color_bar.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextNote extends StatefulWidget {
  const TextNote({super.key, this.note});
  final Note? note;

  @override
  State<TextNote> createState() => _TextNoteState();
}

class _TextNoteState extends State<TextNote> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  late ValueNotifier<TextDirection> titleDirection;
  late ValueNotifier<TextDirection> contentDirection;
  Color pickerColor = const Color(0xfffdcb71);
  int textColorIndex = 0;
  int chosenColorIndex = 0;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    titleDirection.dispose();
    contentDirection.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
      chosenColorIndex = widget.note!.cIndex;
      textColorIndex = widget.note!.tIndex;
      titleDirection = ValueNotifier(
        WidgetsHelper.getDirection(titleController.text),
      );
      contentDirection = ValueNotifier(
        WidgetsHelper.getDirection(contentController.text),
      );
    } else {
      titleDirection = ValueNotifier(TextDirection.ltr);
      contentDirection = ValueNotifier(TextDirection.ltr);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppConsts.lightColors;
    final color = chosenColorIndex == 99
        ? pickerColor
        : colors[chosenColorIndex];
    final textColor = textColorIndex == 0 ? Colors.white : Colors.black;
    final semiTransparentColor = textColorIndex == 0
        ? Colors.white54
        : Colors.black54;
    return Consumer(
      builder: (context, ref, child) {
        final database = ref.watch(databaseProvider).value!;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: color,
          body: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                // Back and Save Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                              },
                              child: CircleAvatar(
                                backgroundColor: semiTransparentColor,
                                radius: 25,
                                child: Icon(
                                  Icons.arrow_back,
                                  color: color,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: GestureDetector(
                          onTap: () async {
                            titleController.text != "" ||
                                    contentController.text != ""
                                ? {
                                    if (widget.note != null)
                                      {
                                        if (titleController.text !=
                                                widget.note!.title ||
                                            contentController.text !=
                                                widget.note!.content)
                                          {
                                            await database.deleteFromDatabase(
                                              id: int.parse(widget.note!.id),
                                            ),
                                            await database.insertToDatabase(
                                              note: widget.note!.copyWith(
                                                title: titleController.text,
                                                content: contentController.text,
                                                cIndex: chosenColorIndex,
                                                tIndex: textColorIndex,
                                                extra: chosenColorIndex == 99
                                                    ? pickerColor.value
                                                          .toString()
                                                    : "",
                                                layout: WidgetsHelper.getLayout(
                                                  titleDir:
                                                      titleDirection.value,
                                                  contentDir:
                                                      contentDirection.value,
                                                  title: titleController.text,
                                                  content:
                                                      contentController.text,
                                                ),
                                                edited: 'yes',
                                              ),
                                            ),
                                          }
                                        else if (chosenColorIndex !=
                                                widget.note!.cIndex ||
                                            textColorIndex !=
                                                widget.note!.tIndex)
                                          {
                                            await database.editDatabaseItem(
                                              note: widget.note!.copyWith(
                                                cIndex: chosenColorIndex,
                                                tIndex: textColorIndex,
                                                extra: chosenColorIndex == 99
                                                    ? pickerColor.value
                                                          .toString()
                                                    : "",
                                              ),
                                            ),
                                          },
                                      }
                                    else
                                      {
                                        await database.insertToDatabase(
                                          note: Note(
                                            title: titleController.text,
                                            time: DateTime.now().toString(),
                                            content: contentController.text,
                                            cIndex: chosenColorIndex,
                                            tIndex: textColorIndex,
                                            extra: chosenColorIndex == 99
                                                ? pickerColor.value.toString()
                                                : "",
                                            layout: WidgetsHelper.getLayout(
                                              titleDir: titleDirection.value,
                                              contentDir:
                                                  contentDirection.value,
                                              title: titleController.text,
                                              content: contentController.text,
                                            ),
                                            id: '',
                                            type: 0,
                                            edited: '',
                                          ),
                                        ),
                                      },
                                    ref.invalidate(notesProvider),
                                    if (context.mounted)
                                      {Navigator.pop(context)},
                                  }
                                : Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: textColor,
                            radius: 25,
                            child: Icon(Icons.done, color: color, size: 36),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Note Body and Color Bar
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: ListView(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: ValueListenableBuilder<TextDirection>(
                                valueListenable: titleDirection,
                                builder: (context, value, child) =>
                                    TextFormField(
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      textDirection: value,
                                      onChanged: (input) {
                                        if (input.trim().length < 2) {
                                          final dir =
                                              WidgetsHelper.getDirection(input);
                                          if (dir != value) {
                                            titleDirection.value = dir;
                                          }
                                        }
                                      },
                                      cursorColor: textColor,
                                      autofocus: true,
                                      textInputAction: TextInputAction.done,
                                      controller: titleController,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Title".tr(),
                                        hintStyle: TextStyle(
                                          color: semiTransparentColor,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: ValueListenableBuilder<TextDirection>(
                                valueListenable: contentDirection,
                                builder: (context, value, child) =>
                                    TextFormField(
                                      textDirection: value,
                                      onChanged: (input) {
                                        if (input.trim().length < 2) {
                                          final dir =
                                              WidgetsHelper.getDirection(input);
                                          if (dir != value) {
                                            contentDirection.value = dir;
                                          }
                                        }
                                      },
                                      cursorColor: textColor,
                                      controller: contentController,
                                      maxLines: 20,
                                      showCursor: true,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 24,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Content".tr(),
                                        hintStyle: TextStyle(
                                          color: semiTransparentColor,
                                        ),
                                      ),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ColorBar(
                        colors: colors,
                        textColor: textColor,
                        textColorIndex: textColorIndex,
                        pickerColor: pickerColor,
                        chosenIndex: chosenColorIndex,
                        semiTransparentColor: semiTransparentColor,
                        setIndex: (int index) {
                          setState(() {
                            chosenColorIndex = index;
                          });
                        },
                        changeTextColor: () =>
                            textColorIndex = textColorIndex == 0 ? 1 : 0,
                        setCustomColor: () {
                          chosenColorIndex = 99;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Choose Color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: (color) =>
                                      setState(() => pickerColor = color),
                                  enableAlpha: false,
                                  hexInputBar: true,
                                  paletteType: PaletteType.hueWheel,
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Done'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
}

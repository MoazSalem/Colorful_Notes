import 'dart:io';
import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/helpers/widgets_helper.dart';
import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/ui/providers/notes_provider.dart';
import 'package:colorful_notes/features/notes/ui/widgets/color_bar.dart';
import 'package:colorful_notes/features/notes/ui/widgets/delete_dialog.dart';
import 'package:colorful_notes/features/notes/ui/widgets/notes/sound_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class VoiceNote extends StatefulWidget {
  const VoiceNote({super.key, this.note, required this.isEditing});
  final Note? note;
  final bool isEditing;

  @override
  State<VoiceNote> createState() => _VoiceNoteState();
}

class _VoiceNoteState extends State<VoiceNote> {
  final TextEditingController titleController = TextEditingController();
  final record = AudioRecorder();
  final String extension = '.m4a';
  late bool isEditing = widget.isEditing;
  String name = "";
  String time = "";
  bool isRecording = false;
  bool isPaused = false;
  FocusNode titleFocusNode = FocusNode();
  final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
  Color pickerColor = const Color(0xfffdcb71);
  int textColorIndex = 0;
  int chosenColorIndex = 0;
  late final Directory appDir;
  late final String filePath;
  late final String file;

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();
    stopWatchTimer.dispose();
    record.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      chosenColorIndex = widget.note!.cIndex;
      textColorIndex = widget.note!.tIndex;
      file = widget.note!.content;
      chosenColorIndex == 99
          ? pickerColor = Color(int.parse(widget.note!.extra))
          : null;
    }
    getAppDir();
    super.initState();
  }

  getAppDir() async {
    appDir = await getApplicationDocumentsDirectory();
    filePath = '${appDir.path}/Voice/';
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
        final notesController = ref.read(notesNotifierProvider.notifier);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: color,
          body: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              children: [
                // Back and Save Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: GestureDetector(
                        onTap: () async {
                          if (context.mounted) {
                            await record.stop();
                            stopWatchTimer.onResetTimer();
                            isRecording = false;
                            name == "" ? null : {deleteFile(filePath)};
                            if (context.mounted) Navigator.pop(context);
                          }
                        },
                        child: CircleAvatar(
                          backgroundColor: semiTransparentColor,
                          radius: 25,
                          child: Icon(Icons.arrow_back, color: color, size: 36),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (!isEditing)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                showDeleteNoteDialog(
                                  context,
                                  widget.note!.id,
                                  notesController,
                                ).then((value) {
                                  if (context.mounted && value == true) {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: CircleAvatar(
                                backgroundColor: textColor,
                                radius: 25,
                                child: Icon(
                                  Icons.delete,
                                  color: color,
                                  size: 36,
                                ),
                              ),
                            ),
                          ),
                        isEditing
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (widget.note == null) {
                                      await record.stop();
                                      time == ""
                                          ? context.mounted
                                                ? Navigator.pop(context)
                                                : null
                                          : {
                                              await notesController.add(
                                                Note(
                                                  title: titleController.text,
                                                  time: time,
                                                  content: file,
                                                  tIndex: textColorIndex,
                                                  extra: chosenColorIndex == 99
                                                      ? pickerColor.value
                                                            .toString()
                                                      : "",
                                                  type: 1,
                                                  layout: 0,
                                                  id: '',
                                                  cIndex: chosenColorIndex,
                                                  edited: '',
                                                ),
                                              ),
                                              stopWatchTimer.onResetTimer(),
                                            };
                                    } else if (titleController.text !=
                                        widget.note!.title) {
                                      await notesController.delete(
                                        widget.note!.id,
                                      );
                                      await notesController.add(
                                        widget.note!.copyWith(
                                          title: titleController.text,
                                          tIndex: textColorIndex,
                                          extra: chosenColorIndex == 99
                                              ? pickerColor.value.toString()
                                              : "",
                                          cIndex: chosenColorIndex,
                                          edited: 'yes',
                                        ),
                                      );
                                    } else if (chosenColorIndex !=
                                            widget.note!.cIndex ||
                                        textColorIndex != widget.note!.tIndex) {
                                      await notesController.updateNote(
                                        widget.note!.copyWith(
                                          cIndex: chosenColorIndex,
                                          extra: chosenColorIndex == 99
                                              ? pickerColor.value.toString()
                                              : "",
                                          tIndex: textColorIndex,
                                        ),
                                      );
                                    }
                                    ref.invalidate(notesNotifierProvider);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: textColor,
                                    radius: 25,
                                    child: Icon(
                                      Icons.done,
                                      color: color,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      isEditing = true;
                                      titleFocusNode.requestFocus();
                                    });
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: textColor,
                                    radius: 25,
                                    child: Icon(
                                      Icons.edit,
                                      color: color,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                      ],
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
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: TextFormField(
                                    enabled: isEditing,
                                    textAlign: TextAlign.center,
                                    focusNode: titleFocusNode,
                                    maxLines: 2,
                                    cursorColor: textColor,
                                    autofocus: false,
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
                                SizedBox(
                                  child: widget.note == null
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            StreamBuilder<int>(
                                              stream: stopWatchTimer.rawTime,
                                              initialData: 0,
                                              builder: (context, snap) {
                                                final value = snap.data;
                                                final time =
                                                    StopWatchTimer.getDisplayTime(
                                                      value!,
                                                    );
                                                var displayTime = time.split(
                                                  ".",
                                                );
                                                return Column(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8,
                                                          ),
                                                      child: Text(
                                                        displayTime[0],
                                                        style: TextStyle(
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: value == 0
                                                              ? semiTransparentColor
                                                              : textColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 50.0,
                                              ),
                                              child: isRecording
                                                  ? isPaused
                                                        ? IconButton(
                                                            constraints:
                                                                const BoxConstraints.tightFor(
                                                                  height: 120,
                                                                  width: 120,
                                                                ),
                                                            onPressed: () async {
                                                              await record
                                                                  .resume();
                                                              stopWatchTimer
                                                                  .onStartTimer();
                                                              setState(() {
                                                                isPaused =
                                                                    false;
                                                              });
                                                            },
                                                            icon: Icon(
                                                              Icons.play_arrow,
                                                              size: 100,
                                                              color: textColor,
                                                            ),
                                                          )
                                                        : IconButton(
                                                            constraints:
                                                                const BoxConstraints.tightFor(
                                                                  height: 120,
                                                                  width: 120,
                                                                ),
                                                            onPressed: () async {
                                                              await record
                                                                  .pause();
                                                              stopWatchTimer
                                                                  .onStopTimer();
                                                              setState(() {
                                                                isPaused = true;
                                                              });
                                                            },
                                                            icon: Icon(
                                                              Icons.pause,
                                                              size: 100,
                                                              color: textColor,
                                                            ),
                                                          )
                                                  : IconButton(
                                                      constraints:
                                                          const BoxConstraints.tightFor(
                                                            height: 120,
                                                            width: 120,
                                                          ),
                                                      onPressed: () async {
                                                        titleFocusNode
                                                            .unfocus();
                                                        time == ""
                                                            ? {
                                                                time = DateTime.now()
                                                                    .toString(),
                                                                name =
                                                                    WidgetsHelper.parseDate(
                                                                      time,
                                                                    ).toString(),
                                                              }
                                                            : {
                                                                stopWatchTimer
                                                                    .onResetTimer(),
                                                                time = DateTime.now()
                                                                    .toString(),
                                                                name =
                                                                    WidgetsHelper.parseDate(
                                                                      time,
                                                                    ).toString(),
                                                              };
                                                        if (await record
                                                            .hasPermission()) {
                                                          await createVoiceFolder(
                                                            appDir,
                                                          );
                                                          // Start timer.
                                                          stopWatchTimer
                                                              .onStartTimer();
                                                          // Start recording
                                                          setState(() {
                                                            isRecording = true;
                                                            isPaused = false;
                                                          });
                                                          file =
                                                              "$filePath$name$extension";
                                                          await record.start(
                                                            const RecordConfig(),
                                                            path: file,
                                                          );
                                                        }
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .keyboard_voice_rounded,
                                                        size: 100,
                                                        color:
                                                            semiTransparentColor,
                                                      ),
                                                    ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 16,
                                              ),
                                              child: IconButton(
                                                constraints:
                                                    const BoxConstraints.tightFor(
                                                      height: 120,
                                                      width: 120,
                                                    ),
                                                onPressed: () async {
                                                  // Stop timer.
                                                  stopWatchTimer.onStopTimer();
                                                  await record.stop();
                                                  setState(() {
                                                    isRecording = false;
                                                    isPaused = false;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.stop_circle,
                                                  size: 100,
                                                  color: isRecording
                                                      ? textColor
                                                      : semiTransparentColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : SoundPlayer(
                                          voiceNote: widget.note!,
                                          color: color,
                                          viewMode: 0,
                                          iconColor: textColor,
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isEditing)
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
                          changeTextColor: () => setState(
                            () => textColorIndex = textColorIndex == 0 ? 1 : 0,
                          ),
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

createVoiceFolder(Directory appDir) async {
  Directory voice = Directory("${appDir.path}/Voice");
  if ((await voice.exists())) {
    if (kDebugMode) {
      print("exist");
    }
  } else {
    if (kDebugMode) {
      print("not exist");
    }
    await Permission.storage.request().isGranted;

    // Either the permission was already granted before or the user just granted it.
    await voice.create(recursive: true);
  }
}

deleteFile(String filePath) async {
  try {
    await File(filePath).delete();
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

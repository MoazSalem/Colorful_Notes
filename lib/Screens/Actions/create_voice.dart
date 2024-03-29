import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes/main.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:notes/Cubit/notes_cubit.dart';
import 'package:record/record.dart';

class CreateVoice extends StatefulWidget {
  const CreateVoice({super.key});

  @override
  State<CreateVoice> createState() => _CreateVoiceState();
}

class _CreateVoiceState extends State<CreateVoice> {
  final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
  final TextEditingController titleC = TextEditingController();
  final record = Record();
  late String title;
  late String content;
  late double height;
  String name = "";
  FocusNode titleFocusNode = FocusNode();
  String time = "";
  int chosenIndex = 0;
  bool isRecording = false;
  bool isPaused = false;
  int textColor = 0;
  Color pickerColor = const Color(0xfffdcb71);
  Color currentColor = const Color(0xfffdcb71);

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void dispose() {
    titleC.dispose();
    titleFocusNode.dispose();
    stopWatchTimer.dispose();
    record.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    height = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
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
                                  await record.stop();
                                  time = "";
                                  stopWatchTimer.onResetTimer();
                                  titleC.text = "";
                                  isRecording = false;
                                  name == ""
                                      ? null
                                      : C.deleteFile("${C.appDir.path}/Voice/$name.m4a");
                                  Navigator.pop(context);
                                  C.onChanged();
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
                            await record.stop();
                            title = titleC.text;
                            time == ""
                                ? Navigator.pop(context)
                                : {
                                    content = "${C.appDir.path}/Voice/$name.m4a",
                                    await C.insertToDatabase(
                                        title: title,
                                        time: time,
                                        content: content,
                                        index: chosenIndex,
                                        tIndex: textColor,
                                        extra:
                                            chosenIndex == 99 ? pickerColor.value.toString() : "",
                                        type: 1,
                                        layout: 0),
                                    stopWatchTimer.onResetTimer(),
                                    isRecording = false,
                                    titleC.text = "",
                                    time = "",
                                    Navigator.pop(context),
                                    C.onCreateNote(),
                                    C.onChanged()
                                  };
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
                          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: TextFormField(
                                  textAlign: TextAlign.center,
                                  focusNode: titleFocusNode,
                                  maxLines: 2,
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
                            SizedBox(
                              height: height * 0.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  StreamBuilder<int>(
                                    stream: stopWatchTimer.rawTime,
                                    initialData: 0,
                                    builder: (context, snap) {
                                      final value = snap.data;
                                      final time = StopWatchTimer.getDisplayTime(value!);
                                      var displayTime = time.split(".");
                                      return Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(
                                              displayTime[0],
                                              style: TextStyle(
                                                  fontSize: C.isTablet ? 80 : 40,
                                                  fontWeight: FontWeight.w500,
                                                  color: value == 0
                                                      ? textColor == 0
                                                          ? Colors.white54
                                                          : Colors.black54
                                                      : textColor == 0
                                                          ? Colors.white
                                                          : Colors.black),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: C.isTablet ? 80 : 50.0),
                                    child: isRecording
                                        ? isPaused
                                            ? IconButton(
                                                constraints: const BoxConstraints.tightFor(
                                                    height: 120, width: 120),
                                                onPressed: () async {
                                                  await record.resume();
                                                  stopWatchTimer.onStartTimer();
                                                  isPaused = false;
                                                  C.onChanged();
                                                },
                                                icon: Icon(
                                                  Icons.play_arrow,
                                                  size: 100,
                                                  color:
                                                      textColor == 0 ? Colors.white : Colors.black,
                                                ))
                                            : IconButton(
                                                constraints: const BoxConstraints.tightFor(
                                                    height: 120, width: 120),
                                                onPressed: () async {
                                                  await record.pause();
                                                  stopWatchTimer.onStopTimer();
                                                  isPaused = true;
                                                  C.onChanged();
                                                },
                                                icon: Icon(
                                                  Icons.pause,
                                                  size: 100,
                                                  color:
                                                      textColor == 0 ? Colors.white : Colors.black,
                                                ))
                                        : IconButton(
                                            constraints: const BoxConstraints.tightFor(
                                                height: 120, width: 120),
                                            onPressed: () async {
                                              titleFocusNode.unfocus();
                                              time == ""
                                                  ? {
                                                      time = DateTime.now().toString(),
                                                      name = parseDate(time).toString()
                                                    }
                                                  : {
                                                      stopWatchTimer.onResetTimer(),
                                                      C.deleteFile(context),
                                                      time = DateTime.now().toString(),
                                                      name = parseDate(time).toString()
                                                    };
                                              if (await record.hasPermission()) {
                                                await C.createVoiceFolder();
                                                // Start timer.
                                                stopWatchTimer.onStartTimer();
                                                // Start recording
                                                isRecording = true;
                                                isPaused = false;
                                                C.onChanged();
                                                await record.start(
                                                  path: "${C.appDir.path}/Voice/$name.m4a",
                                                  encoder: AudioEncoder.aacLc, // by default
                                                  bitRate: 128000, // by default
                                                  samplingRate: 44100, // by default
                                                );
                                              }
                                            },
                                            icon: Icon(
                                              Icons.keyboard_voice_rounded,
                                              size: 100,
                                              color:
                                                  textColor == 0 ? Colors.white54 : Colors.black54,
                                            )),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: height * 0.06964),
                                    child: IconButton(
                                        constraints:
                                            const BoxConstraints.tightFor(height: 120, width: 120),
                                        onPressed: () async {
                                          // Stop timer.
                                          stopWatchTimer.onStopTimer();
                                          await record.stop();
                                          isRecording = false;
                                          isPaused = false;
                                          C.onChanged();
                                        },
                                        icon: Icon(
                                          Icons.stop_circle,
                                          size: 100,
                                          color: isRecording
                                              ? textColor == 0
                                                  ? Colors.white
                                                  : Colors.black
                                              : textColor == 0
                                                  ? Colors.white54
                                                  : Colors.black54,
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ]),
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
                                          C.onChanged();
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
                                          C.onChanged();
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
                                      C.onChanged();
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

  String parseDate(String stringDate) {
    var date = DateTime.parse(stringDate);
    String parsedDate = DateFormat.EEEE().format(date);
    String parsedDate0 = DateFormat.H().format(date);
    String parsedDate1 = DateFormat.m().format(date);
    String parsedDate2 = DateFormat.s().format(date);
    return parsedDate + parsedDate0 + parsedDate1 + parsedDate2;
  }
}

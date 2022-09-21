import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:record/record.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

final record = Record();
final TextEditingController titleC = TextEditingController();
late String title;
late String content;
String time = "";
late String name;
late var Length;
bool isRecording = false;
final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);

Widget createVoice(BuildContext context) {
  return BlocConsumer<NotesBloc, NotesState>(
    listener: (context, state) {
      // TODO: implement listener
    },
    builder: (context, state) {
      var B = NotesBloc.get(context);
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: B.colors[B.chosenIndex],
        body: SafeArea(
            child: ListView(children: [
          SizedBox(
            height: 70,
          ),
          Expanded(
            flex: 3,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                    maxLines: 2,
                    cursorColor: Colors.white,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    controller: titleC,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: B.isTablet ? 60 : 36,
                        fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "Title")),
              ),
              StreamBuilder<int>(
                stream: stopWatchTimer.rawTime,
                initialData: 0,
                builder: (context, snap) {
                  final value = snap.data;
                  final displayTime = StopWatchTimer.getDisplayTime(value!);
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          displayTime,
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              color: value == 0 ? Colors.black54 : Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: IconButton(
                    constraints:
                        BoxConstraints.tightFor(height: 120, width: 120),
                    onPressed: () async {
                      time == "" ? {
                      time = DateTime.now().toString(),
                      name = parseDate(time).toString()
                      } : {
                      stopWatchTimer.onResetTimer(),
                      B.deleteFile(context),
                      time = DateTime.now().toString(),
                      name = parseDate(time).toString()
                      };
                      if (await record.hasPermission()) {
                        await B.getStoragePermission();
                        // Start timer.
                        stopWatchTimer.onStartTimer();
                        // Start recording
                        isRecording = true;
                        B.onRecord();
                        await record.start(
                          path: "${B.appDir.path}/$name.m4a",
                          encoder: AudioEncoder.aacLc, // by default
                          bitRate: 128000, // by default
                          samplingRate: 44100, // by default
                        );
                      }
                    },
                    icon: Icon(
                      Icons.keyboard_voice_rounded,
                      size: 100,
                      color:Colors.white,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: isRecording? 20 : 80),
                child: IconButton(
                    constraints:
                        BoxConstraints.tightFor(height: 120, width: 120),
                    onPressed: () async {
                      // Stop timer.
                      stopWatchTimer.onStopTimer();
                      await record.stop();
                    },
                    icon: Icon(
                      Icons.stop_circle,
                      size: 100,
                      color: Colors.white,
                    )),
              )
            ]),
          ),
            !isRecording
              ? Container()
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
            onPressed: () {
              time = "";
              stopWatchTimer.onResetTimer();
              titleC.text = "";
              isRecording = false;
              B.deleteFile("${B.appDir.path}/$name.m4a");
              B.onRecord();
            },
            child: Text(
                "Discard",
                style: TextStyle(fontSize: 30, color: Colors.black54),
            ),
          ),
              ),
          FittedBox(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: B.isTablet ? 100 : 20.0),
              child: Container(
                height: 60,
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: B.colors.length,
                    itemBuilder: (BuildContext context, Index) =>
                        GestureDetector(
                      onTap: () {
                        B.ColorChanged(Index);
                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: B.colors[Index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: TextButton(
              onPressed: () async {
                await record.stop();
                title = titleC.text;
                time == ""
                    ? Navigator.pop(context)
                    : {
                        content = "${B.appDir.path}/${name}.m4a",
                        await B.insertToDatabase(
                            title: title,
                            time: time,
                            content: content,
                            index: B.chosenIndex,
                            type: 1),
                        stopWatchTimer.onResetTimer(),
                        isRecording = false,
                        titleC.text = "",
                        time = "", //todo: fix this
                        Navigator.pop(context),
                        B.onCreateNote()
                      };
              },
              child: Text(
                isRecording? "Save" : "Close" ,
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          )
        ])),
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/home_screen.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

final record = Record();
final TextEditingController titleC = TextEditingController();
late String title;
late String content;
String name = "";
final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
FocusNode titleFocusNode = FocusNode();
String time = "";
int chosenIndex = 0;
bool isRecording = false;
bool isPaused = false;

Widget createVoice(BuildContext context) {
  return BlocConsumer<NotesBloc, NotesState>(
    listener: (context, state) {},
    builder: (context, state) {
      var B = NotesBloc.get(context);
      double height = MediaQuery.of(context).size.height;
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
                      flex: B.isTablet? 8 : 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              constraints: const BoxConstraints.tightFor(width: 60, height: 60),
                              onPressed: () async {
                                await record.stop();
                                time = "";
                                stopWatchTimer.onResetTimer();
                                titleC.text = "";
                                isRecording = false;
                                name == "" ? null : B.deleteFile("${B.appDir.path}/Voice/$name.m4a");
                                Navigator.pop(context);
                                B.onRecord();
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
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await record.stop();
                          title = titleC.text;
                          time == ""
                              ? Navigator.pop(context)
                              : {
                            content = "${B.appDir.path}/Voice/$name.m4a",
                            await B.insertToDatabase(title: title, time: time, content: content, index: chosenIndex, type: 1, layout: 0),
                            stopWatchTimer.onResetTimer(),
                            isRecording = false,
                            titleC.text = "",
                            time = "",
                            B.adCounter++,
                            await prefs.setInt("adCounter", B.adCounter),
                            B.adCounter == 3 ? {interstitialAd.show(), B.adCounter = 0} : null,
                            Navigator.pop(context),
                            B.onCreateNote(),
                            B.onChanged()
                          };
                        },
                        icon: const Icon(
                          Icons.done,
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
                      flex: 4,
                      child: ListView(children: [
                        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            child: TextFormField(
                                textAlign: TextAlign.center,
                                focusNode: titleFocusNode,
                                maxLines: 2,
                                cursorColor: Colors.white,
                                autofocus: true,
                                textInputAction: TextInputAction.done,
                                controller: titleC,
                                style: TextStyle(color: Colors.white, fontSize: B.isTablet ? 60 : 36, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(border: InputBorder.none, hintText: "Title".tr())),
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
                                            style: TextStyle(fontSize: B.isTablet ? 80 : 40, fontWeight: FontWeight.w500, color: value == 0 ? Colors.black54 : Colors.white),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: B.isTablet ? 80 : 50.0),
                                  child: isRecording
                                      ? isPaused
                                          ? IconButton(
                                              constraints: const BoxConstraints.tightFor(height: 120, width: 120),
                                              onPressed: () async {
                                                await record.resume();
                                                stopWatchTimer.onStartTimer();
                                                isPaused = false;
                                                B.onRecord();
                                              },
                                              icon: const Icon(
                                                Icons.play_arrow,
                                                size: 100,
                                                color: Colors.white,
                                              ))
                                          : IconButton(
                                              constraints: const BoxConstraints.tightFor(height: 120, width: 120),
                                              onPressed: () async {
                                                await record.pause();
                                                stopWatchTimer.onStopTimer();
                                                isPaused = true;
                                                B.onRecord();
                                              },
                                              icon: const Icon(
                                                Icons.pause,
                                                size: 100,
                                                color: Colors.white,
                                              ))
                                      : IconButton(
                                          constraints: const BoxConstraints.tightFor(height: 120, width: 120),
                                          onPressed: () async {
                                            titleFocusNode.unfocus();
                                            time == ""
                                                ? {time = DateTime.now().toString(), name = parseDate(time).toString()}
                                                : {stopWatchTimer.onResetTimer(), B.deleteFile(context), time = DateTime.now().toString(), name = parseDate(time).toString()};
                                            if (await record.hasPermission()) {
                                              await B.createVoiceFolder();
                                              // Start timer.
                                              stopWatchTimer.onStartTimer();
                                              // Start recording
                                              isRecording = true;
                                              isPaused = false;
                                              B.onRecord();
                                              await record.start(
                                                path: "${B.appDir.path}/Voice/$name.m4a",
                                                encoder: AudioEncoder.aacLc, // by default
                                                bitRate: 128000, // by default
                                                samplingRate: 44100, // by default
                                              );
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.keyboard_voice_rounded,
                                            size: 100,
                                            color: Colors.black54,
                                          )),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: height * 0.06964),
                                  child: IconButton(
                                      constraints: const BoxConstraints.tightFor(height: 120, width: 120),
                                      onPressed: () async {
                                        // Stop timer.
                                        stopWatchTimer.onStopTimer();
                                        await record.stop();
                                        isRecording = false;
                                        isPaused = false;
                                        B.onRecord();
                                      },
                                      icon: Icon(
                                        Icons.stop_circle,
                                        size: 100,
                                        color: isRecording ? Colors.white : Colors.black54,
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
                                backgroundColor: chosenIndex == index ? Colors.white : Colors.white54,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: B.colors[index],
                                ),
                              ),
                            ),
                          ),
                        )) ],
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

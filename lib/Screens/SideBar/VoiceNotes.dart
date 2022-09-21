import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:voice_message_package/voice_message_package.dart';
import '../Actions/CreateVoice.dart';

bool play = false;
late bool noTitle;

class VoiceNotesPage extends StatelessWidget {
  const VoiceNotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var B = NotesBloc.get(context);
        Future<void> showDeleteDialog(
            {required List<Map> Notes, required int index}) async {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Remove Note",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                content: Text("Are you sure you want to remove this note?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel")),
                  TextButton(
                      onPressed: () async {
                        B.deleteFile(B.voiceMap[index]["content"]);
                        await B.deleteFromDatabase(id: Notes[index]["id"]);
                        Navigator.of(context).pop();
                        B.onCreateNote();
                      },
                      child: Text("Yes"))
                ],
              );
            },
          );
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              showBottomSheet(
                  enableDrag: false,
                  context: context,
                  builder: (context) => createVoice(context));
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          body: ListView(padding: EdgeInsets.zero, children: [
            B.customAppBar(
              context,
              "Voice Notes",
              66,
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
                child: B.voiceMap.length == 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 200),
                        child: Center(
                            child: Text(
                          "You don't have any voice notes",
                          style: TextStyle(
                              color: Colors.pink, fontWeight: FontWeight.w400),
                        )),
                      )
                    : Center(
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: B.voiceMap.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              B.voiceMap[index]["title"] == ""
                                  ? noTitle = true
                                  : noTitle = false;
                              int dateValue = B.calculateDifference(
                                  B.voiceMap[index]["time"]);
                              String date =
                                  B.parseDate(B.voiceMap[index]["time"]);
                              return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      height: noTitle? 160 : 200,
                                      width: 300,
                                      child: Card(
                                        color: B.colors[B.voiceMap[index]
                                            ['cindex']],
                                        elevation: B.showShadow ? 3 : 0,
                                        shadowColor: B.colors[B.voiceMap[index]
                                            ['cindex']],
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(0)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 40.0,
                                              right: 40.0,
                                              top: 10,
                                              bottom: B.showDate ? 20 : 10),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                noTitle
                                                    ? Container()
                                                    : Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20),
                                                          child: Text(
                                                              B.voiceMap[index]
                                                                  ["title"],
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize: 24,
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets.only(top: B.showDate? noTitle? 25 : 0 : 0),
                                                        child: Container(
                                                          height: 61,
                                                          child: VoiceMessage(
                                                            meBgColor: B.colors[
                                                                B.voiceMap[
                                                                        index]
                                                                    ["cindex"]],
                                                            audioSrc:
                                                                B.voiceMap[
                                                                        index]
                                                                    ["content"],
                                                            me: true,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                B.showDate
                                                    ? Text(
                                                        dateValue == 0
                                                            ? "Today"
                                                            : dateValue == -1
                                                                ? "Yesterday"
                                                                : date,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Container(),
                                              ]),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDeleteDialog(
                                            index: index, Notes: B.voiceMap);
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    )
                                  ]);
                            }),
                      ))
          ]),
        );
      },
    );
  }
}

// Row(
// children: [
// Padding(
// padding: const EdgeInsets.only(left: 8.0),
// child: IconButton(
// constraints: BoxConstraints.tightFor(height:70,width: 70),
// onPressed: () {
// play = !play;
// B.audioPlayed();
// },
// icon: play? Icon(
// Icons.pause_circle,
// size: 50,
// color: Colors.white,
// ):Icon(
// Icons.play_circle,
// size: 50,
// color: Colors.white,
// )),
// )
// ],
// ))),

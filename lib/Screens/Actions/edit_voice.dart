import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/main.dart';

class EditVoice extends StatefulWidget {
  final Map note;

  const EditVoice({Key? key, required this.note}) : super(key: key);

  @override
  State<EditVoice> createState() => _EditVoiceState();
}

class _EditVoiceState extends State<EditVoice> {
  final TextEditingController titleC = TextEditingController();
  late int bIndex;
  late int textColor;

  @override
  void initState() {
    titleC.text = widget.note["title"];
    bIndex = widget.note["cindex"];
    textColor = widget.note['tindex'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          color: B.colors[bIndex],
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: B.isTablet ? 50 : 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 80 : 40),
                  child: TextFormField(
                      onSaved: B.onViewChanged(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      cursorColor: textColor == 0 ? Colors.white : Colors.black,
                      textInputAction: TextInputAction.done,
                      controller: titleC,
                      style: TextStyle(
                          color: textColor == 0 ? Colors.white : Colors.black,
                          fontSize: B.isTablet ? 60 : 36,
                          fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "No Title".tr(),
                          hintStyle:
                              TextStyle(color: textColor == 0 ? Colors.white54 : Colors.black54))),
                ),
                SizedBox(
                  height: B.isTablet ? 40 : 10,
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        textColor = textColor == 0 ? 1 : 0;
                        B.onColorChanged();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          "TC".tr(),
                          style: TextStyle(
                              fontSize: 20, color: textColor == 0 ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 100 : 20.0),
                        child: SizedBox(
                          height: 65,
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (BuildContext context, index2) => GestureDetector(
                                onTap: () {
                                  bIndex = index2;
                                  B.onColorChanged();
                                },
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: bIndex == index2
                                      ? textColor == 0
                                          ? Colors.white
                                          : Colors.black
                                      : textColor == 0
                                          ? Colors.white54
                                          : Colors.black54,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: B.colors[index2],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: FittedBox(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 100 : 20.0),
                          child: SizedBox(
                            height: 65,
                            child: Center(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (BuildContext context, index3) => GestureDetector(
                                  onTap: () {
                                    index3 += 5;
                                    bIndex = index3;
                                    B.onColorChanged();
                                  },
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: bIndex == (index3 + 5)
                                        ? textColor == 0
                                            ? Colors.white
                                            : Colors.black
                                        : textColor == 0
                                            ? Colors.white54
                                            : Colors.black54,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: B.colors[index3 + 5],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 50 : 30),
                          child: TextButton(
                            onPressed: () {
                              titleC.clear();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Discard".tr(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: textColor == 0 ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 60 : 40),
                          child: TextButton(
                            onPressed: () async {
                              var time = DateTime.now().toString();
                              titleC.text != widget.note["title"]
                                  ? {
                                      await B.insertToDatabase(
                                          title: titleC.text,
                                          time: time,
                                          content: widget.note["content"],
                                          index: bIndex,
                                          tIndex: textColor,
                                          type: 1,
                                          edited: 'yes',
                                          layout: widget.note['layout']),
                                      await B.deleteFromDatabase(id: widget.note["id"]),
                                      Navigator.of(context).pop(),
                                      B.onCreateNote()
                                    }
                                  : bIndex != widget.note["cindex"] || textColor != widget.note["tindex"]
                                      ? {
                                          await B.editDatabaseItem(
                                              time: widget.note['time'],
                                              content: widget.note['content'],
                                              id: widget.note["id"],
                                              title: widget.note['title'],
                                              index: bIndex,
                                              tIndex: textColor,
                                              type: 1,
                                              edited: 'no',
                                              layout: widget.note['layout']),
                                          Navigator.of(context).pop(),
                                          B.onCreateNote()
                                        }
                                      : Navigator.of(context).pop();
                            },
                            child: Text(
                              "Save".tr(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: textColor == 0 ? Colors.white : Colors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
        );
      },
    );
  }
}

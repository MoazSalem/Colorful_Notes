import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';

final TextEditingController titleC = TextEditingController();
final TextEditingController contentC = TextEditingController();

Widget editNote({required Map note}) {
  titleC.text = note["title"];
  contentC.text = note["content"];
  int bIndex = note["cindex"];
  return BlocConsumer<NotesBloc, NotesState>(
    listener: (context, state) {},
    builder: (context, state) {
      var B = NotesBloc.get(context);
      double height = MediaQuery.of(context).size.height;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: B.colors[bIndex],
        body: SafeArea(
            child: ListView(children: [
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
                textDirection: note['layout'] == 0 ? TextDirection.ltr : TextDirection.rtl,
                onSaved: B.onViewChanged(),
                maxLines: 2,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                controller: titleC,
                style: TextStyle(color: Colors.white, fontSize: B.isTablet ? 60 : 36, fontWeight: FontWeight.w500),
                decoration: InputDecoration(border: InputBorder.none, hintText: "No Title".tr())),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
                textDirection: note['layout'] == 0 ? TextDirection.ltr : TextDirection.rtl,
                onSaved: B.onSearch(),
                cursorColor: Colors.white,
                controller: contentC,
                maxLines: B.isTablet ? 14 : 15,
                showCursor: true,
                style: TextStyle(color: Colors.white, fontSize: B.isTablet ? 40 : 24),
                decoration: InputDecoration(border: InputBorder.none, constraints: BoxConstraints.expand(height: height * 0.573, width: 200), hintText: "Content".tr())),
          ),
          FittedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 100 : 20.0),
              child: SizedBox(
                height: 60,
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: B.colors.length,
                    itemBuilder: (BuildContext context, index2) => GestureDetector(
                      onTap: () {
                        bIndex = index2;
                        B.onColorChanged();
                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: bIndex == index2 ? Colors.white : Colors.white54,
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
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 50 : 30),
                    child: TextButton(
                      onPressed: () {
                        titleC.clear();
                        contentC.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Discard".tr(),
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 60 : 40),
                    child: TextButton(
                      onPressed: () async {
                        var time = DateTime.now().toString();
                        titleC.text != note["title"] || contentC.text != note["content"]
                            ? {
                                await B.detectLanguage("${titleC.text} ${contentC.text}"),
                                await B.insertToDatabase(title: titleC.text, time: time, content: contentC.text, index: bIndex, edited: 'yes', layout: B.detectedLanguage == 'ar' ? 1 : 0),
                                await B.deleteFromDatabase(id: note["id"]),
                                Navigator.of(context).pop(),
                                B.onCreateNote()
                              }
                            : bIndex != note["cindex"]
                                ? {
                                    await B.editDatabaseItem(
                                        time: note['time'], content: note['content'], id: note["id"], title: note['title'], index: bIndex, type: 0, edited: 'no', layout: note['layout']),
                                    Navigator.of(context).pop(),
                                    B.onCreateNote()
                                  }
                                : Navigator.of(context).pop();
                      },
                      child: Text(
                        "Save".tr(),
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ])),
      );
    },
  );
}

import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/helpers/widgets_helper.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/ui/widgets/notes/sound_player.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

class LargeNote extends StatelessWidget {
  const LargeNote({super.key, required this.note, required this.settings});
  final Note note;
  final SettingsModel settings;

  @override
  Widget build(BuildContext context) {
    final color = note.cIndex == 99
        ? Color(int.parse(note.extra))
        : settings.darkColors
        ? AppConsts.darkerColors[note.cIndex]
        : AppConsts.lightColors[note.cIndex];
    final noTitle = note.title == "";
    final noContent = note.content == "";
    final date = WidgetsHelper.parsedDate(note.time, settings.lang);
    final int dateValue = WidgetsHelper.calculateDifference(note.time);
    return Center(
      child: SizedBox(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: color,
            boxShadow: settings.showShadow
                ? [
                    BoxShadow(
                      color: color,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: settings.showDate ? 20 : 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                noTitle
                    ? Container()
                    : Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            note.title,
                            maxLines: note.type == 0 ? 1 : 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            textDirection: note.layout == 0 || note.layout == 2
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 24,
                              color: note.tIndex == 0
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                note.type == 0
                    ? Expanded(
                        flex: 7,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                            noContent ? "Empty".tr() : note.content,
                            textAlign: note.layout == 1 || note.layout == 2
                                ? TextAlign.right
                                : TextAlign.left,
                            textDirection: note.layout == 1 || note.layout == 2
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                            maxLines: settings.showDate ? 8 : 9,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: noContent
                                  ? note.tIndex == 0
                                        ? Colors.white38
                                        : Colors.black38
                                  : note.tIndex == 0
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: noTitle ? 21 : 16,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        flex: noTitle ? 7 : 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SoundPlayer(
                              index: 0,
                              voiceNotes: [note],
                              color: color,
                              viewMode: 0,
                              isTablet: false,
                            ),
                          ],
                        ),
                      ),
                settings.showDate
                    ? Expanded(
                        child: Stack(
                          alignment: settings.lang == 'en'
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          children: [
                            Text(
                              dateValue == 0
                                  ? "Today".tr()
                                  : dateValue == -1
                                  ? "Yesterday".tr()
                                  : date,
                              style: TextStyle(
                                color: note.tIndex == 0
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  settings.showEdited
                                      ? note.edited == "yes"
                                            ? "Edited".tr()
                                            : ""
                                      : "",
                                  style: TextStyle(
                                    color: note.tIndex == 0
                                        ? Colors.white38
                                        : Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

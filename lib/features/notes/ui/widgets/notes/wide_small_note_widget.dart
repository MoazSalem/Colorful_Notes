import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/helpers/widgets_helper.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:colorful_notes/features/notes/ui/widgets/notes/sound_player.dart';

class WideSmallNoteWidget extends StatelessWidget {
  const WideSmallNoteWidget({
    super.key,
    required this.note,
    required this.settings,
  });
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
      child: Container(
        height: 100,
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
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (!noTitle)
                    Text(
                      note.title,
                      strutStyle: StrutStyle(
                        forceStrutHeight: note.layout == 0 ? false : true,
                      ),
                      textAlign: note.layout == 0 || note.layout == 2
                          ? TextAlign.left
                          : TextAlign.right,
                      textDirection: note.layout == 0 || note.layout == 2
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        color: note.tIndex == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  note.type == 0
                      ? Column(
                          mainAxisAlignment: noTitle
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                noContent ? "Empty".tr() : note.content,
                                strutStyle: StrutStyle(
                                  forceStrutHeight:
                                      note.layout == 0 || note.layout == 1
                                      ? false
                                      : true,
                                ),
                                textAlign: note.layout == 1 || note.layout == 2
                                    ? TextAlign.right
                                    : TextAlign.left,
                                textDirection:
                                    note.layout == 1 || note.layout == 2
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                maxLines: noTitle ? 3 : 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: noContent
                                      ? note.tIndex == 0
                                            ? Colors.white38
                                            : Colors.black38
                                      : note.tIndex == 0
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: noTitle ? 17 : 15,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SoundPlayer(
                              voiceNote: note,
                              color: color,
                              viewMode: 1,
                            ),
                          ],
                        ),
                ],
              ),
            ),
            if (settings.showDate)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3.0,
                  horizontal: 8,
                ),
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
                        color: note.tIndex == 0 ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
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
              ),
          ],
        ),
      ),
    );
  }
}

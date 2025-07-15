import 'package:colorful_notes/core/consts.dart';
import 'package:colorful_notes/core/helpers/widgets_helper.dart';
import 'package:colorful_notes/core/models/settings_model.dart';
import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:colorful_notes/features/notes/ui/widgets/notes/sound_player.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

class SmallGridNote extends StatelessWidget {
  const SmallGridNote({super.key, required this.note, required this.settings});
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!noTitle)
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        note.title,
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
                          fontSize: 18,
                          color: note.tIndex == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  note.type == 0
                      ? Text(
                          noContent ? "Empty".tr() : note.content,
                          textAlign: note.layout == 1 || note.layout == 2
                              ? TextAlign.right
                              : TextAlign.left,
                          textDirection: note.layout == 1 || note.layout == 2
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: noContent
                                ? note.tIndex == 0
                                      ? Colors.white38
                                      : Colors.black38
                                : note.tIndex == 0
                                ? Colors.white
                                : Colors.black,
                            fontSize: noTitle ? 16 : 13,
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: noTitle ? 24 : 4.0),
                          child: SoundPlayer(
                            voiceNote: note,
                            color: color,
                            viewMode: 3,
                          ),
                        ),
                ],
              ),
            ),
            if (settings.showDate)
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
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
                        fontSize: note.type == 0 ? 13 : 12,
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
              ),
          ],
        ),
      ),
    );
  }
}

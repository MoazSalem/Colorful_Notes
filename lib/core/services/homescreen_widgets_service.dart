import 'dart:ui';
import 'package:colorful_notes/core/helpers/widgets_helper.dart';
import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:home_widget/home_widget.dart';

class HomescreenWidgetsService {
  static Future<void> update({
    required List<Note> notes,
    required List<Color> color,
  }) async {
    String titles = "";
    String contents = "";
    String colors = "";
    String textColors = "";
    for (int i = 0; i < notes.length; i++) {
      titles += notes[i].title;
      contents += notes[i].content;
      colors += notes[i].cIndex == 99
          ? WidgetsHelper.parseColor(notes[i].extra).toHexString()
          : color[notes[i].cIndex].toHexString();
      textColors += notes[i].tIndex.toString();
      // add separator if not last note
      if (i < notes.length - 1) {
        titles += "||S||";
        contents += "||S||";
        colors += "||S||";
        textColors += "||S||";
      }
    }
    await HomeWidget.saveWidgetData('titles', titles);
    await HomeWidget.saveWidgetData('contents', contents);
    await HomeWidget.saveWidgetData('colors', colors);
    await HomeWidget.saveWidgetData('textColors', textColors);
    await HomeWidget.updateWidget(androidName: "BigNoteWidget");
    await HomeWidget.updateWidget(androidName: "MidNoteWidget");
    await HomeWidget.updateWidget(androidName: "SmallNoteWidget");
    await HomeWidget.updateWidget(androidName: "WideNoteWidget");
  }
}

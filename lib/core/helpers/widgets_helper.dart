import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;

class WidgetsHelper {
  static TextDirection getDirection(String v) {
    final string = v.trim();
    if (string.isEmpty) return TextDirection.ltr;
    final firstUnit = string.codeUnitAt(0);
    if (firstUnit > 0x0600 && firstUnit < 0x06FF ||
        firstUnit > 0x0750 && firstUnit < 0x077F ||
        firstUnit > 0x07C0 && firstUnit < 0x07EA ||
        firstUnit > 0x0840 && firstUnit < 0x085B ||
        firstUnit > 0x08A0 && firstUnit < 0x08B4 ||
        firstUnit > 0x08E3 && firstUnit < 0x08FF ||
        firstUnit > 0xFB50 && firstUnit < 0xFBB1 ||
        firstUnit > 0xFBD3 && firstUnit < 0xFD3D ||
        firstUnit > 0xFD50 && firstUnit < 0xFD8F ||
        firstUnit > 0xFD92 && firstUnit < 0xFDC7 ||
        firstUnit > 0xFDF0 && firstUnit < 0xFDFC ||
        firstUnit > 0xFE70 && firstUnit < 0xFE74 ||
        firstUnit > 0xFE76 && firstUnit < 0xFEFC ||
        firstUnit > 0x10800 && firstUnit < 0x10805 ||
        firstUnit > 0x1B000 && firstUnit < 0x1B0FF ||
        firstUnit > 0x1D165 && firstUnit < 0x1D169 ||
        firstUnit > 0x1D16D && firstUnit < 0x1D172 ||
        firstUnit > 0x1D17B && firstUnit < 0x1D182 ||
        firstUnit > 0x1D185 && firstUnit < 0x1D18B ||
        firstUnit > 0x1D1AA && firstUnit < 0x1D1AD ||
        firstUnit > 0x1D242 && firstUnit < 0x1D244) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  static int getLayout({
    required TextDirection titleDir,
    required TextDirection contentDir,
    required String title,
    required String content,
  }) {
    int layout = 0;
    if (titleDir == TextDirection.ltr && contentDir == TextDirection.ltr) {
      layout = 0;
    } else if (titleDir == TextDirection.rtl &&
        contentDir == TextDirection.rtl) {
      layout = 1;
    } else if (titleDir == TextDirection.ltr &&
        contentDir == TextDirection.rtl) {
      if (title == "") {
        layout = 1;
      } else {
        layout = 2;
      }
    } else {
      if (content == "") {
        layout = 1;
      } else {
        layout = 3;
      }
    }
    return layout;
  }

  static String parseDate(String stringDate) {
    var date = DateTime.parse(stringDate);
    String parsedDate = DateFormat.EEEE().format(date);
    String parsedDate0 = DateFormat.H().format(date);
    String parsedDate1 = DateFormat.m().format(date);
    String parsedDate2 = DateFormat.s().format(date);
    return parsedDate + parsedDate0 + parsedDate1 + parsedDate2;
  }

  static int calculateDifference(String stringDate) {
    var date = DateTime.parse(stringDate);
    DateTime now = DateTime.now();
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  static String parsedDate(String stringDate, String lang) {
    var date = DateTime.parse(stringDate);
    String parsedDate = DateFormat.MMMMd().format(date);
    List<String> translate = parsedDate.split(' ');
    parsedDate = lang == 'en'
        ? parsedDate
        : "${translate[1]} ${translate[0].tr()}";
    return parsedDate;
  }

  static Color parseColor(dynamic input) {
    int color;

    if (input is int) {
      color = input;
    } else if (input is String) {
      String cleaned = input.trim().toUpperCase();

      // Remove common prefixes
      if (cleaned.startsWith('#')) cleaned = cleaned.substring(1);
      if (cleaned.startsWith('0X')) cleaned = cleaned.substring(2);

      if (RegExp(r'^\d+$').hasMatch(cleaned)) {
        // Pure decimal string
        color = int.parse(cleaned);
      } else if (RegExp(r'^[0-9A-F]{8}$').hasMatch(cleaned)) {
        // 8-char ARGB hex
        color = int.parse(cleaned, radix: 16);
      } else {
        throw FormatException("Invalid color format: $input");
      }
    } else {
      throw ArgumentError("Unsupported input type: ${input.runtimeType}");
    }

    return Color(color);
  }
}

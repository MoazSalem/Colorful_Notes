import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:notes/Widgets/sound_player.dart';

Widget listView({
  required BuildContext context,
  required List<Map> notes,
  required List<Color> colors,
  required int index,
  required int dateValue,
  required String date,
  required bool noTitle,
  required bool noContent,
  required bool showDate,
  required bool showShadow,
  required bool showEdited,
  required String lang,
  required double width,
  required bool isTablet,
}) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: showShadow ? width * 0.0051 : 0),
      child: Stack(alignment: Alignment.topRight, children: [
        SizedBox(
          height: isTablet ? width * 0.9 : width * 0.7639,
          child: Card(
            color: notes[index]['cindex'] == 99
                ? Color(int.parse(notes[index]['extra']))
                : colors[notes[index]['cindex']],
            elevation: showShadow ? 4 : 0,
            shadowColor: notes[index]['cindex'] == 99
                ? Color(int.parse(notes[index]['extra']))
                : colors[notes[index]['cindex']],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05092,
                  right: width * 0.05092,
                  top: width * 0.07639,
                  bottom: showDate ? width * 0.03819 : width * 0.02546),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                noTitle
                    ? Container()
                    : Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(notes[index]["title"],
                              maxLines: notes[index]["type"] == 0
                                  ? isTablet
                                      ? 2
                                      : 1
                                  : 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              textDirection:
                                  notes[index]["layout"] == 0 || notes[index]["layout"] == 2
                                      ? TextDirection.ltr
                                      : TextDirection.rtl,
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                  color:
                                      notes[index]['tindex'] == 0 ? Colors.white : Colors.black)),
                        ),
                      ),
                notes[index]["type"] == 0
                    ? Expanded(
                        flex: 7,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(noContent ? "Empty".tr() : notes[index]["content"],
                              textAlign: notes[index]["layout"] == 1 || notes[index]["layout"] == 2
                                  ? TextAlign.right
                                  : TextAlign.left,
                              textDirection:
                                  notes[index]["layout"] == 1 || notes[index]["layout"] == 2
                                      ? TextDirection.rtl
                                      : TextDirection.ltr,
                              maxLines: showDate
                                  ? isTablet
                                      ? 20
                                      : 8
                                  : isTablet
                                      ? 20
                                      : 9,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: noContent
                                      ? notes[index]['tindex'] == 0
                                          ? Colors.white38
                                          : Colors.black38
                                      : notes[index]['tindex'] == 0
                                          ? Colors.white
                                          : Colors.black,
                                  fontSize: noTitle ? 21 : 16)),
                        ),
                      )
                    : Expanded(
                        flex: noTitle ? 7 : 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: showDate
                                      ? noTitle
                                          ? width * 0.063657
                                          : 0
                                      : 0),
                              child: SoundPlayer(
                                index: index,
                                voiceMap: notes,
                                color: notes[index]['cindex'] == 99
                                    ? Color(int.parse(notes[index]['extra']))
                                    : colors[notes[index]['cindex']],
                                viewMode: 0,
                                isTablet: isTablet,
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: width * 0.02546,
                ),
                showDate
                    ? Expanded(
                        child: Stack(
                          alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                          children: [
                            Text(
                              dateValue == 0
                                  ? "Today".tr()
                                  : dateValue == -1
                                      ? "Yesterday".tr()
                                      : date,
                              style: TextStyle(
                                  color: notes[index]['tindex'] == 0 ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  showEdited
                                      ? notes[index]["edited"] == "yes"
                                          ? "Edited".tr()
                                          : ""
                                      : "",
                                  style: TextStyle(
                                      color: notes[index]['tindex'] == 0
                                          ? Colors.white38
                                          : Colors.black38),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(),
              ]),
            ),
          ),
        ),
      ]),
    ),
  );
}

Widget smallListView({
  required BuildContext context,
  required List<Map> notes,
  required List<Color> colors,
  required int index,
  required int dateValue,
  required String date,
  required bool noTitle,
  required bool noContent,
  required bool showDate,
  required bool showShadow,
  required bool showEdited,
  required String lang,
  required double width,
  required bool isTablet,
}) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: showShadow ? width * 0.0051 : 0),
      child: Stack(alignment: Alignment.topCenter, children: [
        SizedBox(
          height: width * 0.2801,
          width: width,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Card(
                color: notes[index]['cindex'] == 99
                    ? Color(int.parse(notes[index]['extra']))
                    : colors[notes[index]['cindex']],
                elevation: showShadow ? width * 0.01018 : 0,
                shadowColor: notes[index]['cindex'] == 99
                    ? Color(int.parse(notes[index]['extra']))
                    : colors[notes[index]['cindex']],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: SizedBox(
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: notes[index]["type"] == 0 ? width * 0.038194 : width * 0.01273,
                        right: noTitle ? width * 0.076388 : width * 0.05092,
                        top: notes[index]["type"] == 0
                            ? noTitle
                                ? width * 0.035648
                                : width * 0.030555
                            : 0,
                        bottom: showDate ? 0.02546 : 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      noTitle
                          ? Container()
                          : notes[index]["type"] == 0
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      right:
                                          notes[index]["layout"] == 0 || notes[index]["layout"] == 2
                                              ? width * 0.050926
                                              : 0,
                                      left:
                                          notes[index]["layout"] == 0 || notes[index]["layout"] == 2
                                              ? 0
                                              : width * 0.050926),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: notes[index]["layout"] == 0 ? 0 : width * 0.02546,
                                          bottom: notes[index]["layout"] == 0
                                              ? 0
                                              : notes[index]["layout"] == 2
                                                  ? width * 0.01273
                                                  : width * 0.02037),
                                      child: Text(notes[index]["title"],
                                          strutStyle: StrutStyle(
                                            forceStrutHeight:
                                                notes[index]["layout"] == 0 ? false : true,
                                          ),
                                          textAlign: notes[index]["layout"] == 0 ||
                                                  notes[index]["layout"] == 2
                                              ? TextAlign.left
                                              : TextAlign.right,
                                          textDirection: notes[index]["layout"] == 0 ||
                                                  notes[index]["layout"] == 2
                                              ? TextDirection.ltr
                                              : TextDirection.rtl,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 22,
                                              color: notes[index]['tindex'] == 0
                                                  ? Colors.white
                                                  : Colors.black)),
                                    ),
                                  ),
                                )
                              : Container(),
                      notes[index]["type"] == 0
                          ? Expanded(
                              flex: noTitle ? 2 : 1,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.only(top: isTablet ? 8 : 0),
                                  child: Text(noContent ? "Empty".tr() : notes[index]["content"],
                                      strutStyle: StrutStyle(
                                        forceStrutHeight: notes[index]["layout"] == 0 ||
                                                notes[index]["layout"] == 1
                                            ? false
                                            : true,
                                      ),
                                      textAlign:
                                          notes[index]["layout"] == 1 || notes[index]["layout"] == 2
                                              ? TextAlign.right
                                              : TextAlign.left,
                                      textDirection:
                                          notes[index]["layout"] == 1 || notes[index]["layout"] == 2
                                              ? TextDirection.rtl
                                              : TextDirection.ltr,
                                      maxLines: noTitle
                                          ? showDate
                                              ? isTablet
                                                  ? 4
                                                  : 2
                                              : isTablet
                                                  ? 4
                                                  : 3
                                          : showDate
                                              ? isTablet
                                                  ? 3
                                                  : 1
                                              : isTablet
                                                  ? 4
                                                  : 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: noContent
                                            ? notes[index]['tindex'] == 0
                                                ? Colors.white38
                                                : Colors.black38
                                            : notes[index]['tindex'] == 0
                                                ? Colors.white
                                                : Colors.black,
                                        fontSize: noTitle ? 21 : 16,
                                      )),
                                ),
                              ),
                            )
                          : Expanded(
                              flex: noTitle ? 2 : 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.02037),
                                    child: SoundPlayer(
                                      index: index,
                                      voiceMap: notes,
                                      color: notes[index]['cindex'] == 99
                                          ? Color(int.parse(notes[index]['extra']))
                                          : colors[notes[index]['cindex']],
                                      viewMode: 1,
                                      isTablet: isTablet,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ]),
                  ),
                ),
              ),
              showDate
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: width * 0.030555, horizontal: width * 0.050926),
                      child: Stack(
                        alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                        children: [
                          Text(
                            dateValue == 0
                                ? "Today".tr()
                                : dateValue == -1
                                    ? "Yesterday".tr()
                                    : date,
                            style: TextStyle(
                                color: notes[index]['tindex'] == 0 ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                showEdited
                                    ? notes[index]["edited"] == "yes"
                                        ? "Edited".tr()
                                        : ""
                                    : "",
                                style: TextStyle(
                                    color: notes[index]['tindex'] == 0
                                        ? Colors.white38
                                        : Colors.black38),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        noTitle
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(
                    vertical: showDate ? width * 0.03564 : width * 0.04074,
                    horizontal: width * 0.203703),
                child: notes[index]["type"] == 0
                    ? Container()
                    : Text(
                        notes[index]["title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: notes[index]['tindex'] == 0 ? Colors.white : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
              ),
      ]),
    ),
  );
}

Widget gridView({
  required BuildContext context,
  required List<Map> notes,
  required List<Color> colors,
  required int index,
  required int dateValue,
  required String date,
  required bool noTitle,
  required bool noContent,
  required bool showDate,
  required bool showShadow,
  required bool showEdited,
  required String lang,
  required double width,
  required bool isTablet,
}) {
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: showShadow ? width * 0.0051 : 0),
      child: Stack(alignment: Alignment.topRight, children: [
        SizedBox(
          height: width * 0.4584,
          width: width * 0.4584,
          child: Card(
            color: notes[index]['cindex'] == 99
                ? Color(int.parse(notes[index]['extra']))
                : colors[notes[index]['cindex']],
            elevation: showShadow ? width * 0.01018 : 0,
            shadowColor: notes[index]['cindex'] == 99
                ? Color(int.parse(notes[index]['extra']))
                : colors[notes[index]['cindex']],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: width * 0.03819,
                  right: width * 0.050926,
                  top: noTitle || notes[index]["type"] == 1
                      ? notes[index]["type"] == 1
                          ? width * 0.07384
                          : width * 0.03565
                      : width * 0.03565,
                  bottom: width * 0.02546),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                noTitle || notes[index]["type"] == 1
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(
                            bottom: width * 0.01528,
                            right: notes[index]["layout"] == 0 || notes[index]["layout"] == 2
                                ? width * 0.050926
                                : 0,
                            left: notes[index]["layout"] == 0 || notes[index]["layout"] == 2
                                ? 0
                                : width * 0.050926),
                        child: SizedBox(
                            width: double.infinity,
                            child: Text(notes[index]["title"],
                                textAlign:
                                    notes[index]["layout"] == 0 || notes[index]["layout"] == 2
                                        ? TextAlign.left
                                        : TextAlign.right,
                                textDirection:
                                    notes[index]["layout"] == 0 || notes[index]["layout"] == 2
                                        ? TextDirection.ltr
                                        : TextDirection.rtl,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                    color: notes[index]['tindex'] == 0
                                        ? Colors.white
                                        : Colors.black))),
                      ),
                notes[index]["type"] == 0
                    ? Expanded(
                        flex: noTitle ? 3 : 2,
                        child: Padding(
                          padding: EdgeInsets.only(right: noTitle ? width * 0.020926 : 0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(noContent ? "Empty".tr() : notes[index]["content"],
                                textAlign:
                                    notes[index]["layout"] == 1 || notes[index]["layout"] == 2
                                        ? TextAlign.right
                                        : TextAlign.left,
                                textDirection:
                                    notes[index]["layout"] == 1 || notes[index]["layout"] == 2
                                        ? TextDirection.rtl
                                        : TextDirection.ltr,
                                maxLines: noTitle
                                    ? showDate
                                        ? isTablet
                                            ? 9
                                            : 4
                                        : isTablet
                                            ? 10
                                            : 4
                                    : showDate
                                        ? isTablet
                                            ? 9
                                            : 2
                                        : isTablet
                                            ? 10
                                            : 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: noContent
                                        ? notes[index]['tindex'] == 0
                                            ? Colors.white38
                                            : Colors.black38
                                        : notes[index]['tindex'] == 0
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: noTitle ? 18 : 13)),
                          ),
                        ),
                      )
                    : Expanded(
                        flex: noTitle ? 3 : 2,
                        child: SoundPlayer(
                          index: index,
                          voiceMap: notes,
                          color: notes[index]['cindex'] == 99
                              ? Color(int.parse(notes[index]['extra']))
                              : colors[notes[index]['cindex']],
                          viewMode: 3,
                          isTablet: isTablet,
                        ),
                      ),
                showDate
                    ? Stack(
                        alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                        children: [
                          Text(
                            dateValue == 0
                                ? "Today".tr()
                                : dateValue == -1
                                    ? "Yesterday".tr()
                                    : date,
                            style: TextStyle(
                                color: notes[index]['tindex'] == 0 ? Colors.white : Colors.black,
                                fontSize: notes[index]["type"] == 0 ? 13 : 12,
                                fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                showEdited
                                    ? notes[index]["edited"] == "yes"
                                        ? "Edited".tr()
                                        : ""
                                    : "",
                                style: TextStyle(
                                    color: notes[index]['tindex'] == 0
                                        ? Colors.white38
                                        : Colors.black38),
                              )
                            ],
                          )
                        ],
                      )
                    : Container(),
              ]),
            ),
          ),
        ),
      ]),
    ),
  );
}
